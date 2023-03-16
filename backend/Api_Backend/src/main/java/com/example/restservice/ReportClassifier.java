package com.example.restservice;

 public class ReportClassifier {
    //keeps track of most recent disasterID
    public int recentDisasterID;

    // takes in an unclassified EmergencyRecord object
    public static void classifyReport(Record EmergencyRecord){

        //Look if current disaster by calling most recent report in Ongoing category 
        //if report exists in ongoing category,get its ID 
        // and add this uncategorized report under that disasterID

        //If no match, create new disasterID with recentDisasterID+1
        //and add report under that ID in Ongoing category

        
    }
    
}
