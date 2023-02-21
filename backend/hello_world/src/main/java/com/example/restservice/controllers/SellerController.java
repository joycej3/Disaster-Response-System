package com.example.restservice.controllers;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.restservice.security.roles.IsSeller;

@RestController
@RequestMapping("seller")
public class SellerController {
	
	@GetMapping("data")
	@IsSeller
	public String getProtectedData() {
		System.out.println("controller: Seller");
		return "You have accessed seller only data from spring boot";
	}
	
}