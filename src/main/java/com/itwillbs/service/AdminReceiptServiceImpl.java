package com.itwillbs.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itwillbs.domain.ReceiptVO;
import com.itwillbs.persistence.AdminReceiptDAO;

@Service
public class AdminReceiptServiceImpl implements AdminReceiptService {

    @Autowired
    private AdminReceiptDAO adminReceiptDAO;

    @Override
    public ReceiptVO getReceiptDetail(int upload_id) throws Exception {
        // 현재는 별도 비즈니스 로직 없이 DAO를 바로 호출
        return adminReceiptDAO.selectReceiptDetail(upload_id);
    }
}