package com.itwillbs.persistence;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.itwillbs.domain.ReceiptVO;

@Repository
public class AdminReceiptDAOImpl implements AdminReceiptDAO {

    @Autowired
    private SqlSession sqlSession; // MyBatis SqlSession 주입

    // MyBatis Mapper XML의 namespace
    private static final String NAMESPACE = "com.example.mapper.AdminReceiptMapper";

    @Override
    public ReceiptVO selectReceiptDetail(int upload_id) {
        // namespace와 sql id를 결합하여 쿼리 실행
        return sqlSession.selectOne(NAMESPACE + ".selectReceiptDetail", upload_id);
    }
}