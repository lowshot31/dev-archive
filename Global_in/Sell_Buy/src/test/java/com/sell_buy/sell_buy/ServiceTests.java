package com.sell_buy.sell_buy;

import com.sell_buy.sell_buy.api.service.PaymentService;
import com.sell_buy.sell_buy.api.service.PointChargeService;
import com.sell_buy.sell_buy.api.service.PointRefundService;
import com.sell_buy.sell_buy.db.entity.Point;
import com.sell_buy.sell_buy.db.entity.PointCharge;
import com.sell_buy.sell_buy.db.entity.PointTransferred;
import com.sell_buy.sell_buy.db.repository.AccountRepository;
import com.sell_buy.sell_buy.db.repository.PointChargeRepository;
import com.sell_buy.sell_buy.db.repository.PointTransferredRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.*;

public class ServiceTests {

    @InjectMocks
    private PaymentService paymentService;

    @InjectMocks
    private PointChargeService pointChargeService;

    @InjectMocks
    private PointRefundService pointRefundService;

    @InjectMocks
    private RefundService refundService;

    @Mock
    private AccountRepository accountRepository;

    @Mock
    private PointChargeRepository pointChargeRepository;

    @Mock
    private PointTransferredRepository pointTransferredRepository;

    @Mock
    private Point buyerPoint;

    @Mock
    private Point sellerPoint;

    @Mock
    private Point chargerPoint;

    @BeforeEach
    public void setUp() {
        MockitoAnnotations.openMocks(this);
        // Balance 설정
        when(buyerPoint.getBalance()).thenReturn(1000);
        when(sellerPoint.getBalance()).thenReturn(500);
        when(chargerPoint.getBalance()).thenReturn(1000);
    }

    // 1. PaymentService 테스트
    @Test
    public void testProcessPayment() {
        Long buyerId = 1L;
        Long sellerId = 2L;
        int amount = 300;

        mockAccountRepository(buyerId, sellerId);

        PointTransferred result = paymentService.processPayment(buyerId, sellerId, amount);

        verifyPaymentResult(result, buyerId, sellerId, 700, 800);
    }

    private void mockAccountRepository(Long buyerId, Long sellerId) {
        when(accountRepository.findById(buyerId)).thenReturn(java.util.Optional.of(buyerPoint));
        when(accountRepository.findById(sellerId)).thenReturn(java.util.Optional.of(sellerPoint));
    }

    private void verifyPaymentResult(PointTransferred result, Long buyerId, Long sellerId, int expectedBuyerBalance, int expectedSellerBalance) {
        assertNotNull(result);
        assertEquals(expectedBuyerBalance, buyerPoint.getBalance());
        assertEquals(expectedSellerBalance, sellerPoint.getBalance());
        assertEquals(buyerId, result.getSenderId());
        assertEquals(sellerId, result.getReceiverId());
        verify(accountRepository, times(2)).save(any(Point.class));
        verify(pointTransferredRepository, times(1)).save(any(PointTransferred.class));
    }

    // 2. PointChargeService 테스트
    @Test
    public void testChargePoints() {
        Long userId = 1L;
        String accountNumber = "123456789";
        int amount = 500;

        when(accountRepository.findByMemId(userId)).thenReturn(java.util.Optional.of(chargerPoint));
        when(chargerPoint.getBalance()).thenReturn(1000); // chargerPoint balance 설정

        PointCharge result = pointChargeService.chargePoints(userId, accountNumber, amount);

        assertNotNull(result);
        assertEquals(1500, chargerPoint.getBalance()); // 충전 후 balance 확인
        assertEquals(amount, result.getAmount());
        verify(accountRepository, times(1)).save(any(Point.class));
        verify(pointChargeRepository, times(1)).save(any(PointCharge.class));
        verify(pointTransferredRepository, times(1)).save(any(PointTransferred.class));
    }

    // 3. PointRefundService 테스트
    @Test
    public void testProcessPointRefund() {
        Long buyerId = 1L;
        int amount = 500;

        PointCharge pointCharge = new PointCharge();
        pointCharge.setAmount(500); // PointCharge 설정
        when(accountRepository.findByMemId(buyerId)).thenReturn(java.util.Optional.of(buyerPoint));
        when(pointChargeRepository.findTopByChargerIdOrderByChargeDateDesc(buyerId)).thenReturn(java.util.Optional.of(pointCharge));

        pointRefundService.processPointRefund(buyerId, amount);

        assertEquals(1500, buyerPoint.getBalance()); // 환불 후 balance 확인
        verify(accountRepository, times(1)).save(any(Point.class));
        verify(pointTransferredRepository, times(1)).save(any(PointTransferred.class));
    }

    // 4. RefundService 테스트
    @Test
    public void testProcessRefund() {
        Long buyerId = 1L;
        Long sellerId = 2L;
        int amount = 300;

        PointTransferred payment = new PointTransferred();
        payment.setAmount(300);
        when(accountRepository.findById(buyerId)).thenReturn(java.util.Optional.of(buyerPoint));
        when(accountRepository.findById(sellerId)).thenReturn(java.util.Optional.of(sellerPoint));
        when(pointTransferredRepository.findTopBySenderIdAndReceiverIdOrderByTransferDateDesc(buyerId, sellerId)).thenReturn(java.util.Optional.of(payment));

        refundService.processRefund(buyerId, sellerId, amount);

        assertEquals(1300, buyerPoint.getBalance()); // 환불 후 buyer balance 확인
        assertEquals(200, sellerPoint.getBalance()); // 환불 후 seller balance 확인
        verify(accountRepository, times(2)).save(any(Point.class));
        verify(pointTransferredRepository, times(1)).save(any(PointTransferred.class));
    }
}
