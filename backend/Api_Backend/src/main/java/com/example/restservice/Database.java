package com.example.restservice;

import java.util.HashMap;

import com.google.firebase.database.ChildEventListener;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;

public class Database {
    private FirebaseDatabase database;
    private String suggestionRefPath = "something/suggestions";
    private String ongoingDisastersRefPath = "DisasterDIR/Ongoing";
    private String decisionsRefPath = "Decisions";
    private String userRefPath = "users";
    public HashMap<String, Disaster> disasterIdToOngoingDisaster = new HashMap();
    public HashMap<String, Decision> disasterIdToSuggestion = new HashMap();
    public HashMap<String, Decision> disasterIdToDecision = new HashMap();
    public HashMap<String, User> emailToUserInfo = new HashMap();
    public DatabaseReference suggestionRef;
    public DatabaseReference ongoingDisasterRef;
    public DatabaseReference decisionsRef;
    public DatabaseReference userRef;

    public Database(){

    }

    public Database(FirebaseDatabase getDatabase){
        this.database = getDatabase;
        setupListeners();
    }

    private void setupListeners(){
        setupSuggestionListener();
        setupOngoingDisasterListener();
        setupDecisionsListener();
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
				Disaster disaster = dataSnapshot.getValue(Disaster.class);
                String key = dataSnapshot.getKey();
				disasterIdToOngoingDisaster.put(key, disaster);
				System.out.println("added ongoing disaster: " + key);
			}
		  
			@Override
			public void onChildChanged(DataSnapshot dataSnapshot, String prevChildKey) {
				Disaster disaster = dataSnapshot.getValue(Disaster.class);
                String key = dataSnapshot.getKey();
				disasterIdToOngoingDisaster.put(key, disaster);
				System.out.println("updated ongoing disaster: " + disaster);
			}
		  
			@Override
			public void onChildRemoved(DataSnapshot dataSnapshot) {
                String key = dataSnapshot.getKey();
				disasterIdToOngoingDisaster.remove(key);
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

}
