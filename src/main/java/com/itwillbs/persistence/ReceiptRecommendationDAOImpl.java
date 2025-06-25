package com.itwillbs.persistence;

import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository // 데이터 저장소 계층의 컴포넌트임을 명시합니다.
public class ReceiptRecommendationDAOImpl implements ReceiptRecommendationDAO {
	
	
	// SqlSession(또는 SqlSessionTemplate)을 주입받습니다.
	@Inject
	private SqlSession sqlSession;

	private static final Logger logger = LoggerFactory.getLogger(ReceiptRecommendationDAOImpl.class);


	// Mapper XML의 namespace를 상수로 정의하여 재사용성과 유지보수성을 높입니다.
//	private static final String NAMESPACE = "com.itwillbs.mappers.ReceiptRecommendationMapper";

	@Override
	public List<String> findOcrBookTitlesByMemberIdx(Integer member_idx) {
		 System.out.println("@@@@@@@@@@@@@@@ member_idx"+member_idx);
		// logger.info("member_idx"+member_idx);
		// sqlSession.selectList("네임스페이스.쿼리ID", 파라미터);
		// return sqlSession.selectList(NAMESPACE + ".findOcrBookTitlesByMemberIdx",
		// member_idx);
		return null;
	}

	@Override
	public List<Integer> findCategoryIdsBySimilarTitle(String ocr_booktitle) {
		//return sqlSession.selectList(NAMESPACE + ".findCategoryIdsBySimilarTitle", ocr_booktitle);
		return null;
	}

	/**
	 * 이 메서드는 데이터베이스 로직보다는 순수 Java 로직에 가깝습니다. 일반적으로 서비스 계층에서 처리하는 것이 더 적합할 수 있습니다.
	 * 만약 특정 로직을 위해 DAO에 두어야 한다면 아래와 같이 구현할 수 있습니다.
	 */
//	  

}