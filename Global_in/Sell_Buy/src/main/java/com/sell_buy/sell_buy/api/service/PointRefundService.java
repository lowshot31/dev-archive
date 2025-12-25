package com.sell_buy.sell_buy.api.service;

import com.sell_buy.sell_buy.db.entity.Point;
import com.sell_buy.sell_buy.db.entity.PointCharge;
import com.sell_buy.sell_buy.db.repository.AccountRepository;
import com.sell_buy.sell_buy.db.repository.PointChargeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
@Transactional
public class PointRefundService {

        private final AccountRepository accountRepository;
        private final PointChargeRepository pointChargeRepository;

        @Transactional
        public Point processPointRefund(Long buyerId, int amount) {
            if (amount <= 0) {
                throw new IllegalArgumentException("취소 금액은 0보다 커야 합니다.");
            }

            Point buyerPoint = accountRepository.findByMemId(buyerId)
                    .orElseThrow(() -> new IllegalArgumentException("구매자 계좌를 찾을 수 없습니다."));

            PointCharge pointCharge = pointChargeRepository.findTopByChargerIdOrderByChargeDateDesc(buyerId)
                    .orElseThrow(() -> new IllegalArgumentException("충전 내역을 찾을 수 없습니다."));

            if (pointCharge.getAmount() < amount) {
                throw new IllegalArgumentException("환불 금액이 충전 금액을 초과합니다.");
            }

            buyerPoint.setBalance(buyerPoint.getBalance() - amount);
            accountRepository.save(buyerPoint);

            PointCharge pointrefund = new PointCharge();
            pointrefund.setChargerId(buyerId);
            pointrefund.setAmount(amount);
            pointrefund.setChargeDate(LocalDateTime.now());
            pointrefund.setBalanceAfter(buyerPoint.getBalance()); // 올바르게 환불 후 잔액 기록
            String method = "취소";
            if (method.length() > 10) {
                method = method.substring(0, 10);
            }
            pointrefund.setMethod(method);
            pointChargeRepository.save(pointrefund); // pointrefund 를 저장해야 합니다.

            return buyerPoint; // 업데이트된 Point 객체 반환
        }
    }
