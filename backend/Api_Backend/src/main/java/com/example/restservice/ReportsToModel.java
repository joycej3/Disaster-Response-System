package com.example.restservice;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

public class ReportsToModel {
    final static String dbURL = "https://group-9-c4e02-default-rtdb.europe-west1.firebasedatabase.app/ReportTable/Categorised/Ongoing";

    //returns details of aggregated reports for a given disasterID
    public static Map<String, Double> aggregatedReportsToModel(Integer disasterID){
        Map<String, Double> values = new HashMap<>();
        try {
            URL url = new URL(dbURL + "/" + disasterID.toString() + ".json?print=pretty");
            ObjectMapper mapper = new ObjectMapper();
            JsonNode rootNode = mapper.readTree(url);
            values.put("known_injury", Double.valueOf(rootNode.get("KnownInjury").toString()));
            values.put("incident_type_code", Double.valueOf(rootNode.get("IncidentType").toString()));
            values.put("area_size", Double.valueOf(rootNode.get("Area").toString()));
            values.put("first_report", Double.valueOf(rootNode.get("FirstReported").toString()));
            values.put("location_Dn Laoghaire-Rathdown", 0d);
            values.put("location_Dublin City", 0d);
            values.put("location_Fingal", 0d);
            values.put("location_South Dublin", 0d);
            String neighborhood = rootNode.get("Location").toString();
            if(neighborhood == "FN"){
            values.put("location_Fingal", 1d);
    
            } else if (neighborhood == "DLR"){
            values.put("location_Dn Laoghaire-Rathdown", 1d);

            } else if (neighborhood == "DS") {
            values.put("location_South Dublin", 1d);

            } else if (neighborhood == "DC") {
            values.put("location_Dublin City", 1d);
            }
            values.put("weather_cloudy", 1d);
            values.put("weather_fog", 0d);
            values.put("weather_rain", 0d);
            values.put("weather_sunshine", 0d);

            } catch (IOException e) {
            e.printStackTrace();
        }  
        

        return values;
    }
    public static void main(String[] args) throws IOException {
        System.out.println(aggregatedReportsToModel(2));
    }
}

