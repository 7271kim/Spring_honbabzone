package com.honbabzone.tomcat.board.simsim.controller;

import java.io.File;
import java.net.URLEncoder;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.honbabzone.tomcat.board.model.BoardBean;
import com.honbabzone.tomcat.board.model.CommentBean;
import com.honbabzone.tomcat.board.simsim.service.SimsimCommentService;
import com.honbabzone.tomcat.board.simsim.service.SimsimService;
import com.honbabzone.tomcat.mem.service.MemService;
import com.honbabzone.tomcat.utile.CommonConfig;
import com.honbabzone.tomcat.utile.FileUpload;
import com.honbabzone.tomcat.utile.Paging;
import com.honbabzone.tomcat.utile.RequestSetting;

/**
 * Handles requests for the application home page.
 */
@Controller
@RequestMapping("/board/simsim/") 
public class SimsimController {
	
	private static final Logger logger     = LoggerFactory.getLogger(SimsimController.class);
    private static CommonConfig cfg         = new CommonConfig();
    private static String returnUrl         = cfg.getSimsimUrl();
    private static String serverFolder      = cfg.getRemoteSimSimSaveFolder();
    private static String localSaveFolder   = cfg.getLocalSimSimSaveFolder();
    private static String[] allowFiles      = cfg.getAllowFile().split(",");
    private static Long allowFileSize       = Long.valueOf( cfg.getAllowFileSize() );
    private static Boolean isDev            = cfg.getDevelopment().equals("1") ? true : false;
    
    @Autowired
    SimsimService sismsim;
    
    @Autowired
    SimsimCommentService simsimCommentService;
    
	@RequestMapping(value = "list.do", method = RequestMethod.GET)
    public String listPage( Model model ,HttpSession session, HttpServletRequest request, HttpServletResponse response, BoardBean bean) {
	    String pageNum = request.getParameter("pageNum") != null ?  request.getParameter("pageNum") : "1";
	    String searchField = request.getParameter("searchField") != null ?  request.getParameter("searchField") : "";
	    String searchString = request.getParameter("searchString") != null ?  request.getParameter("searchString") : "";
        String showGrid = request.getParameter("showGrid") != null ?  request.getParameter("showGrid") : "10";
	    HashMap<String, String> like = new HashMap<>();
	    HashMap<String, String> where = new HashMap<>();
	    where.put("USEFLAG", "0");
	    bean.setWhere(where);
	    
	    switch ( searchField ) {
        case "sTitle":
            like.put("STITLE", searchString);
            bean.setLike(like);
            
            break;
        case "sTitleContents":
            like.put("STITLE", searchString);
            like.put("SCONTENT", searchString);
            bean.setLike(like);
            break;
        case "sWriter":
            like.put("ID", searchString);
            bean.setLike(like);
            break;
        }
	    
	    List<BoardBean> boardBeans = sismsim.getbordList(bean);
	    //총 갯수 구하기
	    Paging paging = new Paging(boardBeans.size(), pageNum,  Integer.parseInt(showGrid), 5 );
	    
	    // 뿌릴꺼만 가지고 오기
	    bean.setLimitStart(paging.getStartRow());
	    bean.setLimitEnd(paging.getPageSize());
	    boardBeans = sismsim.getbordList(bean);
	    model.addAttribute("currnetPage", pageNum);
	    model.addAttribute("searchField", searchField);
	    model.addAttribute("searchString", searchString);
	    model.addAttribute("showGrid", showGrid);
	    model.addAttribute("boadList",boardBeans);
	    model.addAttribute("paging",paging);

	    return "/board/simsim/list";
    }
	
