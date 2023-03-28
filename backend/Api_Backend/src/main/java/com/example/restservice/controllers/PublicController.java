package com.example.restservice.controllers;

import java.io.FileNotFoundException;
import java.io.IOException;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.restservice.Main;
import com.google.firebase.database.FirebaseDatabase;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("public")
public class PublicController extends Main {

	public PublicController(FirebaseDatabase getDatabase) throws FileNotFoundException, IOException {
		super(getDatabase);
		//TODO Auto-generated constructor stub
	}

	@GetMapping("data")
	public String getPublicData() {
		System.out.println("controller: public");
		return "You have accessed public data from spring boot";
	}

}