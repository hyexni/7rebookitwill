package com.itwillbs.dto;

// 최종적으로 사용자에게 보여줄 깔끔한 데이터 형식
public class ReceiptDTO {
    private String bookTitle;
    private String seller;
    private String purchaseDate;
    private String approvalNumber;
    private String price;

    // Getter와 Setter (Lombok을 사용하지 않으므로 직접 추가)
    public String getBookTitle() { return bookTitle; }
    public void setBookTitle(String bookTitle) { this.bookTitle = bookTitle; }
    public String getSeller() { return seller; }
    public void setSeller(String seller) { this.seller = seller; }
    public String getPurchaseDate() { return purchaseDate; }
    public void setPurchaseDate(String purchaseDate) { this.purchaseDate = purchaseDate; }
    public String getApprovalNumber() { return approvalNumber; }
    public void setApprovalNumber(String approvalNumber) { this.approvalNumber = approvalNumber; }
    public String getPrice() { return price; }
    public void setPrice(String price) { this.price = price; }
}