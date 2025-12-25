package com.sell_buy.sell_buy.api.service;

import com.sell_buy.sell_buy.db.entity.PointCharge;
import com.sell_buy.sell_buy.db.entity.Point;
import com.sell_buy.sell_buy.db.repository.AccountRepository;
import com.sell_buy.sell_buy.db.repository.PointChargeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class PointChargeService {

    private static final PointCharge pointCharge = new PointCharge();
    private final AccountRepository accountRepository;  // 변경된 부분
    private final PointChargeRepository pointChargeRepository;

    @Transactional
    public PointCharge chargePoints(Long userId, int amount) {
        if (amount <= 0) {
            throw new IllegalArgumentException("충전 금액은 0보다 커야 합니다.");
        }

        // 1. 포인트 잔액 조회
        Point chargerPoint = accountRepository.findByMemId(userId)
                .orElseThrow(() -> new IllegalArgumentException("구매자 계좌를 찾을 수 없습니다."));

        // 2. 포인트 충전 내역 생성
        PointCharge pointCharge = new PointCharge();
        pointCharge.setChargerId(userId); // chargerId를 사용하여 설정
        pointCharge.setAmount(amount);
        pointCharge.setChargeDate(LocalDateTime.now());
        pointCharge.setBalanceAfter(chargerPoint.getBalance() + amount); // 잔액 업데이트

        // METHOD 값 길이 제한 (10자 이하로 설정)
        String method = "이체"; // 예시 값
        if (method.length() > 10) {
            method = method.substring(0, 10); // 10자까지만 잘라서 설정
        }
        pointCharge.setMethod(method);

        pointCharge.setTransactionId("TX" + System.currentTimeMillis());
        pointChargeRepository.save(pointCharge);

        // 3. 포인트 잔액 업데이트
        chargerPoint.setBalance(chargerPoint.getBalance() + amount); // 잔액 증가
        accountRepository.save(chargerPoint);

        return pointCharge;
    }
}
