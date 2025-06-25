package com.itwillbs.service;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.itwillbs.dto.OrderDTO;
import com.itwillbs.persistence.OrdersDAO;

@Service
public class OrdersServiceImpl implements OrdersService {

    @Inject
    private OrdersDAO ordersDAO;

    @Override
    public List<OrderDTO> getOrdersByMember(int member_idx) {
        return ordersDAO.getOrdersByMember(member_idx);
    }
}
