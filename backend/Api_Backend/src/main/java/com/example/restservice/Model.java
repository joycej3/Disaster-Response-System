package com.example.restservice;

import org.pmml4s.model.Model;
import org.apache.commons.math3.util.Pair;

import java.io.*;
import java.util.*;
import java.util.stream.IntStream;

public class Model {

    private final Model model = Model.fromFile(Main.class.getClassLoader().getResource("regression_model.pmml").getFile());

    public static void main(String[] args){
      test();
    }

    public Object getRegressionValue(Map<String, Double> values) {
        Object[] valuesMap = Arrays.stream(model.inputNames())
                .map(values::get)
                .toArray();

        Object[] result = model.predict(valuesMap);
        return result;
    }

    public static void test() {
        System.out.println("Test");
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

        double predicted = main.getRegressionValue(values);
        System.out.println(predicted);
    }
}