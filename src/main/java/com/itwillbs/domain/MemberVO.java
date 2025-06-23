package com.itwillbs.domain;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class MemberVO {

	private int member_idx;
	private String member_id;
	private String member_name;
	private String member_email;
	private String member_pw;
	private String member_phone;
	private String member_nick;
	private String member_address;
	private String member_address_detail;
	private Timestamp member_regdate;
	private String member_status;
	private Timestamp member_update_date;
}
