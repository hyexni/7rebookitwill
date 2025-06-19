package com.itwillbs.persistence;

import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.itwillbs.domain.WishlistVO;

@Repository
public class WishlistDAOImpl implements WishlistDAO {

    @Inject
    private SqlSession sqlSession;

    private static final String NAMESPACE = "com.itwillbs.persistence.WishlistDAO";

    @Override
    public int checkWishlist(Map<String, Object> map) {
        return sqlSession.selectOne(NAMESPACE + ".checkWishlist", map);
    }

    @Override
    public void insertWishlist(WishlistVO vo) {
        sqlSession.insert(NAMESPACE + ".insertWishlist", vo);
    }

    @Override
    public void deleteWishlist(WishlistVO vo) {
        sqlSession.delete(NAMESPACE + ".deleteWishlist", vo);
    }
}