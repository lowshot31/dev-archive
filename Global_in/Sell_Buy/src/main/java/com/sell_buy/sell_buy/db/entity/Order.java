package com.sell_buy.sell_buy.db.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.ColumnDefault;

import java.time.LocalDateTime;

@Entity
@Getter
@Setter //setter 이용시 인스턴스값이 어디서 꼬일지 모름
@Builder // 객체만들어서 생성  OPEN -> BUILDER() , CLOSE -> BUILD()
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "prod_order")
public class Order {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "ORDER_SEQ")
    @SequenceGenerator(name = "ORDER_SEQ", sequenceName = "ORDER_SEQ", allocationSize = 1)
    @Column(name = "order_id")
    private long orderId;
    @Column(name = "transfer_id")
    @ColumnDefault("0")
    private long transferId;
    @Column(name = "prod_id")
    private long prodId;
    @Column(name = "BUYER_ID")
    @ColumnDefault("0")
    private long buyerId;
    @Column(name = "seller_id")
    private long sellerId;
    @Column(name = "receiver_name")
    private String receiverName;
    @Column(name = "receiver_address")
    private String receiverAddress;
    @Column(name = "receiver_phone")
    private String receiverPhone;
    @Column(name = "ORDER_TYPE")
    private int orderType;
    @Column(name = "created_date")
    private LocalDateTime createdDate;
    @Column(name = "delivered_date")
    private LocalDateTime deliveredDate;
    @Column(name = "carrier_status")
    private String carrierStatus;
    @Column(name = "order_status")
    private String orderStatus;

}
