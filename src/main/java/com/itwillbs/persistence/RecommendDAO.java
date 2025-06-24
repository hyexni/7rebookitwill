package com.itwillbs.persistence;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.itwillbs.domain.BookVO;
import com.itwillbs.dto.BookStatsDTO;

public interface RecommendDAO {
    
    // 구매 기반 + 정렬 (Map 파라미터)
    List<BookStatsDTO> findRecommendedBooksByPurchaseSorted(Map<String,Object> params);

    // 찜 기반 + 정렬 (Map 파라미터)
    List<BookStatsDTO> findRecommendedBooksByWishSorted    (Map<String,Object> params);
    

}
