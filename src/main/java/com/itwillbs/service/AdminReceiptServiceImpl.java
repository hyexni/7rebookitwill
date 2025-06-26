package com.itwillbs.service;

import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itwillbs.domain.MemberVO;
import com.itwillbs.domain.ReceiptVO;
import com.itwillbs.persistence.AdminReceiptDAO;
import com.itwillbs.persistence.MemberDAO;

@Service
public class AdminReceiptServiceImpl implements AdminReceiptService {

	@Inject
	private MemberService memberService;
    @Autowired
    private AdminReceiptDAO adminReceiptDAO;

    @Override
    public Map<String, Object> getReceiptDetail(int upload_id) throws Exception {
        // 현재는 별도 비즈니스 로직 없이 DAO를 바로 호출
      
        		ReceiptVO vo= adminReceiptDAO.selectReceiptDetail(upload_id);
        		MemberVO mo= memberService.memberInfo(vo.getMember_idx());
        		Map<String, Object> result = new HashMap<String, Object>();
        		result.put("ReceiptVO", vo);
        		result.put("MemberVO", mo);
        		return result;
    } 		
}