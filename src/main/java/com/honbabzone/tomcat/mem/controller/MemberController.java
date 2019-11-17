package com.honbabzone.tomcat.mem.controller;

import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.honbabzone.tomcat.mem.model.MemberBean;
import com.honbabzone.tomcat.mem.service.MemService;
import com.honbabzone.tomcat.utile.CommonConfig;
import com.honbabzone.tomcat.utile.CommonUtile;
import com.honbabzone.tomcat.utile.EmailSender;
import com.sun.javafx.sg.prism.NGShape.Mode;

@Controller
@RequestMapping("/mem/") 
/*/mem/으로 들엉오는 모든 로직 잡는다 */
public class MemberController {
    
    /*
     * return url을 전역적으로 설정해주기 위해
     * /WEB-INF/config/config.xml 여기서 설정 여기는 /mem/
     *  
     */
    
    /* @Autowired
     * CommonConfigBean cfg;
     * : @Autowired를 통한 변수 설정은 @RequestMapping안에서만 사용 가능하기 때문에 밖 전역변수로 사용하기 위해서는 
     *   /utile/CommonConfig.java 안에서 받아오는 부분을 따로 설정해주고 이 것을 아래와 같이 사용해야 한다.
     */
    
    private static final Logger logger = LoggerFactory.getLogger(MemberController.class);
    
    /* @Autowired
     * CommonConfigBean cfg;
     * : @Autowired를 통한 변수 설정은 @RequestMapping안에서만 cfg.getMemUrl()과 같이 사용 가능하기 때문에 밖 전역변수로 사용하기 위해서는 
     *   /utile/CommonConfig.java 안에서 받아오는 부분을 따로 설정해주고 이 것을 아래와 같이 사용해야 한다.
     */
    
    private static CommonConfig cfg = new CommonConfig();
    private String returnUrl        = cfg.getMemUrl(); // /mem/일것
    private String returnMainUrl        = cfg.getMainUrl(); 
     
    /*
     * @ResponseBody => ajax에서 자바 객체를 HTTP 응답 몸체로 전송 할 수 있게 도와주는 어노테이션
     * @RequestBody =>HTTP 요청 몸체를 자바 객체로 전달 받을 수 있다. 
     * @RequestParam(value="id") String id 혹은 @RequestParam String id 가능 (post에서 id로 보내줘야함) 
     *  
     */
    
    @Autowired
    MemService memService;
    
    @Autowired
    JavaMailSender mailSender;
    
    /*
     * redirect인지, forward인지, forward:redirect.do인지 구분해야한다.
     * 이슈 : requestMapping으로 들어온 것은 redirect를 쓰지 않는 이상 url은 일정한 상태에서 페이지만 바뀐다. 때문에 update 혹은 delete , insert등의 로직이 있는경우 항상 고려를 해야함
     * forward : attribute를 고대로 유지하지만 url이 변경되지 않는것은 동일 , redirect : url은 바뀌지만 addtribute를 상속받지 못해 서로 연관지어주지 못한다. 
     *  
     */
    
 
    @ResponseBody
    @RequestMapping(value = "id-check.do", method = RequestMethod.POST, produces="application/text; charset=utf8")
    public String idck( Model model,MemberBean memberBean , @RequestParam String id ) {
        //return 형 이슈! List형 int형은 다 잘 가는데 String 형 같은 경우 이슈가 있다. (   $.ajax 의 dataType을 text로 변경해야 한다.)
        // @RequestMapping(value = "id-check.do", method = RequestMethod.POST ,  produces="application/text; charset=utf8") 와같이
         //produces="application/text; charset=utf8"을 적어주는 이유는 return형이 String 이고 한글일 때 , ???로 나오기 때문 text형이 아니면 text를 바꿔주거나 사용하지 말자
         String result = "ok";
        // 설계 - HashMap을 통한 동적 SQL 생성할 것임.
        List<MemberBean> memberBeans        = new ArrayList<MemberBean>();
        HashMap<String, String> where       = new HashMap<String, String>();
        HashMap<String, String> whereNot    = new HashMap<String, String>();
        HashMap<String, String> like        = new HashMap<String, String>();
        where.put("ID", id);
        memberBean.setWhere(where);
        memberBeans = memService.getMemList(memberBean);
        
        if(memberBeans.size()!=0){
             memberBean     =  memberBeans.get(0);
             result         = checkId(memberBean).get("msg");
        }
        return result;
    }
    
