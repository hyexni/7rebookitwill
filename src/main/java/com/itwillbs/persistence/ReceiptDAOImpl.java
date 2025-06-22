package com.itwillbs.persistence;

import com.itwillbs.domain.ReceiptVO;
import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import javax.inject.Inject;
import java.util.List;


public abstract class ReceiptDAOImpl implements ReceiptDAO {

    @Inject
    private SqlSession sqlSession;

    private static final String NAMESPACE = "com.itwillbs.mapper.receiptMapper.";

    @Override
    public void insertReceipt(ReceiptVO vo) {
        sqlSession.insert(NAMESPACE + "insertReceipt", vo);
    }

    @Override
    public int countByFilename(String filename) {
        return sqlSession.selectOne(NAMESPACE + "countByFilename", filename);  // ✅ MyBatis 호출
    }

    @Override
    public List<ReceiptVO> selectAllReceipts() {
        return sqlSession.selectList(NAMESPACE + "selectAllReceipts");
    }
    
    
}
