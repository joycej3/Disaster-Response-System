package com.example.restservice;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpResponse.BodyHandlers;
import java.util.HashMap;
import java.util.Map;
import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpResponse.BodyHandlers;
import java.util.HashMap;
import java.util.concurrent.atomic.AtomicLong;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import com.google.firebase.database.*;

@CrossOrigin
@RestController
@Component
public class Main {

	private static final String template = "Hello, %s!";
	private final AtomicLong counter = new AtomicLong();
	private Database database;
	ReportClassifier reportClassifier = new ReportClassifier();

	@Autowired
	public Main(Database database, FirebaseDatabase getDatabase) throws java.io.FileNotFoundException, java.io.IOException {
		this.database = database;  
	}

	@GetMapping("/backend/greeting")
	public GreetingRecord greeting(@RequestParam(value = "name", defaultValue = "World") String name) {
		return new GreetingRecord(counter.incrementAndGet(), String.format(template, name));
	}

	@GetMapping("/backend/firebase_get")
	public EmergencyRecord firebase() {
        System.out.println("/firebase_get passed");
		Emergency recentEmergency = database.recentEmergency;
		return new EmergencyRecord(recentEmergency.emergency, recentEmergency.injury,
		 recentEmergency.time, recentEmergency.lat, recentEmergency.lon, recentEmergency.reportCategory);
	}

	@PostMapping(path = "/backend/firebase_push", 
        consumes = MediaType.APPLICATION_JSON_VALUE, 
        produces = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<String> firebase_push(@RequestBody Emergency emergency) {
		System.out.println("Attempting firebase push");
		System.out.println(emergency);
		//database.emergencyRef.push().setValueAsync(emergency);
		try {
			reportClassifier.classifyReport(new EmergencyRecord(emergency.emergency, reportClassifier.injuryToBool(emergency.injury), emergency.time,
			 emergency.lat, emergency.lon, reportClassifier.categoryToNumber(emergency.emergency)));
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return new ResponseEntity<>("success", HttpStatus.CREATED);
	}	
	
	@GetMapping("/backend/get_user_info")
	public User get_user_type(@RequestParam String email) {
		System.out.println("backend/get_user_info");
        return database.emailToUserInfo.getOrDefault(email, new User(email, ""));
	}

	@GetMapping("backend/aggregator_get")
	public Map <String, Object> aggregator_get(){
		Map <String , Object> returnMap = new HashMap<>();
		returnMap = database.disasterIdToOngoingDisaster.get("1"); //ongoing disaster has ID of 1

		return returnMap;
	}

}
