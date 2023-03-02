package com.example.restservice.security.models;

import java.io.Serializable;

import lombok.Data;

@Data
public class User implements Serializable {

	private static final long serialVersionUID = 4408418647685225829L;
	private String uid;
	private String name;
	private String email;

}