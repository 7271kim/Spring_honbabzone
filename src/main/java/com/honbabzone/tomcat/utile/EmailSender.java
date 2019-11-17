package com.honbabzone.tomcat.utile;

import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;

public class EmailSender {
	
	private JavaMailSender mailSender;
	private String from = "stayhomego@gmail.com";
	
	public EmailSender(JavaMailSender mailSender){
		this.mailSender = mailSender;
	}
	 
	public void sendMail(String to, String subject, String msg) {
 
		SimpleMailMessage message = new SimpleMailMessage();
 
		message.setFrom(from);
		message.setTo(to);
		message.setSubject(subject);
		message.setText(msg);
		mailSender.send(message);	
	}
}
