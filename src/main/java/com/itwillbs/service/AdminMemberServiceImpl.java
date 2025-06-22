package com.itwillbs.service;

import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import com.itwillbs.domain.MemberVO;
import com.itwillbs.persistence.AdminMemberDAO;

@Service
public class AdminMemberServiceImpl implements AdminMemberService {
	
	// mylog
	private static final Logger logger = LoggerFactory.getLogger(AdminMemberServiceImpl.class);

	// AdminMemberDAO 객체 필요
	@Inject
	private AdminMemberDAO amDao;
	
	 @Override
	    public List<MemberVO> getMemberList(String sort, int startRow, int pageSize) {
	        return amDao.getMemberList(sort, startRow, pageSize);
	    }

	    @Override
	    public List<MemberVO> searchMembers(String keyword, String sort, int startRow, int pageSize) {
	        return amDao.searchMembers(keyword, sort, startRow, pageSize);
	    }

	    @Override
	    public int getTotalCount() {
	        return amDao.getTotalCount();
	    }

	    @Override
	    public int getSearchCount(String keyword) {
	        return amDao.getSearchCount(keyword);
	    }
	
	
	
	
	
	
	
	
	
	
	
	
	
	

}
