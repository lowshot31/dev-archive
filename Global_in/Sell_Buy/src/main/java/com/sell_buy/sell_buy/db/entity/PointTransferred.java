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
@Table(name = "POINT_TRANSFERED")
public class PointTransferred {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "POINT_TRANSFERED_SEQ_GEN")
    @SequenceGenerator(name = "POINT_TRANSFERED_SEQ_GEN", sequenceName = "GBIN1.POINT_TRANSFERED_SEQ", allocationSize = 1)
    @Column(name = "TRANSFER_ID")
    private Long transferId;

    @Column(name = "SENDER_ID", nullable = false)
    private Long senderId;

    @Column(name = "RECEIVER_ID", nullable = false)
    private Long receiverId;

    @Column(name = "AMOUNT", nullable = false)
    private Integer amount;

    @Column(name = "TRANSFER_DATE", nullable = false)
    private LocalDateTime transferDate;

    @Column(name = "TRANSFER_TYPE")
    private Integer transferType;

    @ManyToOne
    @JoinColumn(name = "SENDER_ID", referencedColumnName = "mem_id", insertable = false, updatable = false)
    private Point sender;

    @ManyToOne
    @JoinColumn(name = "RECEIVER_ID", referencedColumnName = "mem_id", insertable = false, updatable = false)
    private Point receiver;

    public Long getTransferId() {
        return transferId;
    }

    public void setTransferId(Long transferId) {
        this.transferId = transferId;
    }

    public Long getSenderId() {
        return senderId;
    }

    public void setSenderId(Long senderId) {
        this.senderId = senderId;
    }

    public Long getReceiverId() {
        return receiverId;
    }

    public void setReceiverId(Long receiverId) {
        this.receiverId = receiverId;
    }

    public Integer getAmount() {
        return amount;
    }

    public void setAmount(Integer amount) {
        this.amount = amount;
    }

    public LocalDateTime getTransferDate() {
        return transferDate;
    }

    public void setTransferDate(LocalDateTime transferDate) {
        this.transferDate = transferDate;
    }

    public Integer getTransferType() {
        return transferType;
    }

    public void setTransferType(Integer transferType) {
        this.transferType = transferType;
    }

    public Point getSender() {
        return sender;
    }

    public void setSender(Point sender) {
        this.sender = sender;
    }

    public Point getReceiver() {
        return receiver;
    }

    public void setReceiver(Point receiver) {
        this.receiver = receiver;
    }
}