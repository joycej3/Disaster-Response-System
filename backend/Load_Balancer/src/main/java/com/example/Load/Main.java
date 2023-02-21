package com.example.Load;

import java.util.HashMap;
import java.util.concurrent.atomic.AtomicLong;

import org.netlib.util.booleanW;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.HandlerMapping;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import jakarta.servlet.http.HttpServletRequest;
import weka.core.converters.JSONLoader;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.Inet4Address;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpResponse.BodyHandler;
import java.net.http.HttpResponse.BodyHandlers;
import java.nio.file.Path;


@RestController
@Component
public class Main {

	@GetMapping("/backend/**")
	public HashMap backend(HttpServletRequest servletRequest) throws IOException, InterruptedException {
		String fullPath = (String) servletRequest.getAttribute(HandlerMapping.PATH_WITHIN_HANDLER_MAPPING_ATTRIBUTE);
		System.out.println("back:fullpath: " + fullPath);
		// create a client
		var client = HttpClient.newHttpClient();
		// create a request
		var request = HttpRequest.newBuilder(
			URI.create("http://backend:8080" + fullPath))
		.header("accept", "application/json")
		.build();
		System.out.println("backend request: " + request);

		// use the client to send the request
		var response = client.send(request, BodyHandlers.ofString());
		System.out.println("backend response: "+  response.body());

		JsonObject jsonObject = new JsonParser().parse(response.body()).getAsJsonObject();
		System.out.println(jsonObject);
		HashMap<String, Object> hashMap = new Gson().fromJson(jsonObject, HashMap.class);
		System.out.println(hashMap);
		return hashMap;
		
	}

	@GetMapping("/**")
	public byte[] frontend(HttpServletRequest servletRequest) throws IOException, InterruptedException {
		String fullPath = (String) servletRequest.getAttribute(HandlerMapping.PATH_WITHIN_HANDLER_MAPPING_ATTRIBUTE);
		System.out.println("front:fullpath: " + fullPath);
		// create a client
		var client = HttpClient.newHttpClient();
		// create a request
		var request = HttpRequest.newBuilder(
			URI.create("http://frontend:80" + fullPath))
		.header("accept", "application/json")
		.build(); 
		System.out.println("frontend request: " + request);

		// use the client to send the request
		var response = client.send(request, BodyHandlers.ofByteArray());
		System.out.println("frontend response: " + response.body());

		return response.body();
	}

}
