package com.honbabzone.tomcat.main.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.honbabzone.tomcat.utile.CommonConfig;

/**
 * Handles requests for the application home page.
 */
@Controller
@RequestMapping("/main/") 
public class MainController {
	
	private static final Logger logger = LoggerFactory.getLogger(MainController.class);
    private static CommonConfig cfg = new CommonConfig();
    private static String returnUrl = cfg.getMainUrl(); // /main/일것
    
	@RequestMapping(value = "log-out.do", method = RequestMethod.GET)
    public String indexPage( HttpSession session, HttpServletRequest request, HttpServletResponse response) {
        session.removeAttribute("loginIdCk");
        session.removeAttribute("isAdminCk");
        return "redirect:/mem/login_view.do";
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
	
	
}
