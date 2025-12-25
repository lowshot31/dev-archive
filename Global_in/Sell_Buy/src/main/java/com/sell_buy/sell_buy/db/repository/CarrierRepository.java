package com.sell_buy.sell_buy.db.repository;

import com.sell_buy.sell_buy.db.entity.Carrier;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


@Repository
public interface CarrierRepository extends JpaRepository<Carrier, Integer> {
    Carrier findCarrierNameByCarrierId(String carrierId);
}
