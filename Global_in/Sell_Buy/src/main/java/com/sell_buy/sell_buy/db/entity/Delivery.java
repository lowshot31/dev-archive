package com.sell_buy.sell_buy.db.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.*;

@Entity
@Getter
@Setter //setter 이용시 인스턴스값이 어디서 꼬일지 모름
@Builder // 객체만들어서 생성  OPEN -> BUILDER() , CLOSE -> BUILD()
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "DELIVERY")
public class Delivery {
    @Id
    @Column(name = "ORDER_ID")
    private long orderId;
    @Column(name = "TRACKING_NO")
    private String trackingNo;
    @Column(name = "CARRIER_ID")
    private String carrierId;
    @Column(name = "CARRIER")
    private String carrier;
}
