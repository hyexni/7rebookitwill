package com.itwillbs.dto;

import com.itwillbs.domain.Criteria;

public class BookPageDTO {

	private int startPage;
	private int endPage;
	private boolean prev;
	private boolean next;

	private int totalCount;
	private Criteria criteria;

	private final int displayPageNum = 10; // 한 블럭에 보여줄 페이지 수

	public BookPageDTO(Criteria criteria, int totalCount) {
		this.criteria = criteria;
		this.totalCount = totalCount;

		// 끝 페이지 계산
		endPage = (int) (Math.ceil(criteria.getPage() / (double) displayPageNum) * displayPageNum);
		startPage = endPage - displayPageNum + 1;

		// 실제 마지막 페이지
		int tempEndPage = (int) (Math.ceil(totalCount / (double) criteria.getPerPageNum()));
		if (endPage > tempEndPage) {
			endPage = tempEndPage;
		}

		// 이전 버튼
		prev = startPage > 1;

		// 다음 버튼
		next = endPage * criteria.getPerPageNum() < totalCount;
	}

	// Getter 메서드들
	public int getStartPage() {
		return startPage;
	}

	public int getEndPage() {
		return endPage;
	}

	public boolean isPrev() {
		return prev;
	}

	public boolean isNext() {
		return next;
	}

	public int getTotalCount() {
		return totalCount;
	}

	public Criteria getCriteria() {
		return criteria;
	}
}
