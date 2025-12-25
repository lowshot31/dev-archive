package com.sell_buy.sell_buy.db.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.DynamicUpdate;

import java.time.LocalDateTime;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@DynamicUpdate
@Table(name ="POINT_CHARGE")
public class PointCharge {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "point_charge_seq")
    @SequenceGenerator(name = "point_charge_seq", sequenceName = "POINT_CHARGE_SEQ", allocationSize = 1)
    @Column(name = "CHARGE_ID")
    private Long chargeId;

    // 수정된 부분: Point 객체 대신 chargerId를 사용
    @Column(name = "CHARGER_ID", nullable = false)
    private Long chargerId;

    @Column(name = "AMOUNT", nullable = false)
    private int amount;

    @Column(name = "CHARGE_DATE", nullable = false)
    private LocalDateTime chargeDate;

    @Column(name = "BALANCE_AFTER", nullable = false)
    private int balanceAfter;

    @Column(name = "METHOD")
    private String method;

    @Column(name = "TRANSACTION_ID")
    private String transactionId;

    public Long getChargeId() {
        return chargeId;
    }

    public void setChargeId(Long chargeId) {
        this.chargeId = chargeId;
    }

    public Long getChargerId() {
        return chargerId;
    }

    public void setChargerId(Long chargerId) {
        this.chargerId = chargerId;
    }

    public int getAmount() {
        return amount;
    }

    public void setAmount(int amount) {
        this.amount = amount;
    }

    public LocalDateTime getChargeDate() {
        return chargeDate;
    }

    public void setChargeDate(LocalDateTime chargeDate) {
        this.chargeDate = chargeDate;
    }

    public int getBalanceAfter() {
        return balanceAfter;
    }

    public void setBalanceAfter(int balanceAfter) {
        this.balanceAfter = balanceAfter;
    }

    public String getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }

    public String getMethod() {
        return method;
    }

    public void setMethod(String method) {
        this.method = method;
    }
}
