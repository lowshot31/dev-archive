package com.sell_buy.sell_buy.api.service;

import com.sell_buy.sell_buy.db.entity.Point;
import com.sell_buy.sell_buy.db.entity.PointTransferred;
import com.sell_buy.sell_buy.db.repository.PointRepository; // Changed from AccountRepository to PointRepository
import com.sell_buy.sell_buy.db.repository.PointTransferredRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class PaymentService {

    private final PointRepository pointRepository; // Changed from AccountRepository to PointRepository
    private final PointTransferredRepository pointTransferredRepository;

    // 상수 정의 (결제 타입)
    private static final int TRANSFER_TYPE_PAYMENT = 2;

    @Transactional
    public PointTransferred processPayment(Long buyerId, Long sellerId, int amount) {
        // 결제 금액이 유효한지 확인
        validateAmount(amount);

        // 구매자와 판매자 포인트 정보 가져오기
        Point buyerPoint = findPointById(buyerId, "구매자 포인트 정보를 찾을 수 없습니다."); // Changed method name and message
        Point sellerPoint = findPointById(sellerId, "판매자 포인트 정보를 찾을 수 없습니다."); // Changed method name and message

        // 구매자 잔액 확인
        if (buyerPoint.getBalance() < amount) {
            throw new IllegalArgumentException("구매자의 잔액이 부족합니다.");
        }

        // 구매자 잔액 차감 및 판매자 잔액 추가
        buyerPoint.setBalance(buyerPoint.getBalance() - amount);
        sellerPoint.setBalance(sellerPoint.getBalance() + amount);

        // 데이터베이스 업데이트
        pointRepository.save(buyerPoint); // Changed from accountRepository to pointRepository
        pointRepository.save(sellerPoint); // Changed from accountRepository to pointRepository

        // 결제 내역 생성 및 저장
        PointTransferred pointTransferred = recordPaymentHistory(buyerId, sellerId, amount);
        return pointTransferred;
    }

    // 결제 금액 검증
    private void validateAmount(int amount) {
        if (amount <= 0) {
            throw new IllegalArgumentException("결제 금액은 0보다 커야 합니다.");
        }
    }

    // 계좌 ID로 포인트 정보 가져오기 및 예외 처리
    private Point findPointById(Long id, String errorMessage) { // Changed method name and parameter name
        return pointRepository.findById(id) // Changed from accountRepository to pointRepository
                .orElseThrow(() -> new IllegalArgumentException(errorMessage));
    }

    // 결제 활동 기록
    private PointTransferred recordPaymentHistory(Long buyerId, Long sellerId, int amount) {
        PointTransferred pointTransferred = new PointTransferred();
        pointTransferred.setSenderId(buyerId); // 구매자 Point ID
        pointTransferred.setReceiverId(sellerId); // 판매자 Point ID
        pointTransferred.setAmount(amount);
        pointTransferred.setTransferDate(LocalDateTime.now()); // 현재 날짜 시간
        pointTransferred.setTransferType(TRANSFER_TYPE_PAYMENT); // 결제 타입 상수 적용
        pointTransferredRepository.save(pointTransferred);
        return pointTransferred;
    }
}