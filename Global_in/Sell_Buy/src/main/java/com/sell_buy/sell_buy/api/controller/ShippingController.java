package com.sell_buy.sell_buy.api.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.Mapping;
//배송조회
@Controller
public class ShippingController {
    @GetMapping ("/ship")
    public String asd(){
        return "ship";
    }

}
