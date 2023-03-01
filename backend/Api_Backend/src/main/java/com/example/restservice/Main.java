package com.example.restservice;

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
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.google.firebase.database.*;

@RestController
@Component
public class Main {

	private static final String template = "Hello, %s!";
	private final AtomicLong counter = new AtomicLong();
	DatabaseReference disasterRef;
	private Emergency recentEmergency = new Emergency("n/a", "n/a");

	@Autowired
	public Main(FirebaseDatabase getDatabase) throws java.io.FileNotFoundException, java.io.IOException {
		registerWithLoadBal(getDatabase);

		disasterRef = getDatabase.getReference("test/disasters");
		
		// Attach a listener to read the data at our posts reference
		disasterRef.addChildEventListener(new ChildEventListener() {
			@Override
			public void onChildAdded(DataSnapshot dataSnapshot, String prevChildKey) {
				System.out.println("child added");
				System.out.println("prevchildkey: " + prevChildKey);
				recentEmergency = dataSnapshot.getValue(Emergency.class);
				System.out.println("got through datasnapshot.getvalue");
				System.out.println("type: " + recentEmergency.type + ", time: " + recentEmergency.time);

			}
		  
			@Override
			public void onChildChanged(DataSnapshot dataSnapshot, String prevChildKey) {
				recentEmergency = dataSnapshot.getValue(Emergency.class);
				System.out.println("changed");
			}
		  
			@Override
			public void onChildRemoved(DataSnapshot dataSnapshot) {
				System.out.println("removed");
			}
		  
			@Override
			public void onChildMoved(DataSnapshot dataSnapshot, String prevChildKey) {
				System.out.println("moved");
			}
		  
			@Override
			public void onCancelled(DatabaseError databaseError) {
				System.out.println("cancelled");
			}
		  });
	}

	@GetMapping("/backend/greeting")
	public GreetingRecord greeting(@RequestParam(value = "name", defaultValue = "World") String name) {
		return new GreetingRecord(counter.incrementAndGet(), String.format(template, name));
	}

	@GetMapping("/backend/firebase_get")
	public EmergencyRecord firebase() {
        System.out.println("/firebase_get passed");
		return new EmergencyRecord(recentEmergency.type, recentEmergency.time);
	}

	@PostMapping(path = "/backend/firebase_push", 
        consumes = MediaType.APPLICATION_JSON_VALUE, 
        produces = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<String> firebase_push(@RequestBody Emergency emergency) {
		System.out.println("Attempting firebase push");
		System.out.println("Type: " + emergency.type + ", time: " + emergency.time);
		disasterRef.push().setValueAsync(emergency);
		return new ResponseEntity<>("success", HttpStatus.CREATED);
	}

	// @CrossOrigin(origins = "*")
	// @GetMapping("/secure_get")
	// public EmergencyRecord firebase() {
	// 	return new EmergencyRecord(recentEmergency.type, recentEmergency.time);
	// }
	// FirebaseToken decodedToken = FirebaseAuth.getInstance().verifyIdToken(idToken);


	private void registerWithLoadBal(FirebaseDatabase database){
		DatabaseReference ipRef = database.getReference("ip");
		ipRef.addChildEventListener(new ChildEventListener() {
			@Override
			public void onChildAdded(DataSnapshot dataSnapshot, String prevChildKey) {
				System.out.println("ipRef got data");
				String loadBalIp = dataSnapshot.getValue(String.class);
				System.out.println("got through datasnapshot.getvalue");
				System.out.println("Got ip from firebase: " + loadBalIp);

				String localIp = loadBalIp;
				
				HttpClient client = HttpClient.newHttpClient();
				HttpRequest request = HttpRequest.newBuilder(URI.create("http://" + loadBalIp + ":8080/register"))
					.header("content-type", "application/json")
					.POST(HttpRequest.BodyPublishers.ofString("{\"type\":\"backend\",\"ip\":\"" + localIp + "\"}"))
					.build();
			
				try {
					client.send(request, BodyHandlers.ofString());
				} catch (IOException | InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

			}
		  
			@Override
			public void onChildChanged(DataSnapshot dataSnapshot, String prevChildKey) {
				System.out.println("changed");
			}
		  
			@Override
			public void onChildRemoved(DataSnapshot dataSnapshot) {
				System.out.println("removed");
			}
		  
			@Override
			public void onChildMoved(DataSnapshot dataSnapshot, String prevChildKey) {
				System.out.println("moved");
			}
		  
			@Override
			public void onCancelled(DatabaseError databaseError) {
				System.out.println("cancelled");
			}
		  });
	}
}
