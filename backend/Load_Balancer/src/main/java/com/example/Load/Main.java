package com.example.Load;

import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.atomic.AtomicLong;
import java.util.stream.Collectors;

import org.netlib.util.booleanW;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
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
import org.springframework.web.servlet.mvc.condition.ParamsRequestCondition;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import weka.core.converters.JSONLoader;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.Inet4Address;
import java.net.URI;
import java.net.URL;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpRequest.BodyPublisher;
import java.net.http.HttpResponse.BodyHandler;
import java.net.http.HttpResponse.BodyHandlers;
import java.nio.charset.StandardCharsets;
import java.nio.file.Path;


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
