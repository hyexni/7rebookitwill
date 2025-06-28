package com.itwillbs.persistence;

import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.itwillbs.domain.AdminVO;

@Repository
public class AdminDAOImpl implements AdminDAO {
	
	@Inject
	private SqlSession sqlSession;
	
	private static final String NAMESPACE = "com.itwillbs.persistence.AdminDAO.";

	@Override
	public AdminVO adminLoginCheck(String ad_id, String ad_pw) {
		Map<String, String> paramMap = new HashMap<>();
        paramMap.put("ad_id", ad_id);
        paramMap.put("ad_pw", ad_pw);
        return sqlSession.selectOne(NAMESPACE + "adminLoginCheck", paramMap);
    }
	

}