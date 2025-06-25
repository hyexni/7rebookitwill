package com.itwillbs.persistence;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.itwillbs.domain.WishlistVO;
import com.itwillbs.dto.WishlistBookDTO; // DTO import 추가

@Repository
public class WishlistDAOImpl implements WishlistDAO {

	private static final String NAMESPACE = "com.itwillbs.persistence.WishlistDAO";

	@Inject
	private SqlSession sqlSession;

	// 1. 찜 중복 확인
	@Override
	public int checkWishlist(Map<String, Object> map) {
		return sqlSession.selectOne(NAMESPACE + ".checkWishlist", map);
	}

	// 2. 찜 추가
	@Override
	public void insertWishlist(WishlistVO vo) {
		sqlSession.insert(NAMESPACE + ".insertWishlist", vo);
	}

	// 3. 찜 삭제
	@Override
	public int deleteWishlist(WishlistVO vo) {
		return sqlSession.delete(NAMESPACE + ".deleteWishlist", vo);
	}

	// 4. 찜 목록 조회 - DTO 리스트 반환으로 변경
	@Override
	public List<WishlistBookDTO> getWishlistByMember(int member_idx) {
		return sqlSession.selectList(NAMESPACE + ".getWishlistByMember", member_idx);
	}
	
	// 페이징
	 @Override
	    public List<WishlistBookDTO> getWishlistByPage(int member_idx, int startRow, int size) {
	        Map<String, Object> params = Map.of(
	            "member_idx", member_idx,
	            "startRow", startRow,
	            "size", size
	        );
	        return sqlSession.selectList(NAMESPACE + ".getWishlistByPage", params);
	    }

	    @Override
	    public int getWishlistCount(int member_idx) {
	        return sqlSession.selectOne(NAMESPACE + ".getWishlistCount", member_idx);
	    }


}
