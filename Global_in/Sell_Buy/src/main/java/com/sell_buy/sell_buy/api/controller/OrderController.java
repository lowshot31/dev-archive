package com.sell_buy.sell_buy.api.controller;

import com.sell_buy.sell_buy.api.service.AuthenticationService;
import com.sell_buy.sell_buy.api.service.OrderService;
import com.sell_buy.sell_buy.api.service.ProductService;
import com.sell_buy.sell_buy.db.entity.Member;
import com.sell_buy.sell_buy.db.entity.Order;
import com.sell_buy.sell_buy.db.entity.Product;
import com.sell_buy.sell_buy.db.repository.MemberRepository;
import com.sell_buy.sell_buy.db.repository.OrderRepository;
import com.sell_buy.sell_buy.db.repository.ProductRepository;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.time.LocalDateTime;

@Slf4j
@Controller
@RequestMapping("/order")
@RequiredArgsConstructor
public class OrderController {
    private final AuthenticationService authenticationService;
    private final OrderService orderService;
    private final ProductService productService;
    private final OrderRepository orderRepository;
    private final MemberRepository memberRepository;
    private final ProductRepository productRepository;

//    @GetMapping("/")
//    public void updateState() {
//        orderService.updateOrderStatus();
//    }
    //주문 수정
    @GetMapping("modify/{orderId}")
    public String modifyOrder(@PathVariable Long orderId, ModelAndView modelAndView) {
        modelAndView.setViewName("orderRegister");
        // orderid findby로 넘겨서 여러개 찾아서 attr 설정해주고 뿌려주기
        return "orderRegister";
    }

    //상품등록했을때
    @PostMapping("/register")
    public ResponseEntity<?> orderRegister(@RequestBody Product product) {
        Member member = authenticationService.getAuthenticatedMember();
        String prodName = product.getProdName();
        System.out.println(prodName + "member "+member);
        if (member == null) {
            return ResponseEntity.status(400).body("Login First");
        } else {
            // memid, prodname을 넘겨줌
            orderService.updateProdOrder(member, prodName);
            return ResponseEntity.status(200).body(member.getMemId());

        }
    }

    @DeleteMapping("/{orderId}/delete")
    public ResponseEntity<?> deleteOrder(@PathVariable Long orderId, HttpSession session) {
        Member member = authenticationService.getAuthenticatedMember();
        Long sellerId = member.getMemId();
        Long orderSellerId = orderService.getSellOrder(sellerId);
//        판매자아이디가 없을시
//        오더번호가 존재하지않을 때
        if (orderService.hasExistOrder(orderId)) {
            return ResponseEntity.status(400).body("OrderId IS NOT EXIST");
        }
        // 팬마자가 가진 오더가 아닐 때
        if (!orderService.hasExistOrderIdBySellerId(sellerId)) {
            return ResponseEntity.status(400).body("OrderId Seller is not matched");
        } else {
            orderService.deleteOrder(orderId);
            return ResponseEntity.status(200).body("deleteOrder Success");
        }
    }

    //    결제했을때
    //@RequestHeader(value = "Referer", required = false) String referer 이거 쓰면 요청들어온 주소창마다 다르게 할수있음
    @PutMapping("/put/{prodName}") // orderid
    public ResponseEntity<?> putProd(@PathVariable String prodName, @RequestBody Order order, HttpSession session) {
        Member member = authenticationService.getAuthenticatedMember();
        System.out.println("결제 했을 때 오는 페이지");
        // buyerid -> 정보 가져오기
        Member memAttrList = memberRepository.findByMemId(order.getBuyerId());
        Product prod = productRepository.findByProdName(prodName);
        //order 로 들어오는거는 buyerId & prodId
        Order order1 = orderRepository.findByProdId(prod.getProdId());
        Long sellerId = member.getMemId();
        if (orderService.hasExistOrder(order1.getOrderId())) {
            return ResponseEntity.status(400).body("OrderId IS not EXIST");
        }
        if (orderService.hasExistOrderIdBySellerId(sellerId)) {
            return ResponseEntity.status(400).body("OrderId Seller is not matched");
        } else {
            return ResponseEntity.status(200).body(order1.getOrderId());
        }

    }

    //배송번호 입력
    @PutMapping("/put/{orderId}")
    public ResponseEntity<?> putOrder(@PathVariable Long orderId, @RequestParam int orderStatus, @RequestParam String carrier
            , @RequestParam String trackingNo) {
        Member member = authenticationService.getAuthenticatedMember();
        long sellerId = member.getMemId();
        if (!orderRepository.existsOrderIdBySellerId(sellerId)) {
            return ResponseEntity.status(400).body("OrderId Seller is not matched");
        } else {
            orderService.updateOrder(orderId, orderStatus, carrier, trackingNo);
            return ResponseEntity.status(200).body("putOrder Success");
        }

    }
}