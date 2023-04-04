package com.example.restservice;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.lang.Math;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.util.EntityUtils;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.ObjectWriter;
import com.google.gson.JsonObject; 

 public class ReportClassifier {
    //keeps track of most recent disasterID
    public static Integer recentDisasterID = 0;
    final static String disasterField = "DisasterID";
    final static String dbURL = "https://group-9-c4e02-default-rtdb.europe-west1.firebasedatabase.app/ReportTable/Categorised/Ongoing";
    
    //checks if current ongoing disasterID
    //if no ongoing disaster creates a new disasterID 
    //adds report under disasterID 
    public boolean classifyReport(EmergencyRecord record) throws IOException{


        int currentDisasterID = getDisasterID();
        if (currentDisasterID > 0){
            recentDisasterID = currentDisasterID;
        } else {
            recentDisasterID +=1;
        }
        return addtoDisasterReports(record);
    }

    public String injuryToBool(String injury){
        if (injury.toLowerCase().contains("not")){
            return "false";
        }
        else {
            return "true";
        }
    }

    public String categoryToNumber(String emergency){
        if (emergency.toLowerCase().contains("fire")){
            return "0";
        }
        else if (emergency.toLowerCase().contains("flood") || emergency.toLowerCase().contains("quake") 
        || emergency.toLowerCase().contains("natural") ){
            return "1";
        }
        else if (emergency.toLowerCase().contains("traffic")){
            return "2";
        }
        else {
            return "3";
        }
    }
    
    //posts a report under a disasterID
    private static boolean addtoDisasterReports(EmergencyRecord record) throws IOException{
        HttpClient client = HttpClientBuilder.create().build();
        HttpPost post = new HttpPost(dbURL + "/" + recentDisasterID.toString() + "/Reports.json");

        Map data_map =  Map.of(
            "Injured", record.injury(),
            "Lat", record.lat(),
            "Lon", record.lon(),
            "ReportCategory", record.reportCategory(),
            "Time", record.time()
        );

        ObjectMapper mapper = new ObjectMapper();
        StringEntity entity = new StringEntity(mapper.writeValueAsString(data_map));
        post.setEntity(entity);
        HttpResponse response = client.execute(post);
        int statusCode = response.getStatusLine().getStatusCode();
        if (statusCode == 200 || statusCode == 201) {
            // the post was successful
            String responseBody = EntityUtils.toString(response.getEntity());
            JsonNode responseJson = mapper.readTree(responseBody);
            System.out.println("Post successful. Response from server: " + responseJson.toString());
            return true;
        } else {
            // the post failed
            System.out.println("Post failed with status code: " + statusCode);
            return false;
        }
        
    }

    // returns disasterID if ongoing disaster, otherwise -1
    private static int getDisasterID() throws IOException{
        int disasterID = 1;
        try {
            URL url = new URL(dbURL + ".json?print=pretty");
            ObjectMapper mapper = new ObjectMapper();
            JsonNode rootNode = mapper.readTree(url);
            
            for (JsonNode node : rootNode) {
                System.out.println(node.toString());
                if (node.get(disasterField) != null) {
                    disasterID = Integer.parseInt(node.get(disasterField).toString()) ;
                    break;
                }
            }
        } catch (MalformedURLException e) {
            e.printStackTrace();
        }  
        return disasterID;
    }

    public static void main(String[] args) throws IOException {
        EmergencyRecord record = new EmergencyRecord("Drought", "true", "103945", "85.55", "35.33","1");
    }
}
