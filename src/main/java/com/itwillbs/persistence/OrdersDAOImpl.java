package com.itwillbs.persistence;

import java.util.List;
import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.itwillbs.dto.OrderDTO;

@Repository
public class OrdersDAOImpl implements OrdersDAO {

    @Inject
    private SqlSession sqlSession;

    private static final String NAMESPACE = "com.itwillbs.mapper.OrdersMapper";

    @Override
    public List<OrderDTO> getOrdersByMember(int member_idx) {
        return sqlSession.selectList(NAMESPACE + ".getOrdersByMember", member_idx);
    }
}
