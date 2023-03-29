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
	DatabaseReference disasterRef;
	private Emergency recentEmergency = new Emergency(" ", " ", " ", " "," "," ");

	@Autowired
	public Main(FirebaseDatabase getDatabase) throws java.io.FileNotFoundException, java.io.IOException {
		disasterRef = getDatabase.getReference("ReportTable/Uncategorised");
		
		// Attach a listener to read the data at our posts reference
		disasterRef.addChildEventListener(new ChildEventListener() {
			@Override
			public void onChildAdded(DataSnapshot dataSnapshot, String prevChildKey) {
				System.out.println("child added");
				System.out.println("prevchildkey: " + prevChildKey);
				try{
					recentEmergency = emergencyFromSnapshot(dataSnapshot);
				}
				catch(Exception e){
					System.out.println(e);
				}
				System.out.println("got through datasnapshot.getvalue");
				System.out.println(recentEmergency);
				EmergencyRecord newRecord =  new EmergencyRecord(recentEmergency.emergency, recentEmergency.injury,
		 recentEmergency.time, recentEmergency.lat, recentEmergency.lon, recentEmergency.reportCategory);
				try {
					System.out.println("classifying");
					System.out.println("newRecord: " + newRecord);
					boolean successful = ReportClassifier.classifyReport(newRecord);
					if (successful){
						removeRecord(dataSnapshot, disasterRef);
					}
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
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

		  ReportAggregator reportAggregator =  ReportAggregator.builder()
		  	.withFirebaseDatabase(getDatabase)
			.build();
		  reportAggregator.startAggregatingReports();
	}



	@GetMapping("/backend/greeting")
	public GreetingRecord greeting(@RequestParam(value = "name", defaultValue = "World") String name) {
		return new GreetingRecord(counter.incrementAndGet(), String.format(template, name));
	}

	@GetMapping("/backend/firebase_get")
	public EmergencyRecord firebase() {
        System.out.println("/firebase_get passed");
		return new EmergencyRecord(recentEmergency.emergency, recentEmergency.injury,
		 recentEmergency.time, recentEmergency.lat, recentEmergency.lon, recentEmergency.reportCategory);
	}

	@PostMapping(path = "/backend/firebase_push", 
        consumes = MediaType.APPLICATION_JSON_VALUE, 
        produces = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<String> firebase_push(@RequestBody Emergency emergency) {
		System.out.println("Attempting firebase push");
		System.out.println(emergency);
		disasterRef.push().setValueAsync(emergency);
		return new ResponseEntity<>("success", HttpStatus.CREATED);
	}

	private void removeRecord(DataSnapshot dataSnapshot, DatabaseReference databaseReference){
		String key = dataSnapshot.getKey();
		System.out.println("key to be removed: " + key);
		disasterRef.updateChildrenAsync(Map.of(key , null));
	}


	private Emergency emergencyFromSnapshot(DataSnapshot dataSnapshot){
		Emergency emergency  = new Emergency();
		for (DataSnapshot child: dataSnapshot.getChildren()){

			if (child.getKey().contains("latitude")){
				emergency.lat  = Double.toString((Double)child.getValue());
			}
			else if (child.getKey().contains("longitude")){
				emergency.lon = Double.toString((Double)child.getValue());
			}
			else if (child.getKey().contains("emergency")){
				emergency.emergency = (String)child.getValue();
			}
			else if (child.getKey().contains("injury")){
				emergency.injury = (String)child.getValue();
			}
			else if (child.getKey().contains("time")){
				emergency.time = Long.toString((Long)child.getValue());
			}
			
		}
		System.out.println("emergency: " + emergency);
		emergency.reportCategory = Integer.toString(emergencyCategoryToNum(emergency.emergency));
		return emergency;
	}

	private int emergencyCategoryToNum(String emergency){
        if (emergency.toLowerCase().contains("fire")){
            return 0;
        }
        else if (emergency.toLowerCase().contains("flood") || emergency.toLowerCase().contains("quake") 
        || emergency.toLowerCase().contains("natural") ){
            return 1;
        }
        else if (emergency.toLowerCase().contains("traffic")){
            return 2;
        }
        else {
            return 3;
        }
    }

}
