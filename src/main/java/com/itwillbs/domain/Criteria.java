package com.itwillbs.domain;

import lombok.Data;

/**
 * 도서 목록 조회 조건을 저장하는 클래스 - 검색어 - 카테고리 필터 - 정렬 조건 - 탭 구분(추천/베스트/신간 등) - 페이징 정보
 * (현재 페이지, 페이지당 게시물 수)
 */
@Data
public class Criteria {

	// 🔍 검색 키워드
	private String search;

	// 📚 카테고리 ID (스네이크케이스로 통일)
	private String category_id;

	// 🔀 정렬 기준
	private String sort;

	// 📄 현재 페이지 번호
	private int page = 1;

	// 📑 한 페이지에 보여줄 항목 수
	private int perPageNum = 12;

	// 🏷️ 탭 종류 (추천, 베스트셀러, 신간 등)
	private String tabType;

	// 페이지 번호 유효성 체크
	public void setPage(int page) {
		this.page = (page <= 0) ? 1 : page;
	}

	// 한 페이지당 항목 수 유효성 체크
	public void setPerPageNum(int perPageNum) {
		this.perPageNum = (perPageNum <= 0 || perPageNum > 100) ? 12 : perPageNum;
	}

	// ⚙️ LIMIT 쿼리에서 사용할 시작 인덱스 계산
	public int getPageStart() {
		return (this.page - 1) * perPageNum;
	}
}
