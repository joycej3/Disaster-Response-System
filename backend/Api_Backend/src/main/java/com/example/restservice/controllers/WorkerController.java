package com.example.restservice.controllers;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.restservice.Database;
import com.example.restservice.DecisionModel;
import com.example.restservice.security.roles.IsWorker;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("worker")
public class WorkerController {

	private Database database;

	@Autowired
	public WorkerController(Database database) throws java.io.FileNotFoundException, java.io.IOException {
		this.database = database;
	}
	
	
	@GetMapping("data")
	@IsWorker
	public HashMap getProtectedData() {
		System.out.println("controller: Worker");
		HashMap<String, String> returnValue = new HashMap<>();
		returnValue.put("value", "You have accessed Worker only data from spring boot");
		return returnValue;
	}

	@GetMapping(path = "get_suggestion", 
	produces = MediaType.APPLICATION_JSON_VALUE)
	@IsWorker
	public  Map<String, Integer> getSuggestion(@RequestParam String id) {
		HashMap<String, Double> aggregatedDisasterFields = database.disasterIdToOngoingDisasterModel.get(id);
		//the required data is in database.disasterIdToOngoingDisasterModel.get(id);
		DecisionModel mlModel = new DecisionModel();
        Map<String, Integer> modelSuggestions = mlModel.getSuggestions(aggregatedDisasterFields);
		return modelSuggestions;
	}

	@GetMapping(path = "get_aggregates", 
	produces = MediaType.APPLICATION_JSON_VALUE)
	@IsWorker
	public  Map<String, Integer> getAggregates(@RequestParam String id) {
		HashMap<String, Double> aggregatedDisasterFields = database.disasterIdToOngoingDisasterModel.get(id);
		return modelSuggestions;
	}

}