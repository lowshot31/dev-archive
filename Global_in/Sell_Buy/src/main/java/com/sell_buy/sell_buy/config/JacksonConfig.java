package com.sell_buy.sell_buy.config;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;

@Configuration
public class JacksonConfig {
    @Bean
    @Primary // 기본 ObjectMapper로 지정
    public ObjectMapper defaultObjectMapper() {
        ObjectMapper mapper = new ObjectMapper();
        // LocalDateTime 직렬화를 위한 모듈 등록
        mapper.registerModule(new JavaTimeModule());
        return mapper;
    }

    @Bean(name = "customObjectMapper") // 추가 ObjectMapper 설정 가능 (필요할 경우)
    public ObjectMapper customObjectMapper() {
        ObjectMapper mapper = new ObjectMapper();
        // 추가적인 설정 가능
        return mapper;
    }
}

class ExampleResponse {

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime timestamp;

    public LocalDateTime getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(LocalDateTime timestamp) {
        this.timestamp = timestamp;
    }
}

@RestController
class ExampleController {

    private final ObjectMapper objectMapper;

    // @Primary로 지정된 디폴트 ObjectMapper가 주입됨
    public ExampleController(ObjectMapper objectMapper) {
        this.objectMapper = objectMapper;
    }

    @GetMapping("/test")
    public ExampleResponse getResponse() {
        ExampleResponse response = new ExampleResponse();
        response.setTimestamp(LocalDateTime.now());
        return response;
    }
}