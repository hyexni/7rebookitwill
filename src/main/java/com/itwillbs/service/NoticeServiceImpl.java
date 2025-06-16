package com.itwillbs.service;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import com.itwillbs.domain.NoticeVO;
import com.itwillbs.persistence.NoticeDAO;

@Service
public class NoticeServiceImpl implements NoticeService {
	
	@Inject
	private NoticeDAO noticeDAO;

	@Override
	public List<NoticeVO> getNoticelist() {
		// TODO Auto-generated method stub
		return noticeDAO.getNoticeList();
	}
	
	

}
