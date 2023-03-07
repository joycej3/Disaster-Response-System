package com.example.Load;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.when;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.Arrays;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.util.ReflectionTestUtils;

import jakarta.servlet.http.HttpServletRequest;




@ExtendWith(MockitoExtension.class)
public class MainTests {
	
	@Mock
	HttpServletRequest servletRequest;

	Main main = new Main();


	@BeforeEach
	public void setUp() throws FileNotFoundException, IOException{
		main = new Main();
        main.serverTypeToIpList.put("backend", new ArrayList<>(Arrays.asList("1.1.1.1")));
        main.serverTypeToIpList.put("frontend", new ArrayList<>(Arrays.asList("2.2.2.2")));

        main.ipToLastHeartbeat.put("1.1.1.1", System.currentTimeMillis());
        main.ipToLastHeartbeat.put("2.2.2.2", System.currentTimeMillis());

	}

	@Test
	public void registerSuccessTest(){
		//GIVEN
		when(servletRequest.getRemoteAddr()).thenReturn("1.1.1.2");

		//WHEN
		var response = main.register(new Server("backend"), servletRequest);

		//THEN
		assertEquals("success", response.getBody());
		assertEquals(new ArrayList<>(Arrays.asList("1.1.1.1", "1.1.1.2")), main.serverTypeToIpList.get("backend"));
	}

	@Test
	public void registerFailedTest(){
		//GIVEN
		when(servletRequest.getRemoteAddr()).thenReturn("1.1.1.2");

		//WHEN
		var response = main.register(new Server("invalid type"), servletRequest);

		//THEN
		assertEquals("invalid server type", response.getBody());
		assertEquals(new ArrayList<>(Arrays.asList("1.1.1.1")), main.serverTypeToIpList.get("backend"));
	}

	@Test
	public void heartbeatSuccessTest(){
		//GIVEN
		when(servletRequest.getRemoteAddr()).thenReturn("1.1.1.1");

		//WHEN
		var response = main.heartbeat(servletRequest);

		//THEN
		assertEquals("success", response.getBody());
	}

	@Test
	public void heartbeatFailedTest(){
		//GIVEN
		when(servletRequest.getRemoteAddr()).thenReturn("1.1.1.2");

		//WHEN
		var response = main.heartbeat(servletRequest);

		//THEN
		assertEquals("failed", response.getBody());
	}
	
	@Test
	public void getNextIpFirstRunTest(){
		//GIVEN

		//WHEN
        var nextIpIndex = ReflectionTestUtils.invokeMethod(main, "getNextIp", "backend");

		//THEN
		assertEquals("1.1.1.1", nextIpIndex);
		assertEquals(0, main.serverTypeToLastIpIndex.get("backend"));
	}

	@Test
	public void getNextIpTwoIpTest(){
		//GIVEN
		main.serverTypeToIpList.put("backend", new ArrayList<>(Arrays.asList("1.1.1.1", "1.1.1.2")));
		main.ipToLastHeartbeat.put("1.1.1.2", System.currentTimeMillis());
		main.serverTypeToLastIpIndex.put("backend", 0);

		//WHEN
        var nextIpIndex = ReflectionTestUtils.invokeMethod(main, "getNextIp", "backend");

		//THEN
		assertEquals("1.1.1.2", nextIpIndex);
		assertEquals(1, main.serverTypeToLastIpIndex.get("backend"));
	}

	@Test
	public void getNextIpRolloverTest(){
		//GIVEN
		main.serverTypeToIpList.put("backend", new ArrayList<>(Arrays.asList("1.1.1.1", "1.1.1.2")));
		main.ipToLastHeartbeat.put("1.1.1.2", System.currentTimeMillis());
		main.serverTypeToLastIpIndex.put("backend", 1);

		//WHEN
        var nextIpIndex = ReflectionTestUtils.invokeMethod(main, "getNextIp", "backend");

		//THEN
		assertEquals("1.1.1.1", nextIpIndex);
		assertEquals(0, main.serverTypeToLastIpIndex.get("backend"));
	}

}
