package com.itwillbs.service;

import java.util.List;
import javax.inject.Inject; // 또는 @Autowired
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import com.itwillbs.domain.BookVO;
import com.itwillbs.persistence.MainDAO;

@Service
public class MainServiceImpl implements MainService {
    
    private static final Logger logger = LoggerFactory.getLogger(MainServiceImpl.class);

    @Inject
    private MainDAO mainDAO; // MainDAO 객체 주입

    @Override
    public List<BookVO> getBookList() throws Exception {
        logger.info("getBookList() 호출 - DAO 메서드 호출");
        
        // DAO를 호출하여 DB 처리 결과를 반환받음
        return mainDAO.getBookList();
    }
}