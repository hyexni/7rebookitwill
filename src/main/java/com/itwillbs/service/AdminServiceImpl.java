package com.itwillbs.service;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.itwillbs.domain.AdminVO;
import com.itwillbs.persistence.AdminDAO;

@Service
public class AdminServiceImpl implements AdminService {

	@Inject
	private AdminDAO adminDAO;
	
	@Override
	public AdminVO login(String ad_id, String ad_pw) {
		
		return adminDAO.adminLoginCheck(ad_id, ad_pw);
	}
	
	

}