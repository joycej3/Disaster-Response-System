package com.example.restservice.config;
import java.io.IOException;
import java.io.InputStream;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

import com.example.restservice.Database;
import com.example.restservice.security.models.SecurityProperties;
import com.example.restservice.Database;
import com.google.auth.oauth2.GoogleCredentials;

import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.messaging.FirebaseMessaging;



@Configuration
public class FirebaseConfig {
	@Autowired
	private SecurityProperties secProps;
	
	@Primary
	@Bean
	public FirebaseApp getfirebaseApp() throws IOException {
		InputStream serviceAccount =
		getClass().getResourceAsStream("/firebase_service_account/private_key.json");;
		FirebaseOptions options = FirebaseOptions.builder().setCredentials(GoogleCredentials.fromStream(serviceAccount))
				.setDatabaseUrl(secProps.getFirebaseProps().getDatabaseUrl())
				.build();
		if (FirebaseApp.getApps().isEmpty()) {
			FirebaseApp.initializeApp(options);
		}
		return FirebaseApp.getInstance();
	}


	@Bean
	public FirebaseAuth getAuth() throws IOException {
		System.out.println("Initialising firebase Auth");
		return FirebaseAuth.getInstance(getfirebaseApp());
	}


	@Bean
    public FirebaseDatabase getDatabase() throws IOException{
		System.out.println("Initialising firebase database");
		return FirebaseDatabase.getInstance();
    }


	@Bean
    public Database database() throws IOException{
		System.out.println("Initialising  database");
		return new Database(getDatabase());
    }


	@Bean
    public FirebaseMessaging firebaseMessaging() throws IOException {
		System.out.println("Initialising firebase messaging");
        return FirebaseMessaging.getInstance(getfirebaseApp());
    }
}