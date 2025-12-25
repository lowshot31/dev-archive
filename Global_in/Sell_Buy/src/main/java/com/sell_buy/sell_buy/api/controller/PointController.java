package com.sell_buy.sell_buy.api.controller;

import com.sell_buy.sell_buy.api.service.PaymentService;
import com.sell_buy.sell_buy.api.service.PointChargeService;
import com.sell_buy.sell_buy.api.service.PointRefundService;
import com.sell_buy.sell_buy.db.entity.PointCharge;
import com.sell_buy.sell_buy.db.entity.Point;
import com.sell_buy.sell_buy.db.entity.PointTransferred;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequiredArgsConstructor
@RequestMapping("/api/points")
public class PointController {

    private final PointChargeService pointChargeService;
    private final PointRefundService pointRefundService;
    private final PaymentService paymentService;


    // 포인트 충전 (GET 요청 -> JSP 반환)
    @GetMapping("/charge")
    public String showChargePage() {
        return "charge"; // /WEB-INF/jsp/charge.jsp

    }

    // 포인트 환불 (GET 요청 -> JSP 반환)
    @GetMapping("/refund")
    public String showRefundPage() {
        return "refund"; // /WEB-INF/jsp/refund.jsp
    }

    @GetMapping("/payment")
    public String showPaymentsPage() {
        return "payment"; // payments.jsp 또는 해당 뷰 이름
    }


    @PostMapping("/charge")
    public ResponseEntity<Map<String, Object>> chargePoints(@RequestBody Map<String, Object> requestData) {
        // JSON 데이터를 안전하게 읽고 변환
        Long memId = requestData.get("memId") instanceof Number ? ((Number) requestData.get("memId")).longValue() : null;
        Integer amount = requestData.get("amount") instanceof Number ? ((Number) requestData.get("amount")).intValue() : null;

        // 필수 파라미터 검증
        if (memId == null) {
            return ResponseEntity.badRequest().body(Map.of("message", "memId는 필수 파라미터입니다."));
        }
        if (amount == null || amount < 1) {
            return ResponseEntity.badRequest().body(Map.of("message", "amount는 1 이상이어야 합니다."));
        }

        // 포인트 충전 서비스 호출
        PointCharge chargedPoint = pointChargeService.chargePoints(memId, amount);

        // 'METHOD' 값 제한 (10자 이내)
        String method = chargedPoint.getMethod();
        if (method.length() > 10) {
            method = method.substring(0, 10); // 10자까지만 잘라서 설정
        }
        chargedPoint.setMethod(method); // 수정된 method 값 저장

        // 보너스 금액 계산 (5%)
        int bonusAmount = (int) Math.ceil(amount * 0.05);

        // 응답 데이터 생성
        Map<String, Object> response = new HashMap<>();
        response.put("message", "포인트 충전이 완료되었습니다.");
        response.put("balanceAfter", chargedPoint.getBalanceAfter());
        response.put("chargeId", chargedPoint.getChargeId());
        response.put("chargeDate", chargedPoint.getChargeDate());
        response.put("method", chargedPoint.getMethod());
        response.put("transactionId", chargedPoint.getTransactionId());
        response.put("bonusAmount", bonusAmount);
        response.put("chargerId", memId);
        response.put("amount", amount);

        return ResponseEntity.ok(response);
    }

    @PostMapping("/refund")
    public ResponseEntity<?> refundPoints(@RequestBody Map<String, Object> requestData) {
        Long memId = null;
        Integer amount = null;

        try {
            memId = Long.parseLong(requestData.get("memId").toString());
        } catch (NumberFormatException | NullPointerException e) {
            return ResponseEntity.badRequest().body(Map.of("message", "유효하지 않은 memId입니다."));
        }

        try {
            amount = Integer.parseInt(requestData.get("amount").toString());
        } catch (NumberFormatException | NullPointerException e) {
            return ResponseEntity.badRequest().body(Map.of("message", "유효하지 않은 amount입니다."));
        }

        // 필수 파라미터 검증
        if (memId == null) {
            return ResponseEntity.badRequest().body(Map.of("message", "memId는 필수 파라미터입니다."));
        }
        if (amount == null || amount < 1) {
            return ResponseEntity.badRequest().body(Map.of("message", "amount는 1 이상이어야 합니다."));
        }

        try {
            Point refundedPoint = pointRefundService.processPointRefund(memId, amount);
            int bonusAmount = (int) Math.ceil(amount * 0.05);

            Map<String, Object> response = new HashMap<>();
            response.put("message", "환불이 완료되었습니다.");
            response.put("balanceAfter", refundedPoint.getBalance());
            response.put("refundAmount", amount - bonusAmount); // 실제 환불된 금액
            response.put("bonusAmount", bonusAmount);
            response.put("memId", memId);

            return ResponseEntity.ok(response);

        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("message", e.getMessage()));
        } catch (Exception e) {
            // 로깅 처리를 추가하는 것이 좋습니다.
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of("message", "서버 내부 오류가 발생했습니다."));
        }
    }

    @PostMapping("/payment")
    public ResponseEntity<Map<String, Object>> makePayment(@RequestBody Map<String, Object> requestData) {
        Long buyerId = null;
        Long sellerId = null;
        Integer amount = null;


        try {
            buyerId = Long.parseLong(requestData.get("buyerId").toString());
            sellerId = Long.parseLong(requestData.get("sellerId").toString());
            amount = requestData.get("amount") instanceof Number ? ((Number) requestData.get("amount")).intValue() : null;

            if (buyerId == null || sellerId == null) {
                return ResponseEntity.badRequest().body(Map.of("message", "buyerId와 sellerId는 필수 파라미터입니다."));
            }
            if (amount == null || amount < 1) {
                return ResponseEntity.badRequest().body(Map.of("message", "amount는 1 이상이어야 합니다."));
            }

            PointTransferred transferredPoints = paymentService.processPayment(buyerId, sellerId, amount);

            Map<String, Object> response = new HashMap<>();
            response.put("message", "포인트 결제가 성공적으로 처리되었습니다.");
            response.put("transferId", transferredPoints.getTransferId());
            response.put("transferAmount", amount);
            response.put("senderId", buyerId);
            response.put("receiverId", sellerId);

            return ResponseEntity.ok(response);

        } catch (NumberFormatException e) { // Long.parseLong()에서 발생할 수 있는 예외 처리
            return ResponseEntity.badRequest().body(Map.of("message", "buyerId 또는 sellerId가 유효한 숫자 형식이 아닙니다."));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("message", e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of("message", "결제 처리 중 예기치 않은 오류가 발생했습니다."));
        }
    }
}