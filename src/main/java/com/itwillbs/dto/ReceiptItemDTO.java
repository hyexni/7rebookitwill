package com.itwillbs.dto;

/**
 * items 배열 안의 개별 상품 객체를 위한 DTO 클래스
 */
public class ReceiptItemDTO {

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
    
    
}