    @ResponseBody
    @RequestMapping(value = "email-check.do", method = RequestMethod.POST, produces="application/text; charset=utf8")
    public String emailCk( Model model, MemberBean memberBean, @RequestParam String email ) {
        String result = "ok";
        List<MemberBean> memberBeans        = new ArrayList<MemberBean>();
        HashMap<String, String> where       = new HashMap<String, String>();
        HashMap<String, String> whereNot    = new HashMap<String, String>();
        HashMap<String, String> like        = new HashMap<String, String>();
        where.put("EMAIL", email);
        memberBean.setWhere(where);
        memberBeans = memService.getMemList(memberBean);
        
        if(memberBeans.size()!=0){
            memberBean =  memberBeans.get(0);
            result = "중복된 메일입니다.";
        }
        return result;
    }
    
    @RequestMapping(value = "join_certification.do", method = RequestMethod.GET)
    public String certificationEmail( HttpSession session, Model model, MemberBean memberBean, HttpServletRequest request) {
        // 어떤 토큰이든 초기화 및  메일 보내는 로직 , 토큰 시간 체크는 받는 쪽에서 할 것임
        if(session.getAttribute("emailChk") == null ) {
            model.addAttribute("msg","잘못된 접근입니다.");
            return "forward:redirect.do";
        }
        
        List<MemberBean> memberBeans        = new ArrayList<MemberBean>();
        MemberBean selectOne                = new MemberBean();
        HashMap<String, String> where       = new HashMap<String, String>();

        // /WEB-INF/config/mailsender.xml 해당 위치에 공통으로 사용할 mailSender 빈을 생성 해 놓음
        // /src/main/java/com/honbabzone/tomcat/utile/EmailSender.java에 보내는 로직 만들어 놓음
        EmailSender emailSender             = new EmailSender(mailSender);
        
        String id = session.getAttribute("emailChk").toString();
        String url = request.getRequestURL().toString();
        String uri = request.getRequestURI().toString();
        String conpath = request.getContextPath().toString();
        String home = url.replace(uri, conpath);
        String reciver = "";
        String title = "가입 승인 요청";
        String text = "";
        
        where.put("ID", id);
        memberBean.setWhere(where);
        memberBean.setId(id);
        emailUpdate(memberBean, request);
        memberBeans = memService.getMemList(memberBean);
        if( memberBeans.size() > 0 ) {
            selectOne = memberBeans.get(0);
            reciver = selectOne.getEmail();
            text = "웰컴 혼밥존. 아래 URL주소를 클릭해 주세요\n";
            text += home+"/mem/checkEmail.do?EMAILTOKEN="+selectOne.getEmailToken()+"&ID="+selectOne.getId();
            emailSender.sendMail(reciver, title, text);
        }
        Duration duration = Duration.between(LocalDateTime.parse(selectOne.getEmailTokenDate()).plusMinutes(6), LocalDateTime.now());
        String email = selectOne.getEmail();
        String encoding = "";
        for (int index = 0; index < email.length(); index++) {
            encoding += email.charAt(index)=='@' || email.charAt(index)=='.' || index % 2 == 0 ? email.charAt(index) : "*";
        }
        session.setAttribute("emailCountDown", Math.abs(duration.getSeconds()));
        session.setAttribute("email", encoding);
        session.setAttribute("msg","가입한 이메일을 확인해주세요");
        
        return "redirect:"+returnUrl+"join_certification_view.do";
    }
    
