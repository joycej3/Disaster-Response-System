package com.example.restservice;

import java.util.ArrayList;
import java.util.Dictionary;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.example.restservice.ConvexHull.Point;
import com.google.firebase.database.ChildEventListener;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.gson.Gson;

import jakarta.persistence.criteria.CriteriaBuilder.Case;
import lombok.Builder;
import lombok.Getter;



@Getter
@Builder(setterPrefix = "with")
public class ReportAggregator {
    FirebaseDatabase firebaseDatabase;

    // takes all reports under a disaster ID and aggregates them to pass to ML model
    // maybe create an aggregated report class to pass to ML model
    public  void startAggregatingReports(){
        DatabaseReference disasterRef = firebaseDatabase.getReference("ReportTable/Categorised/Ongoing");
        disasterRef.addChildEventListener(new ChildEventListener() {
			@Override
			public void onChildAdded(DataSnapshot dataSnapshot, String prevChildKey) {
				System.out.println("aggregator:child added");
				System.out.println("prevchildkey: " + prevChildKey);
                System.out.println(dataSnapshot.toString());
                DatabaseReference ref = dataSnapshot.getRef();
                dataSnapshot = dataSnapshot.child("Reports");
                
				aggregate(dataSnapshot, ref);
				//System.out.println(recentEmergency);

			}

            @Override
			public void onChildChanged(DataSnapshot dataSnapshot, String prevChildKey) {
				System.out.println("aggregator:changed");
			}
		  
			@Override
			public void onChildRemoved(DataSnapshot dataSnapshot) {
				System.out.println("aggregator:removed");
			}
		  
			@Override
			public void onChildMoved(DataSnapshot dataSnapshot, String prevChildKey) {
				System.out.println("aggregator:moved");
			}
		  
			@Override
			public void onCancelled(DatabaseError databaseError) {
				System.out.println("aggregator:cancelled");
			}
		  
        });
    }

    private  void aggregate(DataSnapshot dataSnapshot, DatabaseReference reference){
        
        long reportCount  = dataSnapshot.getChildrenCount();
        int knownInjury = aggregateKnownInjury(dataSnapshot);
        int incidentType = aggregateIncidentType(dataSnapshot);
        ArrayList <Point> hull = aggregateHull(dataSnapshot);
        Double area = aggregateArea(hull);
        long population = aggregatePopulation(area);
        long firstReported = getFirstReported(dataSnapshot);
        long lastReported = getLastReported(dataSnapshot);

        System.out.println("hull: " + hull.toString());
        for (Point p : hull) {
            System.out.println("(" + p.lat + ", " + p.lon + ")");
        }
        System.out.println("emergencyCat: " + incidentType);
        System.out.println("known injury: " + knownInjury);
        System.out.println("pop: " + population);
        System.out.println("area: " + area);
        Gson gson = new Gson();
        String jsonHull = gson.toJson(hull);

        Map <String, Object> aggregateValueMap = new HashMap<>();
        aggregateValueMap.put("IncidentType", incidentType);
        aggregateValueMap.put("KnownInjury", knownInjury);
        aggregateValueMap.put("Population", population);
        aggregateValueMap.put("Isochrone", jsonHull);
        aggregateValueMap.put("Area", area);
        aggregateValueMap.put("ReportCount", reportCount);
        aggregateValueMap.put("FirstReported", firstReported);
        aggregateValueMap.put("LastReportTime", lastReported);

        setAggregatedValues(dataSnapshot, reference, aggregateValueMap);

    }

    private int aggregateKnownInjury(DataSnapshot dataSnapshot){
        // take max over all the injuries 
        int count = 0;
        for (DataSnapshot child: dataSnapshot.getChildren() ){
            Map <String, Object> map = (Map) child.getValue();
            boolean injured = (boolean) map.get("Injured");
            if (injured){
                count++;
            }
        }
        return count;
    }

    private int aggregateIncidentType(DataSnapshot dataSnapshot){
        // take mode over all report values 
        int count[] = new int [4];
        for (DataSnapshot child: dataSnapshot.getChildren() ){
            Map <String, Object> map = (Map) child.getValue();
            String emergency = (String) map.get("ReportCategory");
            int number = emergencyCategoryToNum(emergency);
            count[number]  = count[number] + 1;
        }
        int max = 0;
        int mode = 0;
        for (int i = 0; i < 4; i++){
            if (count[i] > max){
                max = count[i];
                mode = i;
            }
        }

        return mode;
    }

    private ArrayList <Point> aggregateHull(DataSnapshot dataSnapshot){
        //take all lat long of the reports
        //run convext hull to get list of vertices of bounding polygon of points
        //run shoelace formula with these vertice to get area 
        List <Point> pointList = new ArrayList<>();

        for (DataSnapshot child: dataSnapshot.getChildren() ){
            Map <String, Object> map = (Map) child.getValue();
            Double lat = (Double) map.get("Lat");
            Double lon = (Double) map.get("Lon");
            pointList.add(new Point(lat, lon));
        }
        Point[] array = new Point[pointList.size()];
        pointList.toArray(array); // fill the array
        
        ConvexHull convHull = new ConvexHull();
        return convHull.convexHull(array);
    }

    private Double aggregateArea(ArrayList<Point> hull){
        return Shoelace.calculateArea(hull);
    }

    private long aggregatePopulation(Double area){
        //https://www.cso.ie/en/releasesandpublications/ep/p-rsdgi/regionalsdgsireland2017/nt/ 
        int popDensity = 1468;
        Double population = popDensity * area;
        return (long) Math.round(population);
    }

    private long getFirstReported(DataSnapshot dataSnapshot){
        long min = Integer.MAX_VALUE;
        for (DataSnapshot child: dataSnapshot.getChildren() ){
            Map <String, Object> map = (Map) child.getValue();
            long time = (long) map.get("Time");
            if (time < min)
                min = time;
        }
        return min;
    }

    private long getLastReported(DataSnapshot dataSnapshot){
        long max = 0;
        for (DataSnapshot child: dataSnapshot.getChildren() ){
            Map <String, Object> map = (Map) child.getValue();
            long time = (long) map.get("Time");
            if (time > max)
                max = time;
        }
        return max;
    }

    private void setAggregatedValues(DataSnapshot dataSnapshot, DatabaseReference reference,
     Map<String, Object> aggregateValueMap){
        System.out.println("aggregating");
        System.out.println(aggregateValueMap);
        reference.updateChildrenAsync(aggregateValueMap);
    }

    private String getNeighbourhood(){
        //take all lat long of the reports
        //Find neighbourhood where disaster takes place
        return "0";
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
