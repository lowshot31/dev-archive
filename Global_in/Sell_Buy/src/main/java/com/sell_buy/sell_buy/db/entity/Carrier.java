package com.sell_buy.sell_buy.db.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "CARRIERS")
@Builder
public class Carrier {
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    @Column(name = "CARRIER_ID")
    private String carrierId;
    @Column(name = "CARRIER_NAME")
    private String carrierName;
}