    @RequestMapping(value = "join_certification_view.do", method = RequestMethod.GET)
    public String certificationEmailView( HttpSession session, Model model, MemberBean memberBean, HttpServletRequest request) {
        // 어떤 토큰이든 초기화 및  메일 보내는 로직 , 토큰 시간 체크는 받는 쪽에서 할 것임
        if(session.getAttribute("emailChk") == null ) {
            model.addAttribute("msg","잘못된 접근입니다.");
            return "forward:redirect.do";
        }
        
        List<MemberBean> memberBeans        = new ArrayList<MemberBean>();
        MemberBean selectOne                = new MemberBean();
        HashMap<String, String> where       = new HashMap<String, String>();
        
        String id = session.getAttribute("emailChk").toString();
        where.put("ID", id);
        memberBean.setWhere(where);
        memberBean.setId(id);
        memberBeans = memService.getMemList(memberBean);
        if( memberBeans.size() > 0 ) {
            selectOne = memberBeans.get(0);
        }
        
        Long sec = 0l;
        if( LocalDateTime.now().isBefore(LocalDateTime.parse(selectOne.getEmailTokenDate()).plusMinutes(6))){
            sec = Duration.between(LocalDateTime.parse(selectOne.getEmailTokenDate()).plusMinutes(6), LocalDateTime.now()).getSeconds();
        }
        String email = selectOne.getEmail();
        String encoding = "";
        for (int index = 0; index < email.length(); index++) {
            encoding += email.charAt(index)=='@' || email.charAt(index)=='.' || index % 2 == 0 ? email.charAt(index) : "*";
        }
        session.setAttribute("emailCountDown", Math.abs(sec));
        session.setAttribute("email", encoding);
        
        return returnUrl+"join_certification_view";
    }
    @RequestMapping(value = "checkEmail.do", method = RequestMethod.GET)
    public String checkEail( HttpSession session, Model model, HttpServletRequest request) {
        // 어떤 토큰이든 초기화 및  메일 보내는 로직 , 토큰 시간 체크는 받는 쪽에서 할 것임
        String id = request.getParameter("ID");
        String emailToken = request.getParameter("EMAILTOKEN");
        List<MemberBean> memberBeans        = new ArrayList<MemberBean>();
        MemberBean memberBean               = new MemberBean();
        MemberBean selectOne                = new MemberBean();
        HashMap<String, String> where       = new HashMap<String, String>();
        
        where.put("ID", id);
        where.put("EMAILTOKEN", emailToken);
        memberBean.setWhere(where);
        memberBeans = memService.getMemList(memberBean);
        if( memberBeans.size() > 0 ) {
            selectOne = memberBeans.get(0);
            LocalDateTime nowTime = LocalDateTime.now();
            LocalDateTime emailTime = LocalDateTime.parse(selectOne.getEmailTokenDate()).plusMinutes(6);
            if( nowTime.isBefore(emailTime) ) {
                memberBean.setIsActivity(1);
                memService.memUpdate(memberBean);
                session.removeAttribute("emailChk");
                model.addAttribute("msg","이메일 인증 완료하였습니다. 다시 로그인해주세요");
                model.addAttribute("url",returnUrl+"login_view.do");
            } else {
                model.addAttribute("msg","이메일 인증시간이 넘었습니다. 다시 로그인 해주세요");
                model.addAttribute("url",returnUrl+"login_view.do");
            }
        }
        
        return "forward:redirect.do";
    }
    
    @RequestMapping(value = "id_find.do", method = RequestMethod.POST)
    public String id_find( Model model, MemberBean memberBean ) {
        String msg       = "";
        String encoding = "";
        List<MemberBean> memberBeans        = new ArrayList<MemberBean>();
        HashMap<String, String> where       = new HashMap<String, String>();
        MemberBean selectOne                = new MemberBean();
        where.put("EMAIL", memberBean.getEmail());
        memberBean.setWhere(where);
        memberBeans  = memService.getMemList(memberBean);
        if(memberBeans.size() > 0) {
            selectOne = memberBeans.get(0);
            msg = selectOne.getId();
            for (int index = 0; index < msg.length(); index++) {
                encoding += index == 0 || index == 1 || index == 2 ? msg.charAt(index) : "*";
            }
            msg = "가입하신 아이디는 : "+ encoding + " 입니다";
            model.addAttribute("url",returnUrl+"login_view.do");
        } else {
            msg = "이메일을 다시 확인하세요";
        }
        model.addAttribute("msg",msg);
        return "forward:redirect.do";
    }
    
    @RequestMapping(value = "pw_change.do", method = RequestMethod.GET)
    public String pw_change( Model model, MemberBean memberBean, HttpServletRequest request, HttpSession session ) {
        String msg       = "";
        String id        = request.getParameter("ID");
        String token        = request.getParameter("TOKEN");
        List<MemberBean> memberBeans        = new ArrayList<MemberBean>();
        HashMap<String, String> where       = new HashMap<String, String>();
        where.put("ID", id );
        where.put("EMAILTOKEN", token );
        memberBean.setWhere(where);
        memberBeans  = memService.getMemList(memberBean);
        if(memberBeans.size() > 0) {
            session.setAttribute("tempId", id);
            msg       = "비밀번호를 변경해주세요";
            model.addAttribute("url",returnUrl+"pw_change_view.do");
        } else {
            msg       = "잘못된 접근입니다.";
            model.addAttribute("url",returnUrl+"login_view.do");
        }
        model.addAttribute("msg",msg);
        return "forward:redirect.do";
    }
    
