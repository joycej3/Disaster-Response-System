package com.example.restservice.security.models;

import java.io.Serializable;

import lombok.Data;

@Data
public class User implements Serializable {

	private String uid;
	private String name;
	private String email;

}