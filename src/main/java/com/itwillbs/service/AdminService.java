package com.itwillbs.service;

import com.itwillbs.domain.AdminVO;

public interface AdminService {
	
	AdminVO login(String ad_id, String ad_pw);

}