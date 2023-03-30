package com.example.restservice.controllers;

import java.util.HashMap;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
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
	
}