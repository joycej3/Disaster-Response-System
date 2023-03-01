package com.example.Load;

import java.io.IOException;
import java.io.InputStream;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;


@Configuration
@ComponentScan("com.example.restservice")
public class Config {

    @Bean
    public String temp(){
        return "temp";
    }
}
