package com.example.restservice.controllers;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.UserRecord;
import com.example.restservice.Database;
import com.example.restservice.Decision;
import com.example.restservice.security.SecurityService;
import com.example.restservice.security.roles.IsSuper;
import com.example.restservice.security.roles.RoleService;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("super")
public class SuperAdminController {

	@Autowired
	RoleService securityRoleService;

	@Autowired
	private SecurityService securityService;

	@Autowired
	FirebaseAuth firebaseAuth;

	private Database database;

	public SuperAdminController(Database database){
		this.database = database;
	}

	

	@GetMapping("user")
	@IsSuper
	public UserRecord getUser(@RequestParam String email) throws Exception {
		return firebaseAuth.getUserByEmail(email);
	}
	
	@GetMapping("data")
	@IsSuper
	public String getAdminData() {
		System.out.println("controller: admin");
		String name = securityService.getUser().getUid();
		return name.split("\\s+")[0] + ", you have accessed admin data from spring boot";
	}

	@GetMapping("get_suggestion")
	@IsSuper
	public Decision getSuggestion(@RequestParam String id){
		return database.disasterIdToSuggestion.getOrDefault(id, null);
	}

	@GetMapping("get_ongoing_disasters")
	@IsSuper
	public HashMap getOngoingDisasters(){
		return database.disasterIdToOngoingDisaster;
	}

	@GetMapping("get_disaster_reports")
	@IsSuper
	public HashMap getDisasterReports(@RequestParam String id){
		return new HashMap<>();
	}

	@PostMapping("post_decision")
	@IsSuper
	public boolean pushDecision(@RequestParam String id, @RequestParam Decision decision){
		database.decisionsRef.child(id).setValueAsync(decision);
		return true;
	}

}