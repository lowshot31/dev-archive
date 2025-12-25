package com.sell_buy.sell_buy.api.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.sell_buy.sell_buy.api.service.AuthenticationService;
import com.sell_buy.sell_buy.api.service.OrderService;
import com.sell_buy.sell_buy.api.service.ProductService;
import com.sell_buy.sell_buy.db.entity.Member;
import com.sell_buy.sell_buy.db.entity.Product;
import lombok.RequiredArgsConstructor;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.data.domain.Slice;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.Reader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;

import static com.sell_buy.sell_buy.common.utills.CommonUtils.processProductList;

@Controller
@RequiredArgsConstructor
public class MainController {

    private final ProductService productService;
    private final ObjectMapper objectMapper;// ObjectMapper 주입
    private final OrderService orderService;
    private final AuthenticationService authenticationService;
    @GetMapping("/")
    public ModelAndView test() throws JsonProcessingException { // JsonProcessingException 예외 처리 추가
        System.out.println("Hello World"); // TODO: Remove this line

        Slice<Product> productListSlice = productService.getProductList(1, 18, null, null, null);
        List<Product> productList = productListSlice.getContent();

        // 이미지 URL 처리 로직 추가
        List<Product> processedProductList = new ArrayList<>();
        for (Product product : productList) {
            String imageUrlsJson = product.getImageUrls();
            List<String> imageUrls = new ArrayList<>();
            if (imageUrlsJson != null && !imageUrlsJson.isEmpty()) {
                // JSON 파싱 오류 방지: try-catch 블록 추가
                try {
                    imageUrls = objectMapper.readValue(imageUrlsJson, objectMapper.getTypeFactory().constructCollectionType(List.class, String.class));
                    if (!imageUrls.isEmpty()) {
                        product.setImageUrls(imageUrls.get(0)); // 첫 번째 이미지 URL 만 저장 (setImageUrls 메소드를 재활용 - setter 이름이 오해를 일으킬 수 있지만, 편의상 재활용)
                    } else {
                        product.setImageUrls(null); // 이미지 URL 없는 경우 null 설정 (setter 재활용)
                    }
                } catch (JsonProcessingException e) {
                    product.setImageUrls(null); // JSON 파싱 실패 시 null 설정 (setter 재활용)
                }
            } else {
                product.setImageUrls(null); // imageUrlsJson 이 null 이거나 비어있는 경우 null 설정 (setter 재활용)
            }
            processedProductList.add(product);
        }


        ModelAndView modelAndView = new ModelAndView("index");
        modelAndView.addObject("productList", processedProductList); // 가공된 상품 목록 전달
        return modelAndView;
    }

    @GetMapping("/prod/list-partial") // prodListPartial.jsp 에서 AJAX 요청을 보낼 URL 매핑 (유지)
    public ModelAndView getProductListPartial(
            @RequestParam(name = "page", defaultValue = "1") int page,
            @RequestParam(name = "catId", required = false) Long catId,
            @RequestParam(name = "searchQuery", required = false) String searchQuery,
            @RequestParam(name = "searchType", required = false) String searchType) throws JsonProcessingException { // JsonProcessingException 예외 처리 유지

        Slice<Product> productListSlice = productService.getProductList(page, 18, catId, searchQuery, searchType);
        List<Product> productList = productListSlice.getContent();

        // 이미지 URL 처리 로직 (수정됨: listImageUrls 에 전체 목록 설정)
        List<Product> processedProductList = processProductList(productList);

        ModelAndView modelAndView = new ModelAndView("include/prodListPartial");
        modelAndView.addObject("productList", processedProductList); // 가공된 상품 목록 전달
        return modelAndView;
    }

    @PostMapping("/confirm")
    public ResponseEntity<JSONObject> confirmPayment(@RequestBody String jsonBody) throws Exception {
        JSONParser parser = new JSONParser();
        String orderId; //난수
        String amount; // 금액
        String paymentKey;
        String prodName;
        try {
            // 클라이언트에서 받은 JSON 요청 바디입니다.
            JSONObject requestData = (JSONObject) parser.parse(jsonBody);
            paymentKey = (String) requestData.get("paymentKey");
            orderId = (String) requestData.get("orderId");
            amount = (String) requestData.get("amount");
            prodName = (String) requestData.get("prodName");
        } catch (ParseException e) {
            throw new RuntimeException(e);
        }
        JSONObject obj = new JSONObject();
        obj.put("orderId", orderId);
        obj.put("amount", amount);
        obj.put("paymentKey", paymentKey);

        // 토스페이먼츠 API는 시크릿 키를 사용자 ID로 사용하고, 비밀번호는 사용하지 않습니다.
        // 비밀번호가 없다는 것을 알리기 위해 시크릿 키 뒤에 콜론을 추가합니다.
        String widgetSecretKey = "test_gsk_docs_OaPz8L5KdmQXkzRz3y47BMw6";
        Base64.Encoder encoder = Base64.getEncoder();
        byte[] encodedBytes = encoder.encode((widgetSecretKey + ":").getBytes(StandardCharsets.UTF_8));
        String authorizations = "Basic " + new String(encodedBytes);

        // 결제를 승인하면 결제수단에서 금액이 차감돼요.
        URL url = new URL("https://api.tosspayments.com/v1/payments/confirm");
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestProperty("Authorization", authorizations);
        connection.setRequestProperty("Content-Type", "application/json");
        connection.setRequestMethod("POST");
        connection.setDoOutput(true);

        OutputStream outputStream = connection.getOutputStream();
        outputStream.write(obj.toString().getBytes(StandardCharsets.UTF_8));

        int code = connection.getResponseCode();
        boolean isSuccess = code == 200;

        InputStream responseStream = isSuccess ? connection.getInputStream() : connection.getErrorStream();

        // 결제 성공 및 실패 비즈니스 로직을 구현하세요.
        Reader reader = new InputStreamReader(responseStream, StandardCharsets.UTF_8);
        JSONObject jsonObject = (JSONObject) parser.parse(reader);
        responseStream.close();
        if (code == 200) {
            System.out.println("결제 성공했습니다!");
            //결제 성공시

            Member member = authenticationService.getAuthenticatedMember();
            prodName = (String) jsonObject.get("orderName");
            orderService.updatePaymentStatus(prodName,member);
            return ResponseEntity.status(code).body(jsonObject);
        } else {
            return ResponseEntity.status(code).body(jsonObject);
        }


    }

}