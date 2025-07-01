package com.itwillbs.config;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

@Component
public class AdminInterceptor implements HandlerInterceptor {

	@Override
	public boolean preHandle(HttpServletRequest request, 
							HttpServletResponse response, 
							Object handler) throws Exception {
		
		String uri = request.getRequestURI(); 
		System.out.println("[🛡️ 인터셉터 작동중] 요청 URI: " + uri);
		
		HttpSession session = request.getSession();
		
		Object admin = session.getAttribute("admin");
		
		if (admin == null) {
		    System.out.println("[⚠️ 인터셉터] 로그인 필요 → 리다이렉트!");
		    
		    session.setAttribute("msg", "관리자 로그인이 필요합니다.");
		    session.setAttribute("icon", "warning");
		    
		    response.sendRedirect(request.getContextPath() + "/admin/login");
		    return false;
		}
		
		return true;
	}

	@Override
	public void postHandle(HttpServletRequest request, 
						   HttpServletResponse response, 
						   Object handler,
						   ModelAndView modelAndView) throws Exception {
		
	}

	@Override
	public void afterCompletion(HttpServletRequest request,
								HttpServletResponse response,
								Object handler,
								Exception ex) throws Exception {
		
	}
	
	
	


}
