package com.sell_buy.sell_buy.api.service;

import com.sell_buy.sell_buy.db.entity.Member;
import com.sell_buy.sell_buy.db.entity.Order;

import java.util.List;

public interface OrderService {
    Long getSellOrder(long sellerId);

    void setOrderId(long orderId);

    // 오더 등록
    Order registerOrder(Order order);

    // 오더 삭제
    void deleteOrder(long orderId);

    //오더가 존재하는지
    boolean hasExistOrder(Long orderId);

    // 오더번호&판매자아이디
    boolean hasExistOrderIdBySellerId(long sellerId);

    // 모든 오더아이디값 가져오기
    List<Order> getAllOrderId();

    //모든 오더아이디값의 베송상태 확인
    void updateOrderStatus();
    //상품 등록시 오더아이디 생성
    void updateProdOrder(Member order, String prodName);
    // modify
    void updateOrder(long orderId, int orderStatus, String carrier, String trackingNo);
    // 결제했을때 상품 order에 상태 업데이트
    void updatePaymentStatus(String prodName, Member member);
}