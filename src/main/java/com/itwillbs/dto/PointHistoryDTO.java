package com.itwillbs.dto;

import com.itwillbs.domain.PointVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper=false) // PointVO의 필드도 해시코드 계산에 포함
public class PointHistoryDTO extends PointVO {
    private String member_id; // 회원 테이블에서 조인해 올 회원 아이디
    private String member_name;
}
