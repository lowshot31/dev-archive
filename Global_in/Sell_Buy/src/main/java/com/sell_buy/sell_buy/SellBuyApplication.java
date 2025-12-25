package com.sell_buy.sell_buy;

import com.sell_buy.sell_buy.api.service.OrderService;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.scheduling.annotation.EnableScheduling;

@EnableScheduling
@SpringBootApplication
public class SellBuyApplication {

    public static void main(String[] args) {
        SpringApplication.run(SellBuyApplication.class, args);
    }

    @Bean
    public CommandLineRunner commandLineRunner(OrderService orderService) {
        return args -> {
            orderService.updateOrderStatus();
        };
    }
}

