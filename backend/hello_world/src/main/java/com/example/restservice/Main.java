package com.example.restservice;

import java.util.concurrent.atomic.AtomicLong;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.io.FileInputStream;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.*;
import com.google.firebase.database.*;

@RestController
public class Main {

	private static final String template = "Hello, %s!";
	private final AtomicLong counter = new AtomicLong();
	private final FirebaseDatabase database;
	private Emergency recentEmergency = new Emergency("n/a", "n/a");

	public Main() throws java.io.FileNotFoundException, java.io.IOException {
		System.out.println("Initialising firebase");
		FileInputStream serviceAccount =
        new FileInputStream("src/main/java/com/example/restservice/firebase_service_account/group-9-c4e02-firebase-adminsdk-n4ryk-412aeb9e07.json");

        FirebaseOptions options = new FirebaseOptions.Builder()
        .setCredentials(GoogleCredentials.fromStream(serviceAccount))
        .setDatabaseUrl("https://group-9-c4e02-default-rtdb.europe-west1.firebasedatabase.app")
        .build();

        FirebaseApp.initializeApp(options);

		database = FirebaseDatabase.getInstance();
		DatabaseReference ref = database.getReference("test/disasters");
		
		// Attach a listener to read the data at our posts reference
		ref.addChildEventListener(new ChildEventListener() {
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

	@GetMapping("/greeting")
	public GreetingRecord greeting(@RequestParam(value = "name", defaultValue = "World") String name) {
		return new GreetingRecord(counter.incrementAndGet(), String.format(template, name));
	}

	@GetMapping("/firebase")
	public EmergencyRecord firebase() {
		return new EmergencyRecord(recentEmergency.type, recentEmergency.time);
	}

}
