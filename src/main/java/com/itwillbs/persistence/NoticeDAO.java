package com.itwillbs.persistence;

import java.util.List;
import com.itwillbs.domain.NoticeVO;

public interface NoticeDAO {
	
	List<NoticeVO> getNoticeList();

}
