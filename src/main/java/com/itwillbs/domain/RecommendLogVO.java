package com.itwillbs.domain;

import java.sql.Timestamp;
import lombok.Data;

@Data
public class RecommendLogVO {
	
	private int recommend_id;
	private int member_idx;
	private String recommend_type;
	private int book_id;
	private Timestamp created_at;

}
