package com.example.Load;

import java.util.HashMap;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import jakarta.servlet.http.HttpServletRequest;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpResponse.BodyHandlers;


@RestController
@Component
public class Main {

	@GetMapping("/backend/**")
	public HashMap backendGet(@RequestParam Map<String,String> allRequestParams, HttpServletRequest servletRequest) throws IOException, InterruptedException {
		String fullPath = servletRequest.getRequestURI();
		String paramString = allRequestParams.toString().replace("}", "").replace("{","?").replace(", ", "&");

		var client = HttpClient.newHttpClient();
		var request = HttpRequest.newBuilder(
			URI.create("http://backend:8080" + fullPath + paramString))
		.header("accept", "application/json")
		.build();

		var response = client.send(request, BodyHandlers.ofString());
		JsonObject jsonObject = new JsonParser().parse(response.body()).getAsJsonObject();
		System.out.println(jsonObject);
		HashMap hashMap = new Gson().fromJson(jsonObject, HashMap.class);
		System.out.println(hashMap);
		return hashMap;
	}

	@PostMapping("/backend/**")
	public String backendPost(HttpServletRequest servletRequest) throws IOException, InterruptedException {
		String fullPath = servletRequest.getRequestURI();
		String paramJsonString = servletRequest.getReader().lines().collect(Collectors.joining(System.lineSeparator()));
		
		HttpClient client = HttpClient.newHttpClient();
		HttpRequest request = HttpRequest.newBuilder(URI.create("http://backend:8080" + fullPath))
					.header("content-type", "application/json")
					.POST(HttpRequest.BodyPublishers.ofString(paramJsonString))
					.build();
			
		HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
		return response.body();
	}

	@GetMapping("/**")
	public byte[] frontend(HttpServletRequest servletRequest) throws IOException, InterruptedException {
		String fullPath = servletRequest.getRequestURI();

		var client = HttpClient.newHttpClient();
		var request = HttpRequest.newBuilder(
			URI.create("http://frontend:80" + fullPath))
		.header("accept", "application/json")
		.build(); 

		var response = client.send(request, BodyHandlers.ofByteArray());

		return response.body();
	}
}
