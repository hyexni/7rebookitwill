package com.itwillbs.service;

import com.itwillbs.domain.AdminVO;

public interface AdminService {
	AdminVO login(String id, String pw);
}