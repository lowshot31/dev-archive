package com.sell_buy.sell_buy;

import com.sell_buy.sell_buy.api.controller.OrderController;
import com.sell_buy.sell_buy.api.service.OrderService;
import com.sell_buy.sell_buy.db.entity.Order;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import java.time.LocalDateTime;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
public class OrderControllerTest {
    private MockMvc mockMvc;
    @Mock
    private OrderService orderService;
    @InjectMocks
    private OrderController orderController;

    @BeforeEach()
    public void setup() {
        MockitoAnnotations.openMocks(this);
        mockMvc = MockMvcBuilders.standaloneSetup(orderController).build();
    }

    @Test
    public void orderControllerTRegister() throws Exception {
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("memId", 1L);
        Order order = Order.builder()
                .transferId(1L)
                .prodId(1L)
                .sellerId(3L)
                .buyerId(2L)
                .receiverName("test")
                .receiverAddress("testaddress")
                .receiverPhone("01011111111")
                .orderType(2)
                .createdDate(LocalDateTime.now())
                .deliveredDate(LocalDateTime.now())
                .carrierStatus("배송준비")
                .build();

        when(orderService.registerOrder(any(Order.class))).thenReturn(order);
        mockMvc.perform(post("/order/register")
                        .session(session)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"transferId\":1,\"prodId\":1,\"sellerId\":3,\"buyerId\":2,\"receiverName\":\"test\"," +
                                "\"receiverAddress\":\"testaddress\",\"receiverPhone\":\"01011111111\",\"orderStatus\":\"배송준비\"," +
                                "\"createdDate\":\"2023-10-10T10:00:00\"," +
                                "\"deliveredDate\":\"2023-10-15T10:00:00\" ," +
                                "\"orderId\":1}"))
                .andExpect(status().isOk())
                .andExpect(content().string("1")); // orderId가 반환될 것으로 예상
    }
}

