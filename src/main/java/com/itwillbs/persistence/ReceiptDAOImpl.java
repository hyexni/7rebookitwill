package com.itwillbs.persistence;

import com.itwillbs.domain.ReceiptVO;
import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import javax.inject.Inject;
import java.util.List;

/**
 * ReceiptDAOImpl : ReceiptDAO 인터페이스를 구현한 객체
 * MyBatis(SqlSession)를 사용하여 SQL 호출 동작을 실행
 */
@Repository
public class ReceiptDAOImpl implements ReceiptDAO {

    private static final Logger logger = LoggerFactory.getLogger(ReceiptDAOImpl.class);

    @Inject
    private SqlSession sqlSession;

    private static final String NAMESPACE = "com.itwillbs.mapper.ReceiptMapper.";

    
    @Override
    public void ReceiptUploadInsert(ReceiptVO vo) throws Exception {
        logger.info("ReceiptUploadInsert() 호출");
        sqlSession.insert(NAMESPACE + "insertReceipt", vo);
        logger.info("영수증 정보 저장 SQL 실행 완료!");
    }

    /**
     * 파일 해시값으로 중복을 확인하는 메서드 구현
     */
    @Override
    public boolean isDuplicate(String fileHash) {
        logger.info("파일 해시값으로 중복 확인: {}", fileHash);
        // [수정] sqlSession을 사용하여 DB에서 개수를 조회
        int count = sqlSession.selectOne(NAMESPACE + "isDuplicate", fileHash);
        // count가 0보다 크면 중복이므로 true, 아니면 false 반환
        return count > 0;
    }

 //인터페이스와 동일하게 메서드 이름을 selectAllReceipts로 변경
    @Override
    public List<ReceiptVO> selectAllReceipts() throws Exception {
        logger.info("selectAllReceipts() 호출");
        return sqlSession.selectList(NAMESPACE + "selectAllReceipts");
    }
}