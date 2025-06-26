package com.itwillbs.service;

import java.util.List;
import com.itwillbs.domain.BookVO;

public interface MainService {
    
    /**
     * 메인 페이지의 도서 목록을 가져오는 비즈니스 로직을 수행합니다.
     * @return 도서 정보(BookVO) 리스트
     * @throws Exception
     */
    public List<BookVO> getBookList() throws Exception;

}