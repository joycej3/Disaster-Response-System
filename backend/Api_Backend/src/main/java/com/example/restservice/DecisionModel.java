package com.example.restservice;

import org.pmml4s.model.Model;

import java.io.File;
import java.net.URL;
import java.util.*;

public class DecisionModel {

    private static Model ambo_model;
    private static Model fire_engine_model;
    private static Model fire_workers_model;
    private static Model medics_model;
    private static Model traffic_police_model;

    public static void main(String[] args){   
       
    }

    public static void setModels(){
        URL amboPath = DecisionModel.class.getResource("regression_model_ambos.pmml");
        if(amboPath==null) {
            System.out.println("Issue Finding Ambulance Model");
        }else{
            File f = new File(amboPath.getFile());
            ambo_model = Model.fromFile(f);  
        }

        URL pfPath = DecisionModel.class.getResource("regression_model_fire_workers.pmml");
        if(pfPath==null) {
            System.out.println("Issue Finding Fire Workers Model");
        }else{
            File f = new File(pfPath.getFile());
            fire_workers_model = Model.fromFile(f);  
        }

        URL mPath = DecisionModel.class.getResource("regression_model_medics.pmml");
        if(mPath==null) {
            System.out.println("Issue Finding Medics Model");
        }else{
            File f = new File(mPath.getFile());
            medics_model = Model.fromFile(f);  
        }

        URL tpPath = DecisionModel.class.getResource("regression_model_traffic_police.pmml");
        if(tpPath==null) {
            System.out.println("Issue Finding Traffic Police Model");
        }else{
            File f = new File(tpPath.getFile());
            traffic_police_model = Model.fromFile(f);  
        }

        URL fePath = DecisionModel.class.getResource("regression_model_fire_engine.pmml");
        if(fePath==null) {
            System.out.println("Issue Finding Ambulance Model");
        }else{
            File f = new File(fePath.getFile());
            fire_engine_model = Model.fromFile(f);  
        }
        
    }

    public Map<String, Integer> getSuggestions(Map<String, Double> values) {
        setModels();
        Object[] valuesMap = Arrays.stream(ambo_model.inputNames())
                .map(values::get)
                .toArray();

        Object[] ambo_result = ambo_model.predict(valuesMap);
        Object[] fe_result = fire_engine_model.predict(valuesMap);
        Object[] fw_result = fire_workers_model.predict(valuesMap);
        Object[] medic_result = medics_model.predict(valuesMap);
        Object[] tp_result = traffic_police_model.predict(valuesMap);

        Double ambo_d = (Double) ambo_result[0];
        Double fe_d = (Double) fe_result[0];
        Double fw_d = (Double) fw_result[0];
        Double medic_d = (Double) medic_result[0];
        Double tp_d = (Double) tp_result[0];

        Map<String, Integer> suggestions = new HashMap<>();
        suggestions.put("Ambulances", ambo_d.intValue());
        suggestions.put("Paramedics", medic_d.intValue());
        suggestions.put("Fire Trucks", fe_d.intValue());
        suggestions.put("Police", tp_d.intValue());
        suggestions.put("Fire-Fighters", fw_d.intValue());

        return suggestions;
    }
}