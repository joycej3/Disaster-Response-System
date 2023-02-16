package com.example.Load;

import java.util.HashMap;
import java.util.concurrent.atomic.AtomicLong;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import weka.core.converters.JSONLoader;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpResponse.BodyHandler;
import java.net.http.HttpResponse.BodyHandlers;


@RestController
@Component
public class Main {

	@GetMapping("/greeting")
	public HashMap greeting(@RequestParam(value = "name", defaultValue = "World") String name) throws IOException, InterruptedException {
		
		// create a client
		var client = HttpClient.newHttpClient();
		// create a request
		var request = HttpRequest.newBuilder(
			URI.create("http://localhost:8081/greeting"))
		.header("accept", "application/json")
		.build();

		// use the client to send the request
		var response = client.send(request, BodyHandlers.ofString());

		JsonObject jsonObject = new JsonParser().parse(response.body()).getAsJsonObject();
		System.out.println(jsonObject);
		HashMap<String, Object> hashMap = new Gson().fromJson(jsonObject, HashMap.class);
		System.out.println(hashMap);
		return hashMap;
		
	}

}
