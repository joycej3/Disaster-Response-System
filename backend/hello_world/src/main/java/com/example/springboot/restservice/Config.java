package com.example.springboot.restservice;

import java.io.IOException;
import java.io.InputStream;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.http.converter.json.Jackson2ObjectMapperBuilder;

import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.database.FirebaseDatabase;

@Configuration
@ComponentScan("com.example.springboot")
@EnableWebSecurity
public class Config {

    @Bean
    public FirebaseDatabase getDatabase() throws IOException{
        System.out.println("Initialising firebase");
		InputStream serviceAccount =
        getClass().getResourceAsStream("/firebase_service_account/private_key.json");;
        FirebaseOptions options =  FirebaseOptions.builder()
        .setCredentials(GoogleCredentials.fromStream(serviceAccount))
        .setDatabaseUrl("https://group-9-c4e02-default-rtdb.europe-west1.firebasedatabase.app")
        .build();

        FirebaseApp.initializeApp(options);

		return FirebaseDatabase.getInstance();
    }

    @Bean
	@Primary
	public ObjectMapper jacksonObjectMapper(Jackson2ObjectMapperBuilder builder) {
		ObjectMapper objectMapper = builder.build();
		return objectMapper;
	}
}
