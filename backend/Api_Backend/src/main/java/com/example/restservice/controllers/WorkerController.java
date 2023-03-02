package com.example.restservice.controllers;

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
	public String getProtectedData() {
		System.out.println("controller: Worker");
		return "You have accessed Worker only data from spring boot";
	}
	
}