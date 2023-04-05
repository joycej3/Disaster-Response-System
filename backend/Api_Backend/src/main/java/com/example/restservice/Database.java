package com.example.restservice;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;

import com.google.firebase.database.ChildEventListener;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;

public class Database {
    private FirebaseDatabase database;
    private String suggestionRefPath = "something/suggestions";
    private String ongoingDisastersRefPath = "ReportTable/Categorised/Ongoing";
    private String decisionsRefPath = "Decisions";
    private String userRefPath = "users";
	private String emergencyRefPath = "ReportTable/Uncategorised";
    public HashMap<String, HashMap<String, Object>> disasterIdToOngoingDisaster = new HashMap();
    public HashMap<String, HashMap<String, Double>> disasterIdToOngoingDisasterModel = new HashMap();
    public HashMap<String, Decision> disasterIdToSuggestion = new HashMap();
    public HashMap<String, Decision> disasterIdToDecision = new HashMap();
    public HashMap<String, User> emailToUserInfo = new HashMap();
	public Emergency recentEmergency = new Emergency(" ", " ", " ", " ", " ", " ");
    public DatabaseReference suggestionRef;
    public DatabaseReference ongoingDisastersRef;
    public DatabaseReference decisionsRef;
    public DatabaseReference userRef;
	public DatabaseReference emergencyRef;

	@Autowired
    public Database(FirebaseDatabase getDatabase){
		System.out.println("Setting up database");
        this.database = getDatabase;
        setupListeners();
    }

    private void setupListeners(){
		ReportAggregator reportAggregator = ReportAggregator.builder()
		  	.withFirebaseDatabase(database)
			.build();
		reportAggregator.startAggregatingReports();
        setupSuggestionListener();
        setupOngoingDisasterListener();
		setupUserListener();
        setupDecisionsListener();
		setupEmergencyListener();
    }

