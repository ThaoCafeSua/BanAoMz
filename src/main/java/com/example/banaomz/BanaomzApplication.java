package com.example.banaomz;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

@SpringBootApplication
@EnableJpaAuditing
public class BanaomzApplication {

    public static void main(String[] args) {
        SpringApplication.run(BanaomzApplication.class, args);
    }

}