	@RequestMapping(value = "write.do", method = RequestMethod.POST)
    public String writeSimsim( Model model ,HttpSession session, BoardBean bean, MultipartHttpServletRequest mRequest) {
		/* 
		 * Iterator를 통해서 하는 경우는 들어오는 input file 필드자체가 여러개일 때! 사용하는 것! 
		 * multiple를 쓰기 위해서는  List<MultipartFile> files = mRequest.getFiles("test[]"); 를통해서 각각의 파일을 선택해야 한다.
		 *  
		 * */
	    FileUpload fileUpload  = new FileUpload();
	    String sFilename = "";
	    List<MultipartFile> files = mRequest.getFiles("userfile[]");
	    
	    ArrayList<String> upLoadResult = fileUpload.uploadFiles(mRequest, files, isDev, localSaveFolder, serverFolder, false, allowFiles, allowFileSize);
	    String msg = "";
	    if( files.size() > 0 ) {
	        sFilename  = String.join(",", fileUpload.getSaveFileNames());
	        if( !sFilename.equals("") ) {
	            bean.setsFilename(sFilename);
	            bean.setsFilepath(fileUpload.getSaveFolder());
	        }
	       
	        try {
	            if( upLoadResult.size() >0 ) {
	                String resultSet = String.join(",", upLoadResult);
	                msg = "&msg="+URLEncoder.encode(resultSet+"번째 파일의 용량 및 확장자가 잘못되어 업로드 되지 못했습니다.", "UTF-8");
	            }
			} catch (Exception e) {

			}
	        
	    }
	    
	    bean.setId(session.getAttribute("loginIdCk").toString());
	    int returnSeq = sismsim.boardInsert(bean);
	    
        return "redirect:"+returnUrl+"detail.do?seq="+returnSeq+"&pageNum=1"+msg;
    }
	
	@RequestMapping(value = "remove.do", method = RequestMethod.GET)
    public String remove( Model model ,HttpSession session, BoardBean bean, HttpServletRequest request) {
        FileUpload fileUpload  = new FileUpload();
        String seq             = request.getParameter("seq");
        
        BoardBean getOne = getOne(seq);
        if(!getOne.getId().equals(session.getAttribute("loginIdCk").toString()) ) {
            model.addAttribute("msg","잘못된 접근 입니다.");
            return "forward:redirect.do";
        }
        
        String sFilename       = getOne.getsFilename();
        String sFilePath       = getOne.getsFilepath();
        
        //파일 전체 지우기 안함 .. 글을 그냥 숨길것임
        //fileUpload.removeFiles(sFilePath, sFilename);
        
        HashMap<String, String> where = new HashMap<>();
        bean.setUseFlag(1);
        where.put("SEQ", seq);
        bean.setWhere(where);
        
        sismsim.boardUpdate(bean);
        
        RequestSetting requestSetting = new RequestSetting(request);
        String requestParam = requestSetting.getReturnRequestString();
        
        return "redirect:"+returnUrl+"list.do"+requestParam;
    }
	
