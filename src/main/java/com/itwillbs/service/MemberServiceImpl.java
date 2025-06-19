package com.itwillbs.service;


import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.itwillbs.domain.MemberVO;
import com.itwillbs.persistence.MemberDAO;

// @Service : 스프링(root-context.xml)에서 해당객체를
//           MemberService 객체로 인식하도록 등록 (빈 등록)

@Service
public class MemberServiceImpl implements MemberService {

	private static final Logger logger = LoggerFactory.getLogger(MemberServiceImpl.class);
	
	// MemberDAO 객체를 주입
	@Inject
	private MemberDAO mDao;
	
	@Override
	public String getServerTime() {
		// 디비의 서버시간 정보를 가져오기 동작을 DAO에 요청
		logger.info(" getServerTime() 실행 ");
		return mDao.getServerTime();
	}

	@Override
	public void memberJoin(MemberVO vo) {
		logger.info(" memberJoin() 실행! ");
		// 회원가입동작 -> DAO를 사용해서 호출
		// 주입된 DAO 객체를 사용해서 해당 메서드 호출
		mDao.insertMember(vo);
	}

	@Override
	public MemberVO memberLoginCheck(MemberVO vo) {
		logger.info(" memberLoginCheck(MemberVO vo) 실행 ");
		
		// DAO의 기능을 호출해서 기능호출
		MemberVO resultVO = mDao.memberLoginCheck(vo);
		
		return resultVO;
	}

	@Override
	public MemberVO memberInfo(String id) {
		logger.info(" memberInfo(String id) 실행 ");
		// DAO 기능을 호출
		return mDao.getMember(id);
	}

	@Override
	public void memberUpdate(MemberVO uvo) {
		logger.info(" memberUpdate(MemberVO uvo) 실행 ");
		// DAO 수정메서드 호출
		mDao.updateMember(uvo);		
	}
	
	
	
	

}
