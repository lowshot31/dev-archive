package com.sell_buy.sell_buy.db.repository;

import com.sell_buy.sell_buy.db.entity.Delivery;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


@Repository
public interface DeliveryRepository extends JpaRepository<Delivery, String> {
    // trackingno,carrier확인
    Delivery findByOrderId(long orderId);

    // 택배사 확인
    Delivery findByCarrierId(String deliveryId);

    // 배송번호 조회
    Delivery findByTrackingNo(String trackingNo);


}
