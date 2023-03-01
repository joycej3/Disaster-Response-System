package com.example.restservice.security;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;

import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;

import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.AuthenticationException;

import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import com.fasterxml.jackson.databind.ObjectMapper;

import com.example.restservice.security.models.SecurityProperties;

@Configuration
@EnableWebSecurity
public class SecurityConfig{

	@Autowired
	private ObjectMapper objectMapper;

	@Autowired
	private SecurityProperties restSecProps;

	@Autowired
	private SecurityFilter tokenAuthenticationFilter;

	
	@Bean
	public AuthenticationEntryPoint restAuthenticationEntryPoint() {
		return new AuthenticationEntryPoint() {
			@Override
			public void commence(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse,
					AuthenticationException e) throws IOException, ServletException {
				Map<String, Object> errorObject = new HashMap<String, Object>();
				int errorCode = 401;
				errorObject.put("message", "Unauthorized access of protected resource, invalid credentials");
				errorObject.put("error", HttpStatus.UNAUTHORIZED);
				errorObject.put("code", errorCode);
				errorObject.put("timestamp", new Timestamp(new Date().getTime()));
				httpServletResponse.setContentType("application/json;charset=UTF-8");
				httpServletResponse.setStatus(errorCode);
				httpServletResponse.getWriter().write(objectMapper.writeValueAsString(errorObject));
			}
		};
	}

	@Bean
	CorsConfigurationSource corsConfigurationSource() {
		System.out.println("Initialising cors config");
		CorsConfiguration configuration = new CorsConfiguration();
		configuration.setAllowedOrigins(restSecProps.getAllowedOrigins());
		configuration.setAllowedMethods(restSecProps.getAllowedMethods());
		configuration.setAllowedHeaders(restSecProps.getAllowedHeaders());
		configuration.setAllowCredentials(restSecProps.isAllowCredentials());
		configuration.setExposedHeaders(restSecProps.getExposedHeaders());
		UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
		source.registerCorsConfiguration("/**", configuration);
		return source;
	}

	@Bean
	public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
		System.out.println("filterchain");
		http.cors().configurationSource(corsConfigurationSource()).and().csrf().disable().formLogin().disable()
				.httpBasic().disable().exceptionHandling().authenticationEntryPoint(restAuthenticationEntryPoint())
				.and().authorizeHttpRequests()
				.requestMatchers(restSecProps.getAllowedPublicApis().stream().toArray(String[]::new)).permitAll()
				.requestMatchers(HttpMethod.OPTIONS, "/**").permitAll().anyRequest().authenticated().and()
				.addFilterBefore(tokenAuthenticationFilter, UsernamePasswordAuthenticationFilter.class)
				.sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS);
		return http.build();
	}


}