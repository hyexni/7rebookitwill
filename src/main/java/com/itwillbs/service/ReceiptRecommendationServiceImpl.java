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
    public List<String> getOcrBookTitles(Long memberIdx) {
        logger.debug("Service: getOcrBookTitles(Long memberIdx) 호출");
        return rdao.findOcrBookTitlesByMemberIdx(memberIdx);
    }

    @Override
    public List<Integer> getRecommendedCategoryIdsByTitles(List<String> bookTitles) {
        logger.debug("Service: getRecommendedCategoryIdsByTitles(List<String> bookTitles) 호출");

        // 여러 도서 제목에 대한 카테고리 ID를 모두 수집
        List<Integer> allCategoryIds = new ArrayList<>();
        for (String title : bookTitles) {
            List<Integer> categoryIds = rdao.findCategoryIdsBySimilarTitle(title);
            if (categoryIds != null && !categoryIds.isEmpty()) {
                allCategoryIds.addAll(categoryIds);
            }
        }

        // 중복된 카테고리 ID를 제거하고 반환
        return allCategoryIds.stream()
                             .distinct()
                             .collect(Collectors.toList());
    }
    
    @Override
    public List<String> splitBookTitlesFromString(String booktitlesString) {
        logger.info("DAO: splitBookTitlesFromString(String booktitlesString) 호출");
        if (booktitlesString == null || booktitlesString.trim().isEmpty()) {
            return Collections.emptyList();
        }
        // 슬러시(/)를 기준으로 문자열을 분리하고, 각 제목의 앞뒤 공백을 제거합니다.
        return Arrays.stream(booktitlesString.split("/"))
                     .map(String::trim)
                     .collect(Collectors.toList());
    }
   

    @Override
    public List<String> parseBookTitles(String bookTitlesString) {
        logger.debug("Service: parseBookTitles(String bookTitlesString) 호출");

        if (bookTitlesString == null || bookTitlesString.trim().isEmpty()) {
            return new ArrayList<>();
        }

        return List.of(bookTitlesString.split("/")).stream()
                   .map(String::trim)
                   .filter(s -> !s.isEmpty())
                   .collect(Collectors.toList());
    }

}