    private void setupSuggestionListener(){
        suggestionRef = database.getReference(suggestionRefPath);

		suggestionRef.addChildEventListener(new ChildEventListener() {
			@Override
			public void onChildAdded(DataSnapshot dataSnapshot, String prevChildKey) {
				Decision decision = dataSnapshot.getValue(Decision.class);
                String key = dataSnapshot.getKey();
				disasterIdToSuggestion.put(key, decision);
				System.out.println("added suggestion: " + key);
			}
		  
			@Override
			public void onChildChanged(DataSnapshot dataSnapshot, String prevChildKey) {
				Decision decision = dataSnapshot.getValue(Decision.class);
                String key = dataSnapshot.getKey();
				disasterIdToSuggestion.put(key, decision);
				System.out.println("updated suggestion: " + decision);
			}
		  
			@Override
			public void onChildRemoved(DataSnapshot dataSnapshot) {
                String key = dataSnapshot.getKey();
				disasterIdToSuggestion.remove(key);
				System.out.println("removed suggestion: " + key);
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

    private void setupOngoingDisasterListener(){
        ongoingDisastersRef = database.getReference(ongoingDisastersRefPath);

		ongoingDisastersRef.addChildEventListener(new ChildEventListener() {
			@Override
			public void onChildAdded(DataSnapshot dataSnapshot, String prevChildKey) {
				System.out.println("Ongoing disaster added");
				HashMap<String, Object> disaster = new HashMap<>();
				for (DataSnapshot snapshot: dataSnapshot.getChildren()) {
					String subKey = snapshot.getKey();
					if(subKey != "Reports"){
						String value = snapshot.getValue(Object.class).toString();
						disaster.put(subKey, value);
						System.out.println(subKey + ": " + value);
					}
				}
                String key = dataSnapshot.getKey();
				System.out.println("ongoing disaster added: " + key);
				disasterIdToOngoingDisaster.put(key, disaster);
				System.out.println("ongoing disaster added succesfully: " + key);
				
				HashMap<String, Double> parsed_disaster = new HashMap<>();
				parsed_disaster.put("known_injury", Double.valueOf(disaster.get("KnownInjury").toString()));
				parsed_disaster.put("incident_type_code", Double.valueOf(disaster.get("IncidentType").toString()));
				parsed_disaster.put("area_size", Double.valueOf(disaster.get("Area").toString()));
				parsed_disaster.put("first_report", Double.valueOf(disaster.get("FirstReported").toString()));
				parsed_disaster.put("location_Dn Laoghaire-Rathdown", 0d);
				parsed_disaster.put("location_Dublin City", 0d);
				parsed_disaster.put("location_Fingal", 0d);
				parsed_disaster.put("location_South Dublin", 0d);
				String neighborhood = disaster.get("Location").toString();
				if(neighborhood == "FN"){
					parsed_disaster.put("location_Fingal", 1d);
				} else if (neighborhood == "DLR"){
					parsed_disaster.put("location_Dn Laoghaire-Rathdown", 1d);
				} else if (neighborhood == "DS") {
					parsed_disaster.put("location_South Dublin", 1d);
				} else if (neighborhood == "DC") {
					parsed_disaster.put("location_Dublin City", 1d);
				}
				parsed_disaster.put("weather_cloudy", 1d);
				parsed_disaster.put("weather_fog", 0d);
				parsed_disaster.put("weather_rain", 0d);
				parsed_disaster.put("weather_sunshine", 0d);

				disasterIdToOngoingDisasterModel.put(key, parsed_disaster);
				System.out.println("added disaster for model parsing: " + key);
			}
		  
			@Override
			public void onChildChanged(DataSnapshot dataSnapshot, String prevChildKey) {
				HashMap<String, Object> disaster = dataSnapshot.getValue(HashMap.class);
                String key = dataSnapshot.getKey();
				disasterIdToOngoingDisaster.put(key, disaster);
				
				HashMap<String, Double> parsed_disaster = new HashMap<>();
				parsed_disaster.put("known_injury", Double.valueOf(disasterIdToOngoingDisaster.get("KnownInjury").toString()));
				parsed_disaster.put("incident_type_code", Double.valueOf(disasterIdToOngoingDisaster.get("IncidentType").toString()));
				parsed_disaster.put("area_size", Double.valueOf(disasterIdToOngoingDisaster.get("Area").toString()));
				parsed_disaster.put("first_report", Double.valueOf(disasterIdToOngoingDisaster.get("FirstReported").toString()));
				parsed_disaster.put("location_Dn Laoghaire-Rathdown", 0d);
				parsed_disaster.put("location_Dublin City", 0d);
				parsed_disaster.put("location_Fingal", 0d);
				parsed_disaster.put("location_South Dublin", 0d);
				String neighborhood = disasterIdToOngoingDisaster.get("Location").toString();
				if(neighborhood == "FN"){
					parsed_disaster.put("location_Fingal", 1d);
				} else if (neighborhood == "DLR"){
					parsed_disaster.put("location_Dn Laoghaire-Rathdown", 1d);
				} else if (neighborhood == "DS") {
					parsed_disaster.put("location_South Dublin", 1d);
				} else if (neighborhood == "DC") {
					parsed_disaster.put("location_Dublin City", 1d);
				}
				parsed_disaster.put("weather_cloudy", 1d);
				parsed_disaster.put("weather_fog", 0d);
				parsed_disaster.put("weather_rain", 0d);
				parsed_disaster.put("weather_sunshine", 0d);

				disasterIdToOngoingDisasterModel.put(key, parsed_disaster);
				System.out.println("updated ongoing disaster: " + disaster);
			}
		  
			@Override
			public void onChildRemoved(DataSnapshot dataSnapshot) {
                String key = dataSnapshot.getKey();
				disasterIdToOngoingDisaster.remove(key);
				disasterIdToOngoingDisasterModel.remove(key);
				System.out.println("removed ongoing disaster: " + key);
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

    private void setupDecisionsListener(){
        decisionsRef = database.getReference(decisionsRefPath);

		decisionsRef.addChildEventListener(new ChildEventListener() {
			@Override
			public void onChildAdded(DataSnapshot dataSnapshot, String prevChildKey) {
				Decision decision = dataSnapshot.getValue(Decision.class);
                String key = dataSnapshot.getKey();
				disasterIdToDecision.put(key, decision);
				System.out.println("added decision: " + key);
			}
		  
			@Override
			public void onChildChanged(DataSnapshot dataSnapshot, String prevChildKey) {
				Decision decision = dataSnapshot.getValue(Decision.class);
                String key = dataSnapshot.getKey();
				disasterIdToDecision.put(key, decision);
				System.out.println("updated decision: " + key);
            }
		  
			@Override
			public void onChildRemoved(DataSnapshot dataSnapshot) {
                String key = dataSnapshot.getKey();
				disasterIdToDecision.remove(key);
				System.out.println("removed decision: " + key);
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

    private void setupUserListener(){
        userRef = database.getReference(userRefPath);

		userRef.addChildEventListener(new ChildEventListener() {
			@Override
			public void onChildAdded(DataSnapshot dataSnapshot, String prevChildKey) {
				System.out.println("attempt to add user");
				User userRecord = dataSnapshot.getValue(User.class);
				emailToUserInfo.put(userRecord.email, userRecord);
				System.out.println("added user: " + userRecord.email);
			}
		  
			@Override
			public void onChildChanged(DataSnapshot dataSnapshot, String prevChildKey) {
				User userRecord = dataSnapshot.getValue(User.class);
				emailToUserInfo.put(userRecord.email, userRecord);
				System.out.println("user updated: " + userRecord.email);
			}
		  
			@Override
			public void onChildRemoved(DataSnapshot dataSnapshot) {
				User userRecord = dataSnapshot.getValue(User.class);
				emailToUserInfo.remove(userRecord.email);
				System.out.println("user removed: " + userRecord.email);
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

	private void setupEmergencyListener(){
        emergencyRef = database.getReference(emergencyRefPath);

		emergencyRef.addChildEventListener(new ChildEventListener() {
			@Override
			public void onChildAdded(DataSnapshot dataSnapshot, String prevChildKey) {
				recentEmergency = dataSnapshot.getValue(Emergency.class);
				System.out.println("added emergency: " + recentEmergency);
			}
		  
			@Override
			public void onChildChanged(DataSnapshot dataSnapshot, String prevChildKey) {
				System.out.println("emergnecy updated: ");
			}
		  
			@Override
			public void onChildRemoved(DataSnapshot dataSnapshot) {
				System.out.println("emergency removed: ");
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

	public void pressRedButton(){
		CompleteDisaster completeDisaster = CompleteDisaster.builder()
			.withFirebaseDatabase(database)
			.build();
		completeDisaster.completeDisaster(database);
	}

}
