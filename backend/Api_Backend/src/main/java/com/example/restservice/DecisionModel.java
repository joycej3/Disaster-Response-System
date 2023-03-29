package com.example.restservice;

import org.pmml4s.model.Model;
import java.util.*;

public class DecisionModel {

    private final static Model ambo_model = Model.fromFile("Api_Backend/src/main/java/com/example/restservice/regression_model_ambos.pmml");
    private final static Model fire_engine_model = Model.fromFile("Api_Backend/src/main/java/com/example/restservice/regression_model_fire_engine.pmml");
    private final static Model fire_workers_model = Model.fromFile("Api_Backend/src/main/java/com/example/restservice/regression_model_fire_workers.pmml");
    private final static Model medics_model = Model.fromFile("Api_Backend/src/main/java/com/example/restservice/regression_model_medics.pmml");
    private final static Model traffic_police_model = Model.fromFile("Api_Backend/src/main/java/com/example/restservice/regression_model_traffic_police.pmml");
    public static void main(String[] args){    
        test();
    }

    public static Map<String, Integer> getSuggestions(Map<String, Double> values) {
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

    public static void test() {
        Map<String, Double> values = new HashMap<>();
        values.put("known_injury", 0d);
        values.put("incident_type_code", 1d);
        values.put("area_size", 100d);
        values.put("first_report", 200d);
        values.put("location_Dn Laoghaire-Rathdown", 1d);
        values.put("location_Dublin City", 0d);
        values.put("location_Fingal", 0d);
        values.put("location_South Dublin", 0d);
        values.put("weather_cloudy", 0d);
        values.put("weather_fog", 1d);
        values.put("weather_rain", 0d);
        values.put("weather_sunshine", 0d);

        Map<String, Integer> predicted = getSuggestions(values);
        System.out.println(predicted);
    }
}