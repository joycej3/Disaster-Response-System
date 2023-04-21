package com.example.restservice.controllers;

import java.util.HashMap;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.restservice.ReportClassifier;
import com.example.restservice.ReportsToModel;


@RestController
public class CoordinatorController {
    @GetMapping("/modelSuggestions")
    public Map<String, Double> getModelSuggestions() {
        Integer disasterID = ReportClassifier.recentDisasterID;
        Map<String,Double> modelInputs = ReportsToModel.aggregatedReportsToModel(disasterID);
        //TODO make model predidctions on model inputs and return hashmap 
        Map<String,Double> modelSuggestions = new HashMap<>();
        return modelSuggestions;
    }
}
