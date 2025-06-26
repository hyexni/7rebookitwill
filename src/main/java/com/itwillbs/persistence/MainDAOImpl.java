package com.itwillbs.persistence;

import java.util.List;
import javax.inject.Inject; // 또는 @Autowired
import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;
import com.itwillbs.domain.BookVO;

@Repository
public class MainDAOImpl implements MainDAO {

    private static final Logger logger = LoggerFactory.getLogger(MainDAOImpl.class);

    @Inject
    private SqlSession sqlSession; // root-context.xml에 설정된 SqlSession(Template) 객체 주입

    // 매퍼의 namespace
    private static final String NAMESPACE = "com.itwillbs.mapper.MainMapper";

    @Override
    public List<BookVO> getBookList() throws Exception {
        logger.info("getBookList() 호출 - MainMapper.selectBookList 실행");
        
        // sqlSession 객체를 사용하여 MainMapper.xml의 selectBookList 쿼리를 실행하고 결과를 List<BookVO> 형태로 반환
        return sqlSession.selectList(NAMESPACE + ".selectBookList");
    }
}