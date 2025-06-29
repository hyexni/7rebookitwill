package com.itwillbs.service;

	 /**
     * 영수증 처리 과정에서 발생하는 비즈니스 로직 관련 예외를 위한 클래스입니다.
     * 사용자에게 보여줄 에러 메시지를 담는 데 사용됩니다.
     */
    public class ReceiptProcessingException extends RuntimeException {

        public ReceiptProcessingException(String message) {
            super(message);
        }

        public ReceiptProcessingException(String message, Throwable cause) {
            super(message, cause);
        }
    
    
    
 
}