    @RequestMapping(value = "pw_change.do", method = RequestMethod.POST)
    public String pw_change_po( Model model, MemberBean memberBean, HttpServletRequest request, HttpSession session ) {
        
        String id = "";
        if( session.getAttribute("tempId") == null) {
            model.addAttribute("msg","잘못된 접근입니다.");
            return "forward:redirect.do";
        } else {
            id = session.getAttribute("tempId").toString();
        }
        HashMap<String, String> where       = new HashMap<String, String>();
        CommonUtile commonUtile             = new CommonUtile();
        memberBean.setPw(commonUtile.getSHA256(memberBean.getPw()));
        where.put("ID", id );
        memberBean.setWhere(where);
        memService.memUpdate(memberBean);
        model.addAttribute("msg","비밀번호 변경되셨습니다.");
        model.addAttribute("url",returnUrl+"login_view.do");
        session.removeAttribute("tempId");
        
        return "forward:redirect.do";
    }
    
    @RequestMapping(value = "pw_change_view.do", method = RequestMethod.GET)
    public String pw_change_view( Model model, MemberBean memberBean, HttpServletRequest request, HttpSession session ) {
        if( session.getAttribute("tempId") == null) {
            model.addAttribute("msg","잘못된 접근입니다.");
            return "forward:redirect.do";
        }
        return returnUrl+"pw_change_view";
    }
    
    
    @RequestMapping(value = "pw_find.do", method = RequestMethod.POST)
    public String pw_find( HttpSession session, Model model, MemberBean memberBean, HttpServletRequest request ) {
        String msg       = "";
        String reciver = "";
        String title = "비밀번호 변경";
        String text = "";
        String newToken = "";
        EmailSender emailSender             = new EmailSender(mailSender);
        CommonUtile commonUtile             = new CommonUtile();
        List<MemberBean> memberBeans        = new ArrayList<MemberBean>();
        HashMap<String, String> where       = new HashMap<String, String>();
        MemberBean selectOne                = new MemberBean();
        MemberBean updateOne                = new MemberBean();
        String url = request.getRequestURL().toString();
        String uri = request.getRequestURI().toString();
        String conpath = request.getContextPath().toString();
        String home = url.replace(uri, conpath);
        where.put("EMAIL", memberBean.getEmail());
        where.put("ID", memberBean.getId());
        memberBean.setWhere(where);
        memberBeans  = memService.getMemList(memberBean);
        if(memberBeans.size() > 0) {
            selectOne = memberBeans.get(0);
            newToken = commonUtile.generateToken();
            reciver = memberBean.getEmail();
            text = "비밀번호 변경을 위해. 아래 URL주소를 클릭해 주세요\n";
            text += home+"/mem/pw_change.do?TOKEN="+newToken+"&ID="+selectOne.getId();
            emailSender.sendMail(reciver, title, text);
            
            updateOne.setEmailToken(newToken);
            updateOne.setWhere(where);
            memService.memUpdate(updateOne);
            
            msg = "가입하신 메일을 확인하세요";
            model.addAttribute("url",returnUrl+"login_view.do");
        } else {
            msg = "ID와 이메일을 다시 확인하세요";
        }
        model.addAttribute("msg",msg);
        return "forward:redirect.do";
    }
    
