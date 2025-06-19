package com.itwillbs.dto;

import com.itwillbs.domain.SearchCriteria;
import lombok.Getter;
import lombok.ToString;

/**
 * JSP 화면에 페이징 UI(이전, 다음, 페이지 번호 목록)를 그리기 위한 데이터를 생성하는 DTO
 */
@Getter
@ToString
public class PageMakerDTO {

    private int totalCount;     // 전체 데이터 개수
    private int startPage;      // 페이지 블럭의 시작 페이지 번호
    private int endPage;        // 페이지 블럭의 끝 페이지 번호
    private boolean prev;       // '이전' 버튼 표시 여부
    private boolean next;       // '다음' 버튼 표시 여부
    private int displayPageNum = 10; // 화면에 보여줄 페이지 번호 개수

    private SearchCriteria cri; // 현재 페이지 및 검색 정보

    public void setCri(SearchCriteria cri) {
        this.cri = cri;
    }

    public void setTotalCount(int totalCount) {
        this.totalCount = totalCount;
        calcData(); // 페이징 관련 데이터를 모두 계산
    }

    private void calcData() {
        // 1. 끝 페이지 번호 계산
        endPage = (int) (Math.ceil(cri.getPage() / (double) displayPageNum) * displayPageNum);

        // 2. 시작 페이지 번호 계산
        startPage = (endPage - displayPageNum) + 1;

        // 3. 실제 마지막 페이지 번호 계산
        int tempEndPage = (int) (Math.ceil(totalCount / (double) cri.getPerPageNum()));

        // 4. 끝 페이지 번호가 실제 마지막 페이지보다 크면 수정
        if (endPage > tempEndPage) {
            endPage = tempEndPage;
        }

        // 5. '이전' 버튼 표시 여부
        prev = startPage != 1;

        // 6. '다음' 버튼 표시 여부
        next = endPage * cri.getPerPageNum() < totalCount;
    }
}