package com.example.restservice.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.restservice.security.SecurityService;

@RestController
@RequestMapping("worker")
public class WorkerController {

	@Autowired
	private SecurityService securityService;

	@GetMapping("data")
	public String getProtectedData() {
		System.out.println("controller: worker");
		String name = securityService.getUser().getName();
		return name.split("\\s+")[0] + ", you have accessed protected data from spring boot";
	}

}



