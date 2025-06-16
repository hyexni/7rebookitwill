package com.itwillbs.domain;

import java.sql.Timestamp;
import lombok.Data;

@Data
public class AdminVO {
	
	private int ad_idx;
	private String ad_id;
	private String ad_pw;
	private String ad_nick;
	private Timestamp ad_regdate;

}