package com.itwillbs.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.itwillbs.persistence.ReceiptRecommendationDAO;



@Service
public class ReceiptRecommendationServiceImpl implements ReceiptRecommendationService {

    private static final Logger logger = LoggerFactory.getLogger(ReceiptRecommendationServiceImpl.class);

    @Inject
    private ReceiptRecommendationDAO rdao;

    @Override
    public List<String> getOcrBookTitles(Integer member_idx) {
    	System.out.println("4444444444444444444444444");
    	System.out.println("$$$$$$$$$$$$$$$member_idx"+member_idx);
    	
        logger.debug("Service: getOcrBookTitles(Long memberIdx) 호출");
       // return rdao.findOcrBookTitlesByMemberIdx2(memberIdx);
        return rdao.findOcrBookTitlesByMemberIdx(member_idx);
    }

    @Override
    public List<Integer> getRecommendedCategoryIdsByTitles(List<String> bookTitles) {
        logger.debug("Service: getRecommendedCategoryIdsByTitles(List<String> bookTitles) 호출");
        System.out.println( bookTitles);
        System.out.println("=================================================================");
        
        
        // 여러 도서 제목에 대한 카테고리 ID를 모두 수집
        List<Integer> allCategoryIds = new ArrayList<>();
        // 도서 제목을 세분화 하는 메서드 실행
        for (String title : bookTitles) {
        	
        	List<String> newTitle = splitBookTitlesFromString(title);
        	//[기적의 독해력 1A(초등1학년) , EBS 만점왕 초등 1-1 세트(2023)(전2권)]
        	
        	
        	logger.info("newTitle"+newTitle);
        	for(String lastTitle : newTitle) {
        		List<Integer> categoryIds = rdao.findCategoryIdsBySimilarTitle(lastTitle);
        		logger.info("categoryIds"+categoryIds);
        		if (categoryIds != null && !categoryIds.isEmpty()) {
        			allCategoryIds.addAll(categoryIds);
        		}        		
        	}
        	
        }
        
        
        logger.info("allCategoryIds"+allCategoryIds);
      // 중복된 카테고리 ID를 제거하고 반환
        return allCategoryIds.stream()
                             .distinct()
                             .collect(Collectors.toList());
    }
    
         
    /**
     *  // 도서제목을 세분화 하는 메서드
     * @param booktitlesString
     * @return
     */
   
    public List<String> splitBookTitlesFromString(String booktitlesString) {
        logger.info("DAO: splitBookTitlesFromString(String booktitlesString) 호출");
        if (booktitlesString == null || booktitlesString.trim().isEmpty()) {
            return Collections.emptyList();
        }
                
      
        
     // 정규식을 사용하여 "/" 또는 하나 이상의 공백을 기준으로 문자열을 분리합니다.
        // "[\\s/]+"는 하나 이상의(+, one or more) 공백 문자(\\s) 또는 슬래시(/)를 의미합니다.
        return Arrays.stream(booktitlesString.split("[\\s/]+"))
                // split 결과로 인해 생길 수 있는 빈 문자열을 제거합니다.
                .filter(title -> !title.trim().isEmpty())
                .map(String::trim)
                .collect(Collectors.toList());
    }
   

  
   
}