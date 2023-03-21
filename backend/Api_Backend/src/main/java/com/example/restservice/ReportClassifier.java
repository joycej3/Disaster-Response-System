package com.example.restservice;
import java.lang.Math;

 public class ReportClassifier {
    //keeps track of most recent disasterID
    public int recentDisasterID;

    // takes in an unclassified EmergencyRecord object
    public static void classifyReport(Record EmergencyRecord){

        //Look if current disaster by calling most recent report in Ongoing category 
        //if report exists in ongoing category,get its ID 
        // and add this uncategorized report under that disasterID

        // Look at categories to check if new disaster
        boolean typeMatch = disasterTypeMatch(/*EmergencyRecord.DisasterType, RecentEmergency.DisaterType*/);
        boolean locationMatch = disasterLocationMatch(/*EmergencyRecord.lat, EmergencyRecord.lon, RecentEmergency.lat, RecentEmergency.lon*/);
        boolean timeMatch = disasterTimeMatch(/*EmergencyRecord.Time, RecentEmergency.Time*/);

        if(typeMatch && locationMatch && timeMatch){
            // not a new disaster add this report to recentDisaster
        }
        else{
            // new disaster
            // create new disasterID with recentDisasterID+1
            //and add report under that ID in Ongoing category
        }   
    }

    private boolean disasterTypeMatch(int newRecord, int currRecord){
        boolean match = 0;
        if (newRecord == currRecord){
            match = 1;
        };
        return match;
    }

    private boolean disasterLocationMatch(float newRecordLat, float newRecordLon, 
        float currRecordLat, float currRecordLon){
        boolean match = 0;
        if (Math.abs(newRecordLat - currRecordLat)<= 0.02 && Math.abs(newRecordLon - currRecordLon)<= 0.02){
            match = 1;
        };
        return match;
    }

    private boolean disasterTimeMatch(int newRecordTime, int currRecordTime){
        boolean match = 0;
        int day = 86400;
        if (Math.abs(newRecordLat - currRecordLat)<= day){
            match = 1;
        };
        return match;
    }   
}
