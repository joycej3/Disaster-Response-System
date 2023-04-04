package com.example.restservice.controllers;

import java.util.HashMap;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.restservice.security.roles.IsWorker;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("worker")
public class WorkerController {
	
	
	@GetMapping("data")
	@IsWorker
	public HashMap getProtectedData() {
		System.out.println("controller: Worker");
		HashMap<String, String> returnValue = new HashMap<>();
		returnValue.put("value", "You have accessed Worker only data from spring boot");
		return returnValue;
	}

	@GetMapping("get_suggestion")
	@IsWorker
	public HashMap getSuggestion(@RequestParam String id) {
		HashMap<String, String> returnValue = new HashMap<>();
		returnValue.put("ambulances", "2");
		returnValue.put("paramedics", "3");
		returnValue.put("fire_engines", "2");
		returnValue.put("police", "22");
		returnValue.put("fire_fighters", "7");
		return returnValue;
	}

}