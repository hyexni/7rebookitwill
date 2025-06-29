package com.itwillbs.domain;

import lombok.Data;

/**
 * 	 도서 목록 조회 조건 및 페이징 계산 클래스
 * - 검색어, 카테고리, 정렬 기준, 탭 구분 등 필터 정보 포함
 * - 현재 페이지, 페이지당 출력 수, 페이징 블록 계산 포함
 */

@Data
public class Criteria {

	//  검색 키워드
	private String search;

	// 카테고리 ID (필터용)
	private String category_id;

	// 정렬 기준 (sales, recent, review, rating)
	private String sort;
	
	// 도서 ID (리뷰 페이징용)
	private int book_id;
	
	// ✅ 관리자 주문 목록 필터용
	private String member_id;         // 주문자 ID 검색
	private String payment_status;    // 결제 상태 필터
	private String delivery_status;   // 배송 상태 필터

	// ✅ 사용자 주문 조회용
	private int member_idx;
	
	//  현재 페이지 번호(기본값 1)
	private int page = 1;

	// 한 페이지에 보여줄 항목 수
	private int perPageNum = 10;

	// 페이지 번호 유효성 체크
	public void setPage(int page) {
		this.page = (page <= 0) ? 1 : page;
	}

	// 한 페이지당 항목 수 유효성 체크
	public void setPerPageNum(int perPageNum) {
		this.perPageNum = (perPageNum <= 0 || perPageNum > 100) ? 10 : perPageNum;
	}

	// LIMIT 쿼리에서 사용할 시작 인덱스 계산
	public int getPageStart() {
		return (this.page - 1) * perPageNum;
	}
	
	 // 전체 게시글 수
    private int totalCount;

    // 한 블록에서 보여줄 페이지 수 (예: 1~10)
    private final int displayPageNum = 10;

    // 현재 블록 기준 시작/끝 페이지 번호
    private int startPage;
    private int endPage;

    // 이전 블록, 다음 블록 존재 여부
    private boolean prev;
    private boolean next;

    /**
     * 총 게시글 수를 받아서 startPage, endPage, prev, next를 계산
     * → Controller에서 totalCount 구한 후 반드시 호출해야 함
     */
    public void setTotalCount(int totalCount) {
        this.totalCount = totalCount;

        // 1) endPage 계산: 현재 페이지가 몇 번째 블록에 속하는지 계산
        endPage = (int) (Math.ceil(page / (double) displayPageNum) * displayPageNum);

        // 2) startPage 계산
        startPage = endPage - displayPageNum + 1;

        // 3) 실제 총 페이지 수와 비교해서 endPage 조정
        int totalPage = (int) Math.ceil(totalCount / (double) perPageNum);
        if (endPage > totalPage) {
            endPage = totalPage;
        }

        // 4) 이전, 다음 블록 존재 여부 설정
        prev = startPage > 1;
        next = endPage * perPageNum < totalCount;
        
   
    }
    
    // LIMIT #{offset}, #{perPageNum} 에서 offset 계산용 (MyBatis에서 자주 사용)
    public int getOffset() {
        return (page - 1) * perPageNum;
    }
    
    // ✅ 재고 상태 필터용 추가
    private String stock_status;    
}

