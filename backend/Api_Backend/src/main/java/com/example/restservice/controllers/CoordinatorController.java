package com.example.restservice.controllers;

import java.util.HashMap;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.restservice.ReportClassifier;
import com.example.restservice.ReportsToModel;

// package com.example.restservice.controllers;

// import org.apache.http.HttpStatus;
// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.web.bind.annotation.GetMapping;
// import org.springframework.web.bind.annotation.PostMapping;
// import org.springframework.web.bind.annotation.RequestBody;
// import org.springframework.web.bind.annotation.RequestMapping;
// import org.springframework.web.bind.annotation.RestController;

// import com.example.restservice.notifications.FirebaseMessagingService;
// import com.example.restservice.security.roles.IsCoordinator;
// import com.google.firebase.database.DatabaseReference;


// @RestController
// @RequestMapping("COORDINATOR")
// public class CoordinatorController {
	
// 	@Autowired
//     private FirebaseMessagingService firebaseService;
	
// 	@GetMapping("data")
// 	@IsCoordinator
// 	public String getProtectedData() {
// 		System.out.println("controller: Coordinator");
// 		return "You have accessed Coordinator only data from spring boot";
// 	}

// 	@PostMapping(path = "tfi_push", 
//         consumes = MediaType.APPLICATION_JSON_VALUE, 
//         produces = MediaType.APPLICATION_JSON_VALUE)
// 	@IsCoordinator
// 	public ResponseEntity<String> firebase_push(@RequestBody TfiData tfi_data) {
// 		DatabaseReference tfiRef;
// 		tfiRef = getDatabase.getReference("external_data/tfi");
// 		System.out.println("Attempting firebase TFI push");
// 		tfiRef.push().setValueAsync(tfi_data);
// 		return new ResponseEntity<>("success", HttpStatus.CREATED);
// 	}

//     // public void sendPushMessage(){
// 	// 	// change the token list to the tokens of people in the area
// 	// 	List<String> temp_token_list = Arrays.asList("token1", "token2", "token3");
//     //     try {
// 	// 		firebaseService.sendNotification("Notification title", "Notification Text", temp_token_list);
// 	// 	} catch (FirebaseMessagingException e) {
// 	// 		e.printStackTrace();
// 	// 	}
//     // } 
	
// }

@RestController
public class CoordinatorController {
    @GetMapping("/modelSuggestions")
    public Map<String, Double> getModelSuggestions() {
        Integer disasterID = ReportClassifier.recentDisasterID;
        Map<String,Double> modelInputs = ReportsToModel.aggregatedReportsToModel(disasterID);
        //TODO make model predidctions on model inputs and return hashmap 
        Map<String,Double> modelSuggestions = new HashMap<>();
        return modelSuggestions;
    }
}
