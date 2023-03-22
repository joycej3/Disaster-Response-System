package com.example.restservice.controllers;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.restservice.Main;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("public")
public class PublicController extends Main {

	@GetMapping("data")
	public String getPublicData() {
		System.out.println("controller: public");
		return "You have accessed public data from spring boot";
	}

}