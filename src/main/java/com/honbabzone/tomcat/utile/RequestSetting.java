package com.honbabzone.tomcat.utile;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.Enumeration;

import javax.servlet.http.HttpServletRequest;

public class RequestSetting  {
    private String returnRequestString="?";
    public RequestSetting( HttpServletRequest request)  {
        Enumeration params = request.getParameterNames();
        while(params.hasMoreElements()) {
            String name = (String)params.nextElement();
            String value = request.getParameter(name);
            try {
				value = URLEncoder.encode(value, "UTF-8");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
            returnRequestString += name + "=" + value + "&";
        }

    }
    
    public String getReturnRequestString() {
        return returnRequestString;
    }
    public void setReturnRequestString(String returnRequestString) {
        this.returnRequestString = returnRequestString;
    }
    
    
}
