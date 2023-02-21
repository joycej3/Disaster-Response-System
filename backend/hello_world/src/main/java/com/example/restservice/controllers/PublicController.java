package com.example.restservice.controllers;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("public")
public class PublicController {

	@GetMapping("/")
	public String getPublicData() {
		System.out.println("controller: public");
		return "You have accessed public data from spring boot";
	}

}