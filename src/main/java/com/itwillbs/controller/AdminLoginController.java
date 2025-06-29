package com.itwillbs.controller;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.itwillbs.domain.AdminVO;
import com.itwillbs.service.AdminService;

@Controller
@RequestMapping("/admin")
public class AdminLoginController {
	
	@Inject
	private AdminService adminService;
	
	@GetMapping("/login")
	public String loginForm() {
		return "admin/admin_login";
	}
	
	@PostMapping("/login")
    public String loginProcess(@RequestParam("ad_id") String ad_id,
                               @RequestParam("ad_pw") String ad_pw,
                               HttpSession session,
                               RedirectAttributes rttr) {
		
        AdminVO admin = adminService.login(ad_id, ad_pw);
        
        if (admin != null) {
            session.setAttribute("admin", admin);
            
            rttr.addFlashAttribute("msg", admin.getAd_nick() + "님, 환영합니다 👑");
		    rttr.addFlashAttribute("icon", "success");
            
            return "redirect:/admin/stats";
        } else {
            rttr.addFlashAttribute("msg", "로그인 실패! ID 또는 비밀번호를 확인하세요.");
            rttr.addFlashAttribute("icon", "error");
            
            return "redirect:/admin/login";
        }
        
    }

    @GetMapping("/logout")
    public String logout(HttpSession session, RedirectAttributes rttr) {
        session.invalidate();
        
        rttr.addFlashAttribute("msg", "로그아웃 되었습니다.");
        rttr.addFlashAttribute("icon", "info");
        
        return "redirect:/admin/login";
    }
	
	
	
	
	
	

} // AdminLoginController 끝

















