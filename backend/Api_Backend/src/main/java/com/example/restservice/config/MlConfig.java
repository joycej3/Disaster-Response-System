package com.example.restservice.config;
import java.io.IOException;
import java.io.InputStream;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.example.restservice.DecisionModel;


@Configuration
public class MlConfig {
	
	@Bean
	public DecisionModel decisionModel() throws IOException {
		return new DecisionModel();
	}
}