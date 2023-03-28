package com.example.restservice;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyMap;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import com.example.restservice.ConvexHull.Point;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;

@ExtendWith(MockitoExtension.class)
public class ReportAggregatorTests{
    @Mock
    DatabaseReference databaseReference;

    @Mock
    DataSnapshot dataSnapshot;

    @Mock 
    Iterable<DataSnapshot> children;

    @Mock
    FirebaseDatabase firebaseDatabase;

    ReportAggregator reportAggregator;

    @BeforeEach
	public void setUp() { 
        reportAggregator = ReportAggregator.builder()
        .withFirebaseDatabase(firebaseDatabase)
        .build();       
	
	}
    
    @Test
    public void aggregateKnownInjuryTest(){
        //GIVEN
        int injuredCount = 1;
        
        List<Map<String, Object>> dataList = makeDataList();

        //WHEN
        int retInjuredCount = reportAggregator.aggregateKnownInjury(dataList);

        //THEN
        assertEquals(injuredCount, retInjuredCount);

    }

    @Test
    public void aggregateIncidentTypeTest(){
        //GIVEN
        int incidentType = 0;
        
        List<Map<String, Object>> dataList = makeDataList();

        //WHEN
        int retIncidentType = reportAggregator.aggregateIncidentType(dataList);

        //THEN
        assertEquals(incidentType, retIncidentType);

    }

    @Test
    public void aggregateHullTest(){
        //GIVEN
        int incidentType = 0;
        Point[] points = { new Point( 53.288120,-6.181006), new Point(53.281141,-6.216049)};
        ConvexHull convexHull = new ConvexHull();
        ArrayList<Point> hull = convexHull.convexHull(points);
        List<Map<String, Object>> dataList = makeDataList();

        //WHEN
        ArrayList<Point> retHull = reportAggregator.aggregateHull(dataList);

        //THEN
        assertEquals(hull.get(0).lat, retHull.get(0).lat);
        assertEquals(hull.get(0).lon, retHull.get(0).lon);
        assertEquals(hull.get(1).lat, retHull.get(1).lat);
        assertEquals(hull.get(1).lon, retHull.get(1).lon);
    }

    @Test
    public void aggregatePopulationTest(){
        //GIVEN
        Double area = 10d;
        Long expectedPop = Math.round(area * 1468);

        //WHEN
        Long retPop = reportAggregator.aggregatePopulation(area);

        //THEN
        assertEquals(expectedPop, retPop);

    }

    @Test
    public void getFirstReportedTest(){
        //GIVEN
        List<Map<String, Object>> dataList = makeDataList();
        Long expectedTime = 1679404086l;

        //WHEN
        Long retTime = reportAggregator.getLastReported(dataList);

        //THEN
        assertEquals(expectedTime, retTime);

    }

    @Test
    public void getLastReportedTest(){
        //GIVEN
        List<Map<String, Object>> dataList = makeDataList();
        Long expectedTime = 1679404086l;

        //WHEN
        Long retTime = reportAggregator.getLastReported(dataList);

        //THEN
        assertEquals(expectedTime, retTime);

    }


    @Test
    public void setAggregatedValuesTest(){

        //GIVEN

        //WHEN
        when(databaseReference.updateChildrenAsync(any())).thenReturn(any());
        reportAggregator.setAggregatedValues(dataSnapshot, databaseReference, null);

        //THEN
        verify(databaseReference).updateChildrenAsync(any());
    }

    @Test
    public void getNeighbourHoodTest(){
        //GIVEN
        List<Map<String, Object>> dataList = makeDataList();
        String expectedNeighbourhood = "DLR";

        //WHEN
        String retNeighbourhood = reportAggregator.getNeighbourhood(dataList);

        //THEN
        assertEquals(expectedNeighbourhood, retNeighbourhood);
    }

    
    private List<Map<String, Object>> makeDataList(){
        List<Map<String, Object>> dataList = new ArrayList<>();
        Map<String, Object> map = new HashMap();
        map.put("Injured", true);
        map.put("ReportCategory", 0);
        map.put("Lat", 53.288120);
        map.put("Lon", -6.181006);
        map.put("Time", 1679404067l);

        Map<String, Object> map2 = new HashMap();
        map2.put("Injured", false);
        map2.put("ReportCategory", 0);
        map2.put("Lat", 53.281141);
        map2.put("Lon", -6.216049);
        map2.put("Time", 1679404086l);

        dataList.add(map);
        dataList.add(map2);

        return dataList;
    }
}