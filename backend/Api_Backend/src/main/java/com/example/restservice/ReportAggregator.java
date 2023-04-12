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
                //System.out.println(dataSnapshot.toString());
                DatabaseReference ref = dataSnapshot.getRef();
                DataSnapshot dataSnapshotChild = dataSnapshot.child("Reports");
                List<Map<String, Object>> dataList = getMapFromSnapshot(dataSnapshotChild);
                System.out.print(dataList);
				aggregate(dataSnapshotChild, ref, dataList , dataSnapshot);
				//System.out.println(recentEmergency);

			}

            @Override
			public void onChildChanged(DataSnapshot dataSnapshot, String prevChildKey) {
				System.out.println("aggregator:changed");
                System.out.println(dataSnapshot.toString());
                DatabaseReference ref = dataSnapshot.getRef();
                DataSnapshot dataSnapshotChild = dataSnapshot.child("Reports");
                List<Map<String, Object>> dataList = getMapFromSnapshot(dataSnapshotChild);

				aggregate(dataSnapshotChild, ref, dataList, dataSnapshot);
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

    private List<Map<String, Object>> getMapFromSnapshot(DataSnapshot dataSnapshot){
        List<Map<String, Object>> reportList = new ArrayList<>();
        for (DataSnapshot child: dataSnapshot.getChildren() ){
            Map <String, Object> map = (Map) child.getValue();
            map = mapReplace(map);
            reportList.add(map);
        }
        
        return reportList;
    }

    private Map <String, Object> mapReplace(Map<String, Object> map){
        // System.out.println(map.get("Injured"));
        boolean injured = Boolean.parseBoolean((String) map.get("Injured"));
        map.replace("Injured", injured);

        Double lat = Double.parseDouble((String) map.get("Lat"));
        Double lon = Double.parseDouble((String) map.get("Lon"));
        map.replace("Lat", lat);
        map.replace("Lon", lon);
        // System.out.println("Map: " + map);
        map.replace("ReportCategory", Integer.parseInt((String) map.get("ReportCategory")));
        map.replace("Time", Long.parseLong((String) map.get("Time")));
        return map;
    }

    protected  void aggregate(DataSnapshot dataSnapshot, DatabaseReference reference, List<Map<String, Object>> dataList , DataSnapshot parentSnapShot){
        
        long reportCount  = dataSnapshot.getChildrenCount();
        if (reportCount > 1l){
            System.out.println("removing unrelated reports from aggregation");
            dataList =  removeUnrelatedPoints(dataList, dataSnapshot, parentSnapShot);
        }
        Double meanLatLon = absoluteLat(dataList);
        int knownInjury = aggregateKnownInjury(dataList);
        int incidentType = aggregateIncidentType(dataList);
        
        ArrayList <Point> hull = aggregateHull(dataList);
        Double area = aggregateArea(hull);
        long population = aggregatePopulation(area);
        long firstReported = getFirstReported(dataList);
        long lastReported = getLastReported(dataList);
        String neighbourhood = getNeighbourhood(dataList);

        // System.out.println("hull: " + hull.toString());
        for (Point p : hull) {
            System.out.println("(" + p.lat + ", " + p.lon + ")");
        }
        // System.out.println("emergencyCat: " + incidentType);
        // System.out.println("known injury: " + knownInjury);
        // System.out.println("pop: " + population);
        // System.out.println("area: " + area);
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
        aggregateValueMap.put("Location", neighbourhood);
        aggregateValueMap.put("AbsoluteLatLon", meanLatLon);
        setAggregatedValues(dataSnapshot, reference, aggregateValueMap);
    }

    private List<Map<String, Object>> removeUnrelatedPoints(List<Map<String, Object>> dataList, DataSnapshot dataSnapshot,DataSnapshot dataSnapshotParent){
        List<Map<String, Object>> finalList = new ArrayList<>();
        Map <String,Object> map = (Map) dataSnapshotParent.getValue();
        Double absLat = (Double) map.get("AbsoluteLatLon");
        if (absLat == null) return dataList;

        for (Map<String, Object> child: dataList){
            Double lat = (Double) child.get("Lat");
            Double lon = (Double) child.get("Lon");
            System.out.println("abs " + absLat + " lat " + lat + " lon " + lon);
            Double dist = Math.abs(absLat - (lat + lon));
            System.out.print(dist);
            if ( dist < .01d){ //111km in 1 abs latlon theoretically so roughly 7km
                	finalList.add(child);
            }
        }

        return finalList;
    }

    protected int aggregateKnownInjury(List<Map<String, Object>> dataList){
        // take max over all the injuries 
        int count = 0;
        for (Map<String, Object> child: dataList){
            Map <String, Object> map =  child;
            boolean injured = (boolean) map.get("Injured");
            if (injured){
                count++;
            }
        }
        return count;
    }

    protected int aggregateIncidentType(List<Map<String, Object>> dataList){
        // take mode over all report values 
        int count[] = new int [4];
        for (Map<String, Object> child: dataList ){
            Map <String, Object> map = child;
            int emergency = (int) map.get("ReportCategory");
            
            count[emergency]  = count[emergency] + 1;
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
    protected Double absoluteLat(List<Map<String, Object>> dataList){
    //take all lat long of the reports
        //run convext hull to get list of vertices of bounding polygon of points
        //run shoelace formula with these vertice to get area 
        Double absLat = 0d;
        int count = 0;

        for (Map<String, Object> child: dataList){
            Map <String, Object> map = child;
            Double lat = (Double) map.get("Lat");
            Double lon = (Double) map.get("Lon");
            absLat += Math.abs(lat + lon);
            count++;
        }
        
        return (absLat / count);
    }

    protected ArrayList <Point> aggregateHull(List<Map<String, Object>> dataList){
        //take all lat long of the reports
        //run convext hull to get list of vertices of bounding polygon of points
        //run shoelace formula with these vertice to get area 
        List <Point> pointList = new ArrayList<>();

        for (Map<String, Object> child: dataList){
            Map <String, Object> map = child;
            Double lat = (Double) map.get("Lat");
            Double lon = (Double) map.get("Lon");
            pointList.add(new Point(lat, lon));
        }
        Point[] array = new Point[pointList.size()];
        pointList.toArray(array); // fill the array
        
        ConvexHull convHull = new ConvexHull();
        return convHull.convexHull(array);
    }

    protected Double aggregateArea(ArrayList<Point> hull){
        return Shoelace.calculateArea(hull);
    }

    protected long aggregatePopulation(Double area){
        //https://www.cso.ie/en/releasesandpublications/ep/p-rsdgi/regionalsdgsireland2017/nt/ 
        int popDensity = 1468;
        Double population = popDensity * area;
        return (long) Math.round(population);
    }

    protected long getFirstReported(List<Map<String, Object>> dataList){
        long min = Integer.MAX_VALUE;
        for (Map<String, Object> child: dataList){
            Map <String, Object> map = child;
            long time = (long) map.get("Time");
            if (time < min)
                min = time;
        }
        return min;
    }

    protected long getLastReported(List<Map<String, Object>> dataList){
        long max = 0;
        for (Map<String, Object> child: dataList){
            Map <String, Object> map = child;
            long time = (long) map.get("Time");
            if (time > max)
                max = time;
        }
        return max;
    }

    protected void setAggregatedValues(DataSnapshot dataSnapshot, DatabaseReference reference,
     Map<String, Object> aggregateValueMap){
        System.out.println("aggregating");
        System.out.println(aggregateValueMap);
        reference.updateChildrenAsync(aggregateValueMap);
    }

    protected String getNeighbourhood(List<Map<String, Object>> dataList){
        //take all lat long of the reports
        //Find neighbourhood where disaster takes place
        //It will be rough lines
        double latTotal = 0;
        double lonTotal = 0;
        int count = 0;

        for (Map<String, Object> child: dataList){
            Map <String, Object> map = child;
            Double lat = (Double) map.get("Lat");
            Double lon = (Double) map.get("Lon");
            latTotal += lat;
            lonTotal += lon;
            count++;
        }
        double latAverage = latTotal / count;
        double lonAverage = lonTotal / count;
        
        //53.303305,-6.301769  anything south / east is in DL council 
        // anything west and south is SD county council
        //53.400305,-6.347576 anything else that is south east is in Dublin city 
        // anything else is in fingal cc
        String neighbourhood = "";
        if ((latAverage < 53.303305) && (lonAverage > -6.301769)){
            neighbourhood = "DLR";
        }
        else if ((lonAverage < -6.301769)){
            neighbourhood = "DS";
        }
        else if ((latAverage) < 53.400305 && (lonAverage > -6.347576)){
            neighbourhood = "DC";
        }
        else {
            neighbourhood = "FN";
        }

        return neighbourhood;
    }
    
}
