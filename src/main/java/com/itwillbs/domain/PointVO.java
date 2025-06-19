package com.itwillbs.domain;

import java.sql.Timestamp;
import lombok.Data;

@Data
public class PointVO {
	private int point_id;
	private int member_idx;
	private int point_amount;
	private int change_amount;
	private String change_reason;
	private Timestamp change_date;
	private String point_status;
	
	
	
}

