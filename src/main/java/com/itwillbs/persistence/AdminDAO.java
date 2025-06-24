package com.itwillbs.persistence;

import org.apache.ibatis.annotations.Param;

import com.itwillbs.domain.AdminVO;

public interface AdminDAO {
	AdminVO adminLoginCheck(@Param("ad_id") String ad_id,
            				@Param("ad_pw") String ad_pw);
}
