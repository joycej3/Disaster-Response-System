package com.example.restservice;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.util.HashMap;
import java.util.Map;

import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;

import scala.collection.generic.BitOperations.Int;


public class DecisionModelTest{
    @Test
    public void getSuggestionsTest(){
        //GIVEN
        DecisionModel model = new DecisionModel();

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

        Map<String, Integer> shouldPredict = new HashMap<>();
        shouldPredict.put("ambulances", 2);
        shouldPredict.put("paramedics", 22);
        shouldPredict.put("fire_engines", 7 );
        shouldPredict.put("police", 32);
        shouldPredict.put("fire_fighters", 44);

        //WHEN
        Map<String, Integer> predicted = model.getSuggestions(values);

        //THEN
        assertEquals(shouldPredict, predicted);

    }
}

