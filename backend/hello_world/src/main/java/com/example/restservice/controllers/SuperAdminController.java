package com.example.restservice.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.UserRecord;

import com.example.restservice.security.SecurityService;
import com.example.restservice.security.roles.IsSuper;
import com.example.restservice.security.roles.RoleService;

@RestController
@RequestMapping("super")
public class SuperAdminController {

	@Autowired
	RoleService securityRoleService;

	@Autowired
	private SecurityService securityService;

	@Autowired
	FirebaseAuth firebaseAuth;

	@GetMapping("user")
	@IsSuper
	public UserRecord getUser(@RequestParam String email) throws Exception {
		return firebaseAuth.getUserByEmail(email);
	}
	
	@GetMapping("data")
	@IsSuper
	public String getSuperData() {
		System.out.println("controller: super admin");
		String name = securityService.getUser().getName();
		return name.split("\\s+")[0] + ", you have accessed super data from spring boot";
	}

}