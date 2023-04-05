package com.example.restservice;

import java.util.UUID;

import com.google.firebase.auth.internal.FirebaseCustomAuthToken;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

import lombok.Builder;

@Builder(setterPrefix = "with")
public class CompleteDisaster{
    DatabaseReference databaseReferenceOngoing;
    DatabaseReference databaseReferenceCompleted;
    FirebaseDatabase firebaseDatabase;


    protected void initDatabase(FirebaseDatabase firebaseDatabase){
        databaseReferenceCompleted = firebaseDatabase.getReference("ReportTable/Categorised/Completed");
        databaseReferenceOngoing =  firebaseDatabase.getReference("ReportTable/Categorised/Ongoing");
    }

    public  void completeDisaster(FirebaseDatabase getDatabase){
        firebaseDatabase = getDatabase;
        initDatabase(getDatabase);

        moveNode(databaseReferenceOngoing, databaseReferenceCompleted);
        
    }

    private void moveNode(final DatabaseReference fromPath, final DatabaseReference toPath) {
        fromPath.addListenerForSingleValueEvent(new ValueEventListener() {
            @Override
            public void onDataChange(DataSnapshot dataSnapshot) {
               
                String key = "";
                for (DataSnapshot child: dataSnapshot.getChildren()){
            
                    if (key == "")
                        key = child.getKey();
                }
                key = UUID.randomUUID().toString();
                databaseReferenceCompleted = firebaseDatabase.getReference("ReportTable/Categorised/Completed/"+ key);
                databaseReferenceCompleted.setValue(dataSnapshot.getValue(), new DatabaseReference.CompletionListener() {
                    @Override
                    public void onComplete(DatabaseError firebaseError, DatabaseReference firebase) {
                        if (firebaseError != null) {
                            System.out.println("Copy failed");
                        } else {
                            System.out.println("Success");
                            fromPath.setValue(null , new DatabaseReference.CompletionListener(){
                                @Override
                                public void onComplete(DatabaseError firebaseError, DatabaseReference firebase) {
                                    if (firebaseError != null) {
                                        System.out.println("Copy failed");
                                    } else {
                                        System.out.println("Success");
                                    }
                                }});
                        }
                    }
                });

            }

            @Override
            public void onCancelled(DatabaseError databaseError) {

            }
        });
    }
}