/*
 * Copyright 2016 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *	  https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.example.restservice;

import static org.junit.Assert.assertThat;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.io.Console;
import java.io.FileNotFoundException;
import java.io.IOException;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import org.mockito.internal.matchers.Null;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.test.web.servlet.MockMvc;

import com.example.restservice.config.FirebaseConfig;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;



@ExtendWith(MockitoExtension.class)
public class MainTests {
	@Mock	
	FirebaseDatabase getDatabase;

	Database database;

	@Mock
	DatabaseReference databaseReference;

	@Mock
	FirebaseConfig config;

	@Mock
	ReportClassifier reportClassifier;

	@Autowired
	private MockMvc mockMvc;

	Main main;

	@BeforeEach
	public void setUp() throws FileNotFoundException, IOException{
		when(getDatabase.getReference(any())).thenReturn(databaseReference);
		when(databaseReference.addChildEventListener(any())).thenReturn(null);
		database = new Database(getDatabase);
		main = new Main(database, getDatabase);
		main.reportClassifier = reportClassifier;
	}

	@DisplayName("GIVEN parameters WHEN greeting is called THEN a correct greetingRecord is returned")
	@Test
	public void GreetingRecordTest(){
		//GIVEN
		String name = "test";
		long counter = 0;
		GreetingRecord greetingRecord = new GreetingRecord(counter, String.format("Hello, %s!", name));

		//WHEN
		
		GreetingRecord recordReturned = main.greeting(name);

		//THEN
		assertEquals(greetingRecord.content(), recordReturned.content());
	}

	@DisplayName("GIVEN a databaseref WHEN firebase() is called THEN a reasonable emergencyRecord is returned")
	@Test
	public void FirebaseGetTest() throws FileNotFoundException, IOException{
		//GIVEN
		String emergency = " ";
		String injury = " ";
		String time = " ";
		String lat = " ";
		String lon = " ";
		String reportCategory = " ";
		EmergencyRecord emergencyRecord = new EmergencyRecord(emergency, injury, time, lat,lon,reportCategory);

		//WHEN
		EmergencyRecord recordReturned = main.firebase();

		//THEN		
		assertEquals(emergencyRecord.toString(), recordReturned.toString());
	}

	//@Disabled
	@DisplayName("GIVEN an emergency report to add WHEN  firebasePush is called THEN the report is classified and returns success")
	@Test
	public void FirebasePushTest(){
		//GIVEN
		String emergency = "Fire";
		String injury = "I am injured";
		String time = "1678288146";
		String lat = "35.5";
		String lon = "36.6";
		String reportCategory = "1";
		Emergency givenEmergency = new Emergency(emergency, injury, time, lat,lon,reportCategory);
		System.out.println(givenEmergency);

		//WHEN
		try {
			when(reportClassifier.classifyReport(any())).thenReturn(true);
		
		ResponseEntity result = main.firebase_push(givenEmergency);

		//THEN
		verify(reportClassifier).classifyReport(any());
		assertEquals(new ResponseEntity<>("success", HttpStatus.CREATED), result);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
	}
}
