package com.itwillbs.dto;

//// 최종적으로 사용자에게 보여줄 깔끔한 데이터 형식
//public class ReceiptDTO {
//    private String bookTitle;
//    private String seller;
//    private String purchaseDate;
//    private String approvalNumber;
//    private String price;
//    private String totalPrice;
//    
//    // Getter와 Setter (Lombok을 사용하지 않으므로 직접 추가)
//    public String getBookTitle() { return bookTitle; }
//    public void setBookTitle(String bookTitle) { this.bookTitle = bookTitle; }
//    public String getSeller() { return seller; }
//    public void setSeller(String seller) { this.seller = seller; }
//    public String getPurchaseDate() { return purchaseDate; }
//    public void setPurchaseDate(String purchaseDate) { this.purchaseDate = purchaseDate; }
//    public String getApprovalNumber() { return approvalNumber; }
//    public void setApprovalNumber(String approvalNumber) { this.approvalNumber = approvalNumber; }
//    public String getPrice() { return price; }
//    public void setPrice(String price) { this.price = price; }
//    public String getTotalPrice() { return totalPrice; }
//    public void setTotalPrice(String Totalprice) { this.price = totalPrice; }
//    
//}



import java.util.List; // List를 사용하기 위해 반드시 import 해야 합니다.

/**
 * 최종적으로 사용자에게 보여줄 깔끔한 데이터 형식
 */
public class ReceiptDTO {

    private String bookTitle; // 이제 items 리스트 안으로 이동합니다.
    private String seller;
    private String purchaseDate;
    private String approvalNumber;
    private String price;     // 개별 가격은 items 리스트 안으로 이동합니다.
    private int totalPrice; // [수정] 총액을 나타내며, String 대신 int 타입을 사용합니다.

    // [추가] 상품 목록을 담을 List 필드
    private List<ReceiptItemDTO> items;

    // --- Getter와 Setter (Lombok을 사용하지 않으므로 직접 추가) ---

    public String getSeller() { return seller; }
    public void setSeller(String seller) { this.seller = seller; }

    public String getPurchaseDate() { return purchaseDate; }
    public void setPurchaseDate(String purchaseDate) { this.purchaseDate = purchaseDate; }

    public String getApprovalNumber() { return approvalNumber; }
    public void setApprovalNumber(String approvalNumber) { this.approvalNumber = approvalNumber; }

    // [수정] totalPrice의 getter/setter
    public int getTotalPrice() { return totalPrice; }
    public void setTotalPrice(int totalPrice) { this.totalPrice = totalPrice; }

    // [추가] items의 getter/setter
    public List<ReceiptItemDTO> getItems() { return items; }
    public void setItems(List<ReceiptItemDTO> items) { this.items = items; }
	@Override
	public String toString() {
		return "ReceiptDTO [bookTitle=" + bookTitle + ", seller=" + seller + ", purchaseDate=" + purchaseDate
				+ ", approvalNumber=" + approvalNumber + ", price=" + price + ", totalPrice=" + totalPrice + ", items="
				+ items + "]";
	}

    
    
    
    
}