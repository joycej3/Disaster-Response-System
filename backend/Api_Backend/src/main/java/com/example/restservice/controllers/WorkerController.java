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
	private DecisionModel decisionModel;

	@Autowired
	public WorkerController(Database database, DecisionModel decisionModel) throws java.io.FileNotFoundException, java.io.IOException {
		this.database = database;
		this.decisionModel = decisionModel;
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
	public Map getSuggestion(@RequestParam String id) {
		System.out.println("Requested decision for disaster: " + id);
		if(database.disasterIdToOngoingDisasterModel.containsKey(id)){
			System.out.println("Ongoing disaster");
			HashMap<String, Double> stuff = database.disasterIdToOngoingDisasterModel.get(id);
			stuff.keySet().forEach(key -> {
				Object obj = stuff.get(key);
				System.out.println(key + ": " + obj);
			});
			Map<String,Integer> suggestions = decisionModel.getSuggestions(database.disasterIdToOngoingDisasterModel.get(id));
			System.out.println("Got suggestion from model");
			suggestions.keySet().forEach(key -> {
				Object obj = suggestions.get(key);
				System.out.println(key + ": " + obj);
			});
			suggestions.put("ready", 1);
			return suggestions;
		}
		else{
			return Map.of("ready", 0);
		}
	}

}