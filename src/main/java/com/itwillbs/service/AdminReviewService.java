package com.itwillbs.service;

import java.util.List;
import com.itwillbs.domain.ReviewVO;

public interface AdminReviewService {
    List<ReviewVO> getReviewList(int startRow, int pageSize, String keyword);
    int getReviewCount(String keyword);
}