    @RequestMapping(value = "login.do", method = RequestMethod.POST)
    public String login( HttpSession session, Model model, MemberBean memberBean, HttpServletRequest request ) {
        String msg       = "";
        List<MemberBean> memberBeans        = new ArrayList<MemberBean>();
        MemberBean selectOne                = new MemberBean();
        HashMap<String, String> where       = new HashMap<String, String>();
        HashMap<String, String> whereNot    = new HashMap<String, String>();
        HashMap<String, String> like        = new HashMap<String, String>();
        MemberBean updateBean               = new MemberBean();
        
        CommonUtile commonUtile             = new CommonUtile();
        where.put("ID", memberBean.getId());
        where.put("PW", commonUtile.getSHA256(memberBean.getPw()));
        
        memberBean.setWhere(where);
        memberBeans = memService.getMemList(memberBean);
        
        if( memberBeans.size()!=0 ) {
            selectOne =  memberBeans.get(0);
            LocalDate localDate = LocalDate.now();
            
            if( selectOne.getIsActivity() == 0 ) {
                session.setAttribute("emailChk" ,selectOne.getId());
                model.addAttribute("msg", "이메일 인증이 필요합니다." );
                model.addAttribute("url", returnUrl+"join_certification.do" );
                return "forward:redirect.do";
                
            } else if ( selectOne.getIsActivity() == 2 ) {
                LocalDate outDate   = LocalDate.parse(selectOne.getOutDate());
                if(localDate.isBefore(outDate.plusMonths(3))) {
                    model.addAttribute("msg", "탈퇴한지 3개월이 되지 않은 아이디 입니다." );
                    return "forward:redirect.do";
                    
                } else {
                    session.setAttribute("emailChk" ,selectOne.getId());
                    model.addAttribute("msg", "탈퇴한지 3개월이 넘어 신규 이메일 인증이 필요합니다" );
                    model.addAttribute("url", returnUrl+"join_certification.do" );
                    return "forward:redirect.do";
                }
            } else if( selectOne.getIsActivity() == 3 ) {
                LocalDate outDate   = LocalDate.parse(selectOne.getOutDate());
                if(localDate.isBefore(outDate.plusMonths(6))) {
                    model.addAttribute("msg", "계정이 정지 당한지 6개월이 되지 않은 아이디 입니다." );
                    return "forward:redirect.do";
                } else {
                    session.setAttribute("emailChk" ,selectOne.getId());
                    model.addAttribute("msg", "계정이 정지 당한지 6개월 넘어 신규 이메일 인증이 필요합니다" );
                    model.addAttribute("url", returnUrl+"join_certification.do" );
                    return "forward:redirect.do";
                }
            }
            
         } else {
             //로그인 카운트 +1
             where.clear();
             where.put("ID", memberBean.getId());
             memberBean.setWhere(where);
             memberBeans = memService.getMemList(memberBean);
             if( memberBeans.size()!=0 ) {
                 selectOne =  memberBeans.get(0);
                 updateBean.setLoginCount( selectOne.getLoginCount() + 1 );
                 updateBean.setWhere(where);
                 memService.memUpdate(updateBean);
                 
                 if( selectOne.getLoginCount() > 1) {
                     session.setAttribute("checkBotChk" ,"true");
                 }
             }
             
            model.addAttribute("msg", "아이디 정보와 pw정보를 확인하세요" );
            model.addAttribute("url", returnUrl+"login_view.do" );
            return "forward:redirect.do";
        }
        updateBean.setLastLogin(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
        updateBean.setTotalLoginCount(selectOne.getTotalLoginCount() + 1);
        updateBean.setLoginCount(0);
        updateBean.setWhere(where);
        memService.memUpdate(updateBean);
        session.setAttribute("loginIdCk" ,memberBean.getId());
        session.removeAttribute("checkBotChk");
        if(selectOne.getAuthorization() == 0) {
            session.setAttribute("isAdminCk" ,"true");
        }
        return "redirect:"+returnMainUrl+"main.do";
    }
    
    @RequestMapping(value = "join.do", method = RequestMethod.POST)
    public String join( Model model, MemberBean memberBean, HttpServletRequest request ) {
        // 이메일 pw, ID, email 전부 잃어버렸을시.... 노답. 신규 가입 혹은 문의를 해야함. 특히 이메일 수정은 비번없이는 못하기 때문에 중요.
        HttpSession session = request.getSession();
        if(session.getAttribute("loginIdCk ") != null) {
            model.addAttribute("msg", "로그인 중이십니다." );
            return "forward:redirect.do";
        }
        
        String msg       = "";
        int insertResult = 0;
        
        List<MemberBean> memberBeans        = new ArrayList<MemberBean>();
        MemberBean selectOne                = new MemberBean();
        HashMap<String, String> where       = new HashMap<String, String>();
        HashMap<String, String> whereNot    = new HashMap<String, String>();
        HashMap<String, String> like        = new HashMap<String, String>();
        CommonUtile commonUtile             = new CommonUtile();
        // 1. email check (프론트에서 막지만 한번 더 방어 )
        
        where.put("EMAIL", memberBean.getEmail());
        memberBean.setWhere(where);
        memberBeans = memService.getMemList(memberBean);
        
        if(memberBeans.size()!=0){
            // 원하는 url 담아줄 수 있음 model.addAttribute("url", "/mem/login_view.do" );
            model.addAttribute("msg", "중복된 이메일이 존재합니다." );
            
            return "forward:redirect.do";
        }
        //모든 객체 지우기 
        where.clear();
        where.put("ID", memberBean.getId());
        memberBean.setWhere(where);
        memberBeans = memService.getMemList(memberBean);
        if(memberBeans.size()!=0){
            selectOne =  memberBeans.get(0);
            HashMap<String, String> checkId = checkId(selectOne);
            // 비정상 접근으로 회원 가입 방어
            // 가입중 , block, 탈퇴한 아이디 확인, 이메일 인증중인 아이디 확인 
            model.addAttribute("msg", checkId.get("msg") );
            model.addAttribute("url", checkId.get("url"));
            return "forward:redirect.do";
        } else {
           // 완전 첫 아이디 , 비번 암호화 세팅 !
            memberBean.setPw(commonUtile.getSHA256(memberBean.getPw()));
            memberBean.setEmailToken(commonUtile.generateToken());
            insertResult = memService.memInsert(memberBean);
            
            session.setAttribute("emailChk" ,memberBean.getId());
            
            // nas 참고하기  아직 메일 인증 중이었음 : 중간 결과 가지고 오는 것때문 돌아감
        }
        // join.do로 들어왔지만 return을 redirect로 하지 않으면 url 이동이 없기 때문에 새로고침시 무한 회원가입이 된다.
        // 무한 회원가입 방지! redirect : 경우 url로 들어가기 떄문에 .do필요!
        
        return "redirect:"+returnUrl+"join_certification.do";
    }
    
    /* 
     * mem/~~.do 로 들어오는데 따로 로직이 필요없이 보내기만 하는 경우를 위해
     * 예를들어 mem/join_view2.jsp 파일을 view에서 만들 경우 html에서는 /mem/join_view2.do 만 사용하면 따로 로직 기술 필요없이 사용 가능하다.   
     * */
    @RequestMapping(value = "{url}", method = RequestMethod.GET)
    public String indexPage( @PathVariable("url") String url ) {
        return returnUrl+url;
    }
    
    @RequestMapping(value = "redirect.do")
    public String redirectPage(  Model model, HttpServletRequest request ) {
        if(request.getParameter("msg") != null) {
            model.addAttribute("msg",request.getParameter("msg"));
            model.addAttribute("url",request.getParameter("url"));
        }
        return "redirect";
    }
    
    // id 상태에 따라 확인 메세지 받기 
    private HashMap<String, String> checkId ( MemberBean memberBean ) {
         HashMap<String, String> result = new HashMap<>();
         String msg       = "ok";
         String url      = "";
         int isActive        = memberBean.getIsActivity();
         LocalDate outDate   = LocalDate.parse(memberBean.getOutDate());
         LocalDate localDate = LocalDate.now();
         
        if( isActive == 0 ) {
            msg = "이메일 인증이 필요합니다.";
            url =  returnUrl+"login_view.do";
        } else if( isActive == 1 ) {
            msg = "현재 가입중인 아이디 입니다.";
            url =  returnUrl+"login_view.do";
        } else if( isActive == 2 ) {
            if( localDate.isBefore(outDate.plusMonths(3))) {
                msg = "탈퇴한지 3달이 안된 아이디 입니다.";
            }else{
                msg = "탈퇴한 아이디 입니다. 신규 이메일 인증이 필요합니다. 로그인 바랍니다.";
                url =  returnUrl+"login_view.do";
            };
        } else if ( isActive == 3 ) {
            if( localDate.isBefore(outDate.plusMonths(5))) {
                msg = "블럭당한 계정입니다.";
            } else {
                msg = "블럭당한 계정입니다. 신규 이메일 인증이 필요합니다. 로그인 바랍니다.";
                url =  returnUrl+"login_view.do";
            };
        }
        result.put("msg", msg);
        result.put("url", url);
        
        return result;
    }
    
    private void emailUpdate ( MemberBean memberBean , HttpServletRequest request ) {
        CommonUtile commonUtile = new CommonUtile();
        HashMap<String, String> where = new HashMap<>();
        MemberBean setMember = new MemberBean();
        where.put("ID", memberBean.getId());
        setMember.setWhere(where);
        setMember.setEmailToken(commonUtile.generateToken());
        setMember.setEmailTokenDate(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
        memService.memUpdate(setMember);
    }
    
}
