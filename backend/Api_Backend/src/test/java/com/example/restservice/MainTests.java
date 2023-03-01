// /*
//  * Copyright 2016 the original author or authors.
//  *
//  * Licensed under the Apache License, Version 2.0 (the "License");
//  * you may not use this file except in compliance with the License.
//  * You may obtain a copy of the License at
//  *
//  *	  https://www.apache.org/licenses/LICENSE-2.0
//  *
//  * Unless required by applicable law or agreed to in writing, software
//  * distributed under the License is distributed on an "AS IS" BASIS,
//  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  * See the License for the specific language governing permissions and
//  * limitations under the License.
//  */
// package com.example.restservice;

// import static org.junit.jupiter.api.Assertions.assertEquals;
// import static org.mockito.ArgumentMatchers.any;
// import static org.mockito.Mockito.when;
// import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
// import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
// import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
// import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

// import java.io.Console;
// import java.io.FileNotFoundException;
// import java.io.IOException;

// import org.junit.jupiter.api.BeforeEach;
// import org.junit.jupiter.api.Test;
// import org.junit.jupiter.api.extension.ExtendWith;
// import org.mockito.Mock;
// import org.mockito.Mockito;
// import org.mockito.MockitoAnnotations;
// import org.mockito.internal.matchers.Null;
// import org.mockito.junit.jupiter.MockitoExtension;
// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
// import org.springframework.boot.test.context.SpringBootTest;
// import org.springframework.boot.test.mock.mockito.MockBean;
// import org.springframework.test.web.servlet.MockMvc;
// import com.google.firebase.database.DatabaseReference;
// import com.google.firebase.database.FirebaseDatabase;




// @ExtendWith(MockitoExtension.class)
// public class MainTests {
// 	@Mock	
// 	FirebaseDatabase getDatabase;

// 	@Mock
// 	DatabaseReference databaseReference;

// 	@Mock
// 	Config config;
	

// 	@Autowired
// 	private MockMvc mockMvc;

// 	Main main;

// 	@BeforeEach
// 	public void setUp() throws FileNotFoundException, IOException{
// 		when(getDatabase.getReference(any())).thenReturn(databaseReference);
// 		when(databaseReference.addChildEventListener(any())).thenReturn(null);
// 		main = new Main(getDatabase);
// 	}

	
// 	@Test
// 	public void GreetingRecordTest(){
// 		//GIVEN
// 		String name = "test";
// 		long counter = 0;
// 		GreetingRecord greetingRecord = new GreetingRecord(counter, String.format("Hello, %s!", name));

// 		//WHEN
		
// 		GreetingRecord recordReturned = main.greeting(name);

// 		//THEN
// 		assertEquals(greetingRecord.content(), recordReturned.content());
// 	}

// }
