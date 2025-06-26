package com.itwillbs.domain;

import org.springframework.web.util.UriComponentsBuilder;
import lombok.Data;

@Data
public class SearchCriteria {

    // 페이징 정보
    private int page = 1;
    private int perPageNum = 10;

    // 검색 정보
    private String searchType;
    private String keyword;

    // 정렬 정보
    private String sortColumn1 = "upload_time"; // 영수증 정렬컬럼
    private String sortColumn = "change_date"; // 포인트 정렬 컬럼
    private String sortOrder = "DESC";         // 기본 정렬 순서

    /**
     * SQL의 LIMIT 구문에서 사용할 시작 위치를 계산합니다.
     */
    public int getPageStart() {
        return (this.page - 1) * perPageNum;
    }

    // ==============================================================================
    //  아래 두 개의 메서드가 SearchCriteria.java 파일에 있어야 합니다.
    // ==============================================================================

    /**
     * JSP에서 페이징 버튼의 URL을 생성할 때 사용하는 헬퍼 메서드.
     * @param page 이동할 페이지 번호
     * @return 현재 검색/정렬 상태를 유지하면서 페이지 번호만 바뀐 쿼리 스트링
     */
    public String pageUrl(int page) {
        UriComponentsBuilder builder = UriComponentsBuilder.fromPath("")
                .queryParam("page", page)
                .queryParam("perPageNum", this.perPageNum)
                .queryParam("searchType", this.searchType)
                .queryParam("keyword", this.keyword)
                .queryParam("sortColumn", this.sortColumn)
                .queryParam("sortOrder", this.sortOrder);
        return builder.toUriString();
    }
    
    /**
     * JSP에서 테이블 헤더의 정렬 링크 URL을 생성할 때 사용하는 헬퍼 메서드.
     * @param sortColumn 정렬할 컬럼명
     * @return 현재 검색 상태를 유지하면서 정렬 기준만 바뀐 쿼리 스트링
     */
    public String sortUrl(String sortColumn) {
        // 현재 정렬된 컬럼을 다시 클릭하면 정렬 순서를 ASC -> DESC, DESC -> ASC 로 변경
        String order = "ASC";
        if (sortColumn.equals(this.sortColumn) && "ASC".equalsIgnoreCase(this.sortOrder)) {
            order = "DESC";
        }
        
        UriComponentsBuilder builder = UriComponentsBuilder.fromPath("")
                .queryParam("page", 1) // 정렬 기준 변경 시에는 1페이지로 이동
                .queryParam("perPageNum", this.perPageNum)
                .queryParam("searchType", this.searchType)
                .queryParam("keyword", this.keyword)
                .queryParam("sortColumn", sortColumn)
                .queryParam("sortOrder", order);
        return builder.toUriString();
    }
}