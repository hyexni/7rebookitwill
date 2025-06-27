package com.itwillbs.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import com.itwillbs.domain.MemberVO;

public interface AdminMemberDAO {
	
	List<MemberVO> getMemberList(@Param("sort") String sort, 
								 @Param("dir")  String dir,
								 @Param("startRow") int startRow, 
								 @Param("pageSize") int pageSize);
	
    List<MemberVO> searchMembers(@Param("keyword") String keyword, 
					    		 @Param("sort") String sort, 
    							 @Param("dir")  String dir,
					    		 @Param("startRow") int startRow, 
					    		 @Param("pageSize") int pageSize);
    int getTotalCount();
    int getSearchCount(@Param("keyword") String keyword);

}
