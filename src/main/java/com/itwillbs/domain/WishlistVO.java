package com.itwillbs.domain;

import java.sql.Timestamp;
import lombok.Data;

@Data
public class WishlistVO {
	
	private int wishlist_id;
	private int member_idx;
	private int book_id;
	private Timestamp created_at;

} 
