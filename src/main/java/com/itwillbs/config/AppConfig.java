package com.itwillbs.config;

// ObjectMapper 클래스를 사용하기 위해 반드시 추가해야 하는 import 구문입니다.
import com.fasterxml.jackson.databind.ObjectMapper; 

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;

@Configuration
public class AppConfig {

    /**
     * RestTemplate 객체를 스프링 빈으로 등록합니다.
     * 이제 다른 클래스에서 생성자 주입을 통해 이 빈을 사용할 수 있습니다.
     */
    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }
    
    /**
     * ObjectMapper 객체를 스프링 빈으로 등록합니다.
     */
    @Bean
    public ObjectMapper objectMapper() {
        // ObjectMapper 객체를 생성합니다.
        ObjectMapper objectMapper = new ObjectMapper();
        
        // 필요하다면 여기에 ObjectMapper에 대한 추가 설정을 할 수 있습니다.
        // (예: 날짜 형식 지정, 특정 필드 무시 등)
        
        // 설정이 완료된 ObjectMapper 객체를 반환합니다.
        return objectMapper;
    }
}