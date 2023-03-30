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

    public static void main(String[] args) {

    }

    public static void setModels() {
        try {
            ambo_model = Model.fromFile("Api_Backend/src/main/java/com/example/restservice/regression_model_ambos.pmml");
        } catch (Exception e) {
            ambo_model = Model.fromFile("src/main/java/com/example/restservice/regression_model_ambos.pmml");
        }

        try {
            fire_workers_model = Model.fromFile("Api_Backend/src/main/java/com/example/restservice/regression_model_fire_workers.pmml");
        } catch (Exception e) {
            fire_workers_model = Model.fromFile("src/main/java/com/example/restservice/regression_model_fire_workers.pmml");
        }

        try {
            medics_model = Model.fromFile("Api_Backend/src/main/java/com/example/restservice/regression_model_medics.pmml");
        } catch (Exception e) {
            medics_model = Model.fromFile("src/main/java/com/example/restservice/regression_model_medics.pmml");
        }

        try {
            traffic_police_model = Model.fromFile("Api_Backend/src/main/java/com/example/restservice/regression_model_traffic_police.pmml");
        } catch (Exception e) {
            traffic_police_model = Model.fromFile("src/main/java/com/example/restservice/regression_model_traffic_police.pmml");
        }

        try {
            fire_engine_model = Model.fromFile("Api_Backend/src/main/java/com/example/restservice/regression_model_fire_engine.pmml");
        } catch (Exception e) {
            fire_engine_model = Model.fromFile("src/main/java/com/example/restservice/regression_model_fire_engine.pmml");
        }

    }

    public Map<String, Integer> getSuggestions(Map<String, Double> values) {
        setModels();
        System.out.println(ambo_model.isClassification());
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