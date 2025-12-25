package com.sell_buy.sell_buy.api.controller;

import com.sell_buy.sell_buy.api.service.AuthenticationService;
import com.sell_buy.sell_buy.api.service.OrderService;
import com.sell_buy.sell_buy.db.entity.Member;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@RequestMapping(value = "/payment")
@RequiredArgsConstructor
@Controller
public class WidgetController {
    private final AuthenticationService authenticationService;
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    private final OrderService orderService;

    @GetMapping("/{prodId}")
    public ModelAndView processPayment(@PathVariable("prodId") long prodId,
                                       @RequestParam("prodName") String prodName,
                                       @RequestParam("price") String price) {
        Member member = authenticationService.getAuthenticatedMember();
        // 받은 값 처리
        System.out.println(prodId);
        System.out.println("Product name: " + prodName);
        System.out.println("Price: " + price);
        // 결제 페이지로 이동
        ModelAndView modelAndView = new ModelAndView("payment_checkout");
        modelAndView.setViewName("payment_checkout");
        modelAndView.addObject("prodId", prodId);
        modelAndView.addObject("memId", member.getMemId());
        modelAndView.addObject("prodName", prodName);
        modelAndView.addObject("price", price);
        modelAndView.addObject("email", member.getEmail());
        modelAndView.addObject("phone", member.getPhoneNum());
        modelAndView.addObject("address", member.getAddress());
        modelAndView.addObject("memName", member.getName());
        return modelAndView;
    }

    @GetMapping(value = "/success")
    public String success() {
        return "payment_success";
    }


}