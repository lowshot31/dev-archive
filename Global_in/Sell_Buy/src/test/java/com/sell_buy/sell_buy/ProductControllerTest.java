/*
package com.sell_buy.sell_buy;

import com.sell_buy.sell_buy.api.controller.ProductController;
import com.sell_buy.sell_buy.api.service.ProductService;
import com.sell_buy.sell_buy.db.entity.Product;
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
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
public class ProductControllerTest {
    private MockMvc mockMvc;

    @Mock
    private ProductService productService;

    @InjectMocks
    private ProductController productController;

    @BeforeEach
    public void setup() {
        MockitoAnnotations.openMocks(this);
        mockMvc = MockMvcBuilders.standaloneSetup(productController).build();
    }

    private MockHttpSession createSession(Long memId) {
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("memId", memId);
        return session;
    }

    @Test
    public void shouldRegisterProductWhenSessionExists() throws Exception {
        MockHttpSession session = createSession(1L);
        Product product = Product.builder()
                .prodName("Example Product")
                .prodDisc("This is an example product.")
                .price(100)
                .category(1L)
                .isAuction(false)
                .createDate(LocalDateTime.now())
                .build();

        when(productService.registerProduct(any(Product.class))).thenReturn(product);

        String productJson = "{\"prodName\":\"Example Product\",\"prodDisc\":\"This is an example product.\",\"price\":100,\"category\":1,\"isAuction\":false,\"createDate\":\"2023-10-10T10:00:00\"}";

        mockMvc.perform(post("/prod")
                        .session(session)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(productJson))
                .andExpect(status().isOk());
    }

    @Test
    public void shouldUpdateProductWhenProductExists() throws Exception {
        MockHttpSession session = createSession(1L);
        Product product = Product.builder()
                .prodId(1L)
                .prodName("Example Product")
                .prodDisc("This is an example product.")
                .price(100)
                .category(1L)
                .isAuction(false)
                .createDate(LocalDateTime.now())
                .build();

        doReturn(true).when(productService).existsById(1L);
        when(productService.updateProduct(any(Product.class))).thenReturn(product);

        doAnswer(invocation -> {
            Long id = invocation.getArgument(0);
            System.out.println("existsById called with: " + id);
            return true;
        }).when(productService).existsById(any(Long.class));

        String productJson = "{\"prodId\":1,\"prodName\":\"Example Product\",\"prodDisc\":\"This is an example product.\",\"price\":100,\"category\":1,\"isAuction\":false,\"createDate\":\"2023-10-10T10:00:00\"}";

        mockMvc.perform(put("/prod/1")
                        .session(session)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(productJson))
                .andDo(print())
                .andExpect(status().isOk());
    }

    @Test
    public void shouldReturnProductById() throws Exception {
        Product product = Product.builder()
                .prodId(1L)
                .sellerId(1L)
                .prodName("Example Product")
                .prodDisc("This is an example product.")
                .price(100)
                .category(1L)
                .isAuction(false)
                .createDate(LocalDateTime.now())
                .build();

        when(productService.existsById(1L)).thenReturn(true);
        when(productService.getProductById(1L)).thenReturn(product);

        mockMvc.perform(get("/prod/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.prodName").value("Example Product"))
                .andExpect(jsonPath("$.price").value(100));
    }
}


 */
