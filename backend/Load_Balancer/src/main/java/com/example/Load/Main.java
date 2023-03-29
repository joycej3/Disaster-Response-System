package com.example.Load;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import jakarta.servlet.http.HttpServletRequest;
import net.bytebuddy.agent.VirtualMachine.ForHotSpot.Connection.Response;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpResponse.BodyHandlers;
import java.security.Timestamp;


@RestController
@CrossOrigin
@Component
@EnableScheduling
public class Main {

	HashMap<String, ArrayList<String>> serverTypeToIpList = new HashMap<>();
	HashMap<String, Long> ipToLastHeartbeat = new HashMap<>();
	HashMap<String, Integer> serverTypeToLastIpIndex = new HashMap<>();
	ArrayList<String> validServerTypes = new ArrayList<>();

	@Autowired
	public Main(){
		serverTypeToIpList.put("backend", new ArrayList<String>());
		serverTypeToIpList.put("frontend", new ArrayList<String>());
		serverTypeToLastIpIndex.put("backend", -1);
		serverTypeToLastIpIndex.put("frontend", -1);
		validServerTypes.add("backend");
		validServerTypes.add("frontend");
	}

	@PostMapping("/register")
	public ResponseEntity<String> register(@RequestBody Server server, HttpServletRequest servletRequest) {
		String servletRequestIp = servletRequest.getRemoteAddr();
		System.out.println("Register remote ip: " + servletRequestIp + ", type: " + server.type);
		if(!validServerTypes.contains(server.type)){
			return new ResponseEntity<>("invalid server type", HttpStatus.NOT_ACCEPTABLE);
		}
		ArrayList<String> ipList = serverTypeToIpList.get(server.type);
		ipList.add(servletRequestIp);
		serverTypeToIpList.put(server.type, ipList);
		ipToLastHeartbeat.put(servletRequestIp, System.currentTimeMillis());
		return new ResponseEntity<>("success", HttpStatus.CREATED);
	}


	@GetMapping("/heartbeat")
	public ResponseEntity<String> heartbeat(HttpServletRequest servletRequest){
		String servletRequestIp = servletRequest.getRemoteAddr();
		if(ipToLastHeartbeat.get(servletRequestIp) == null){
			return new ResponseEntity<>("failed", HttpStatus.NOT_ACCEPTABLE);
		}
		else ipToLastHeartbeat.put(servletRequestIp, System.currentTimeMillis());
		return new ResponseEntity<>("success", HttpStatus.CREATED);
	}

		
	@GetMapping({"/backend/**", "/public/**", "/coordinator/**", "/worker/**", "/super/**"})
	public ResponseEntity<?> backendGet(@RequestParam Map<String,String> allRequestParams, HttpServletRequest servletRequest) throws IOException, InterruptedException {
		return mapGetRequest("backend", servletRequest, allRequestParams, true);
	}

	@PostMapping({"/backend/**", "/public/**", "/coordinator/**", "/worker/**", "/super/**"})
	public ResponseEntity<?> backendPost(HttpServletRequest servletRequest) throws IOException, InterruptedException {
		return mapPostRequest("backend", servletRequest);
	}

	@GetMapping("/**")
	public ResponseEntity<?> frontend(HttpServletRequest servletRequest) throws IOException, InterruptedException {
		return mapGetRequest("frontend", servletRequest, Collections.emptyMap(), false);
	}

	private String getNextIp(String serverType){
		ArrayList<String> ipList = serverTypeToIpList.get(serverType);
		if(ipList.size() == 0){
			return "";
		}
		Integer nextIpIndex = serverTypeToLastIpIndex.get(serverType) + 1;
		nextIpIndex = nextIpIndex % ipList.size();
		String nextIp = ipList.get(nextIpIndex);
		if(!ipToLastHeartbeat.containsKey(nextIp)){
			ipList.remove(nextIp);
			serverTypeToIpList.put(serverType, ipList);
			return getNextIp(serverType);
		}
		serverTypeToLastIpIndex.put(serverType, nextIpIndex);
		return nextIp;
	}

	@Scheduled(fixedRate = 2500L)
	private void purgeOldIps(){
		ArrayList<String> ipsToPurge = new ArrayList<String>();
		for (Map.Entry<String, Long> entry : ipToLastHeartbeat.entrySet()) {
			String ip = entry.getKey();
			Long lastHeartbeat = entry.getValue();
			if (System.currentTimeMillis() - lastHeartbeat > 5000){
				ipsToPurge.add(ip);
			}
		}
		for (String ip : ipsToPurge){
			ipToLastHeartbeat.remove(ip);
		}
		for (Map.Entry<String, ArrayList<String>> entry : serverTypeToIpList.entrySet()) {
			String serverType = entry.getKey();
			ArrayList<String> ipList = entry.getValue();
			ipList.removeAll(ipsToPurge);
			serverTypeToIpList.put(serverType, ipList);
		}
		if (ipsToPurge.size() > 0){
			System.out.println("ipsToPurge: " + ipsToPurge);
		}
	}

	private ResponseEntity<?> mapGetRequest(String serverType, HttpServletRequest servletRequest, Map<String,String> allRequestParams, Boolean returnMap) throws IOException, InterruptedException{
		String ip = getNextIp(serverType);
		if(ip == ""){
			return new ResponseEntity<>(new HashMap<>(), HttpStatus.INTERNAL_SERVER_ERROR);
		}
		
		String fullPath = servletRequest.getRequestURI();
		String paramString = allRequestParams.toString().replace("}", "").replace("{","?").replace(", ", "&");
		System.out.println("Backend get request: " + fullPath + ", args: " + paramString);

		var client = HttpClient.newHttpClient();

		String port;
		if(serverType == "backend"){
			port = "8081";
		}
		else{
			port = "80";
		}
		var request = HttpRequest.newBuilder(
			URI.create("http://" + ip + ":" + port + fullPath + paramString))
		.header("accept", "application/json")
		.build();

		System.out.println(serverType + " get: " + request.toString());
		
		
		if(returnMap){
			HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
			JsonObject jsonObject = new JsonParser().parse(response.body()).getAsJsonObject();
			System.out.println(jsonObject);
			HashMap result = new Gson().fromJson(jsonObject, HashMap.class);
			return new ResponseEntity<>(result, HttpStatus.CREATED);
		}
		else{
			HttpResponse<byte[]> response = client.send(request, BodyHandlers.ofByteArray());
			byte[] result = response.body();
			return new ResponseEntity<>(result, HttpStatus.CREATED);
		}

	}

	private ResponseEntity<?> mapPostRequest(String serverType, HttpServletRequest servletRequest) throws IOException, InterruptedException{
		String nextIp = getNextIp(serverType);
		if(nextIp == ""){
			return new ResponseEntity<>("", HttpStatus.INTERNAL_SERVER_ERROR);
		}
		String fullPath = servletRequest.getRequestURI();
		String paramJsonString = servletRequest.getReader().lines().collect(Collectors.joining(System.lineSeparator()));

		System.out.println("Backend get request: " + fullPath + ", args: " + paramJsonString);
		
		
		HttpClient client = HttpClient.newHttpClient();
		HttpRequest request = HttpRequest.newBuilder(URI.create("http://" + nextIp + ":8081" + fullPath))
					.header("content-type", "application/json")
					.POST(HttpRequest.BodyPublishers.ofString(paramJsonString))
					.build();
		System.out.println("backend post: " + request.toString());	
		HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
		System.out.println(response.body());
		return new ResponseEntity<>(response.body(), HttpStatus.CREATED);
	}
}
