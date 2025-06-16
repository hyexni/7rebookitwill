package com.itwillbs.domain;

import lombok.Data;

@Data
public class GenreStatsDTO {

	private int categoryID;
	private String categoryName;
	private int totalSales;
	private int totalReviews;
	private double score;
	
}