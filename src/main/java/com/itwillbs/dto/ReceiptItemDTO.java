package com.itwillbs.dto;

import com.itwillbs.domain.BookVO;

/**
 * items 배열 안의 개별 상품 객체를 위한 DTO 클래스
 */
public class ReceiptItemDTO {
	
	/**
     * [핵심] DB의 Book 테이블과 매칭된 도서 정보.
     * 매칭에 실패한 경우 이 값은 null이 됩니다.
     * 타입을 Book 엔티티로 할 수도 있고, 별도의 BookDTO를 만들어 사용할 수도 있습니다.
     */
    private BookVO matchedBook;

    private String bookTitle;
    private int quantity;
    private int price;

    // --- Getters and Setters ---
    public String getBookTitle() {
        return bookTitle;
    }
    public void setBookTitle(String bookTitle) {
        this.bookTitle = bookTitle;
    }
    public int getQuantity() {
        return quantity;
    }
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    public int getPrice() {
        return price;
    }
    public void setPrice(int price) {
        this.price = price;
    }
	@Override
	public String toString() {
		return "ReceiptItemDTO [bookTitle=" + bookTitle + ", quantity=" + quantity + ", price=" + price + "]";
	}
	
	/**
     * setMatchedBook 메서드
     * @param matchedBook DB에서 검색하여 매칭된 BookVO 객체
     */
	
	public void setMatchedBook(BookVO matchedBook) {
	    this.matchedBook = matchedBook;
	}
    
    
}