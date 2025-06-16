package com.itwillbs.persistence;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Repository;
import com.itwillbs.domain.NoticeVO;

@Repository
public class NoticeDAOImpl implements NoticeDAO {
	
	@Inject
	private NoticeMapper noticeMapper;

	@Override
	public List<NoticeVO> getNoticeList() {
		// TODO Auto-generated method stub
		return noticeMapper.selectNoticeList();
	}
	
	

}
