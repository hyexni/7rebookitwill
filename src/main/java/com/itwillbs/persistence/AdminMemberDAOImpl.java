package com.itwillbs.persistence;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;
import com.itwillbs.domain.MemberVO;

@Repository
public class AdminMemberDAOImpl implements AdminMemberDAO {
	
	// mylog
	private static final Logger logger = LoggerFactory.getLogger(AdminMemberDAOImpl.class);
	
	// 디비연결 & mybatis 관련 정보를 처리하는 객체
	@Inject
	private SqlSession sqlSession;
	
	private static final String NAMESPACE="com.itwillbs.persistence.AdminMemberDAO.";

	 @Override
	    public List<MemberVO> getMemberList(String sort, int startRow, int pageSize) {
	        Map<String, Object> params = new HashMap<>();
	        params.put("sort", sort);
	        params.put("startRow", startRow);
	        params.put("pageSize", pageSize);
	        return sqlSession.selectList(NAMESPACE + "getMemberList", params);
	    }

	    @Override
	    public List<MemberVO> searchMembers(String keyword, String sort, int startRow, int pageSize) {
	        Map<String, Object> params = new HashMap<>();
	        params.put("keyword", keyword);
	        params.put("sort", sort);
	        params.put("startRow", startRow);
	        params.put("pageSize", pageSize);
	        return sqlSession.selectList(NAMESPACE + "searchMembers", params);
	    }

	    @Override
	    public int getTotalCount() {
	        return sqlSession.selectOne(NAMESPACE + "getTotalCount");
	    }

	    @Override
	    public int getSearchCount(String keyword) {
	        return sqlSession.selectOne(NAMESPACE + "getSearchCount", keyword);
	    }
	
	

}