	@RequestMapping(value = "update.do", method = RequestMethod.POST)
    public String update( Model model ,HttpSession session, BoardBean bean, MultipartHttpServletRequest mRequest, HttpServletRequest request) {
        FileUpload fileUpload  = new FileUpload();
        HashMap<String, String> where = new HashMap<>();
        String msg = "";
        String sFilename = "";
        List<MultipartFile> files = mRequest.getFiles("userfile[]");
        String thisSeq = request.getParameter("seqThis");
        String pageNum = request.getParameter("pageNum") != null ? request.getParameter("pageNum") : "1";
        String searchField = request.getParameter("searchField");
        String searchString = request.getParameter("searchString");
        BoardBean getOne = getOne(thisSeq);
        if(!getOne.getId().equals(session.getAttribute("loginIdCk").toString()) ) {
            model.addAttribute("msg","잘못된 접근 입니다.");
            return "forward:redirect.do";
        }
        
        if( thisSeq != null ) {
            // 수정 할 파일이 있다면 기존 것 지우기 아니면 유지
            if( files.size() > 0 && !files.get(0).isEmpty() ) {
                fileUpload.setRemoveFileName(getOne.getsFilename());
                fileUpload.setRemovePath(getOne.getsFilepath());
                ArrayList<String> upLoadResult = fileUpload.uploadFiles(mRequest, files, isDev, localSaveFolder, serverFolder, true, allowFiles, allowFileSize);

                sFilename  = String.join(",", fileUpload.getSaveFileNames());
                if( !sFilename.equals("") ) {
                    bean.setsFilename(sFilename);
                    bean.setsFilepath(fileUpload.getSaveFolder());
                }
               
                try {
                    if( upLoadResult.size() >0 ) {
                        String resultSet = String.join(",", upLoadResult);
                        msg = "&msg="+URLEncoder.encode(resultSet+"번째 파일의 용량 및 확장자가 잘못되어 업로드 되지 못했습니다.", "UTF-8");
                    }
                } catch (Exception e) {

                }
                
            }
            where.put("SEQ", thisSeq);
            bean.setsJoinUpdate(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
            bean.setWhere(where);
            sismsim.boardUpdate(bean);
            
        }
        
        return "redirect:"+returnUrl+"detail.do?seq="+thisSeq+"&pageNum="+pageNum+"&searchField="+searchField+"&searchString="+searchString+msg;
    }
	
   @RequestMapping(value = "detail.do", method = RequestMethod.GET)
    public String detail( Model model ,HttpSession session, HttpServletRequest request, BoardBean bean, CommentBean commentBean) {
        HashMap<String, String> where = new HashMap<>();
        String filenames[];
        String seq = request.getParameter("seq").toString();
        where.put("sim.SEQ", seq);
        bean.setWhere(where);
        List<BoardBean> boardBeans = sismsim.getbordList(bean);
        
        where.clear();
        where.put("SGROUP",seq);
        if(request.getParameter("limitEnd")==null || request.getParameter("limitEnd")=="") {
            commentBean.setLimitEnd(5);
        }else {
            commentBean.setLimitEnd(Integer.parseInt(request.getParameter("limitEnd")));
        }
        commentBean.setWhere(where);
        List<CommentBean> commentBeans = simsimCommentService.getCommentList(commentBean);
        if(boardBeans.get(0).getsFilename() != null) {
            filenames  = boardBeans.get(0).getsFilename().split(",");
            model.addAttribute("filenames",filenames);
        }
        
        boardBeans.get(0).setsContent(boardBeans.get(0).getsContent().replaceAll("&#40;", "(").replaceAll("&#41;", ")").replaceAll("\r\n", "<br>").replaceAll("&#39;", "'").replaceAll("&lt;", "<").replaceAll("&gt;",">").replaceAll("\"", "'"));
        model.addAttribute("detail",boardBeans.get(0));
        model.addAttribute("commentBeans",commentBeans);
        
        return returnUrl+"detail";
    }
   
   @RequestMapping(value = "download.do", method = RequestMethod.GET)
   public void download( HttpServletRequest request, BoardBean bean, HttpServletResponse response ) {
       String seq       = request.getParameter("seq");
       String fileName  = request.getParameter("name");
       String filePath  = "";
       
       bean = getOne(seq);
       filePath = bean.getsFilepath();
       
       FileUpload fileUpload = new FileUpload();
       fileUpload.downloadFiles(response, fileName, filePath);
   }
   
   @RequestMapping(value = "update_view.do", method = RequestMethod.GET)
   public String updateView( Model model, HttpSession session, HttpServletRequest request, BoardBean bean ) {
       HashMap<String, String> where = new HashMap<>();
       String seq = request.getParameter("seq").toString();
       where.put("sim.SEQ", seq);
       bean.setWhere(where);
       List<BoardBean> boardBeans = sismsim.getbordList(bean);
       
       if(!boardBeans.get(0).getId().equals(session.getAttribute("loginIdCk").toString()) ) {
           model.addAttribute("msg","잘못된 접근 입니다.");
           return "forward:redirect.do";
       }
       
       boardBeans.get(0).setsContent(boardBeans.get(0).getsContent().replaceAll("&#40;", "(").replaceAll("&#41;", ")").replaceAll("\r\n", "<br>").replaceAll("&#39;", "'").replaceAll("&lt;", "<").replaceAll("&gt;",">").replaceAll("\"", "'"));
       model.addAttribute("detail",boardBeans.get(0));
       
       return returnUrl+"update_view";
   }
   

   @RequestMapping(value = "commentWrite.do", method = RequestMethod.POST)
    public String commentWrite( Model model ,HttpSession session, HttpServletRequest request, CommentBean commentBean) {
        if(commentBean.getsContent() == "" || commentBean.getsContent() == null ) {
            model.addAttribute("msg","내용을 입력하세요");
            return "forward:redirect.do";
        }
        commentBean.setId(session.getAttribute("loginIdCk").toString());
        commentBean.setIsChild(0);
        simsimCommentService.commnetInsert(commentBean);
        RequestSetting requestSetting = new RequestSetting(request);
        String requestParam = requestSetting.getReturnRequestString();
        return "redirect:"+returnUrl+"detail.do"+requestParam;
    }
   
   @RequestMapping(value = "commentReWrite.do", method = RequestMethod.POST)
   public String commentReWrite( Model model ,HttpSession session, HttpServletRequest request, CommentBean commentBean) {
       if(commentBean.getsContent() == "" || commentBean.getsContent() == null ) {
           model.addAttribute("msg","내용을 입력하세요");
           return "forward:redirect.do";
       }
       commentBean.setId(session.getAttribute("loginIdCk").toString());
       commentBean.setIsChild(1);
       simsimCommentService.commnetInsert(commentBean);
       RequestSetting requestSetting = new RequestSetting(request);
       String requestParam = requestSetting.getReturnRequestString();
       return "redirect:"+returnUrl+"detail.do"+requestParam;
   }
   
   @ResponseBody
   @RequestMapping(value = "comment-more-get.do", method = RequestMethod.GET)
   public List<CommentBean> commentMoreGet(  CommentBean commentBean, @RequestParam String startLine, @RequestParam String seq ) {
       commentBean.setLimitStart(Integer.parseInt(startLine));
       commentBean.setLimitEnd(5);
       HashMap<String, String> where = new HashMap<>();
       where.put("SGROUP", seq);
       where.put("ISCHILD", "0");
       commentBean.setWhere(where);
       List<CommentBean> commentBeans = simsimCommentService.getCommentList(commentBean);
       return commentBeans;
   }
   
   @ResponseBody
   @RequestMapping(value = "re-comment-check.do", method = RequestMethod.POST)
   public List<CommentBean> reCommentCheck(  CommentBean commentBean, @RequestParam String sGroup  ) {
       HashMap<String, String> where = new HashMap<>();
       where.put("SGROUP", sGroup);
       where.put("ISCHILD", "1");
       commentBean.setWhere(where);
       List<CommentBean> commentBeans = simsimCommentService.getCommentList(commentBean);
       return commentBeans;
   }
   
	 @RequestMapping(value = "redirect.do")
	    public String redirectPage(  Model model, HttpServletRequest request ) {
	        if(request.getParameter("msg") != null) {
	            model.addAttribute("msg",request.getParameter("msg"));
	            model.addAttribute("url",request.getParameter("url"));
	        }
	        return "redirect";
	    }
	
	@RequestMapping(value = "{url}", method = RequestMethod.GET)
	public String indexPage( @PathVariable("url") String url ) {
		return returnUrl+url;
	}
	
	private BoardBean getOne ( String seq ) {
	    HashMap<String, String> where = new HashMap<>();
	    BoardBean bean = new BoardBean();
	    bean.setSeq(Integer.parseInt(seq));
	    where.put("sim.SEQ", seq);
	    bean.setWhere(where);
	    List<BoardBean> boardBeans = sismsim.getbordList(bean);
	    return boardBeans.get(0);
	}
	
}
