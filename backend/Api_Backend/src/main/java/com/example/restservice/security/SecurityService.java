package com.example.restservice.security;

import jakarta.servlet.http.HttpServletRequest;

import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import com.example.restservice.security.models.Credentials;
import com.example.restservice.security.models.User;

@Service
public class SecurityService {

	public User getUser() {
		System.out.println("get user");
		User userPrincipal = null;
		SecurityContext securityContext = SecurityContextHolder.getContext();
		Object principal = securityContext.getAuthentication().getPrincipal();
		if (principal instanceof User) {
			userPrincipal = ((User) principal);
		}
		return userPrincipal;
	}

	public Credentials getCredentials() {
		System.out.println("get cred");
		SecurityContext securityContext = SecurityContextHolder.getContext();
		return (Credentials) securityContext.getAuthentication().getCredentials();
	}

	public String getBearerToken(HttpServletRequest request) {
		String bearerToken = null;
		String authorization = request.getHeader("Authorization");
		if (StringUtils.hasText(authorization) && authorization.startsWith("Bearer ")) {
			bearerToken = authorization.substring(7, authorization.length());
		}
		return bearerToken;
	}

}