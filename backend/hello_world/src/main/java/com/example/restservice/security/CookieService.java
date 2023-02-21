package com.example.restservice.security;

import java.util.concurrent.TimeUnit;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.util.WebUtils;

import com.example.restservice.security.models.SecurityProperties;

@Service
public class CookieService {

	@Autowired
	HttpServletRequest httpServletRequest;

	@Autowired
	HttpServletResponse httpServletResponse;

	@Autowired
	SecurityProperties restSecProps;

	public Cookie getCookie(String name) {
		System.out.println(WebUtils.getCookie(httpServletRequest, name));
		return WebUtils.getCookie(httpServletRequest, name);
	}

	public void setCookie(String name, String value, int expiryInDays) {
		System.out.println("Set cookie");
		int expiresInSeconds = (int) TimeUnit.DAYS.toSeconds(expiryInDays);
		Cookie cookie = new Cookie(name, value);
		cookie.setSecure(restSecProps.getCookieProps().isSecure());
		cookie.setPath(restSecProps.getCookieProps().getPath());
		cookie.setDomain(restSecProps.getCookieProps().getDomain());
		cookie.setMaxAge(expiresInSeconds);
		httpServletResponse.addCookie(cookie);
	}

	public void setSecureCookie(String name, String value, int expiryInDays) {
		System.out.println("Set secure cookie");
		int expiresInSeconds = (int) TimeUnit.DAYS.toSeconds(expiryInDays);
		Cookie cookie = new Cookie(name, value);
		cookie.setHttpOnly(restSecProps.getCookieProps().isHttpOnly());
		cookie.setSecure(restSecProps.getCookieProps().isSecure());
		cookie.setPath(restSecProps.getCookieProps().getPath());
		cookie.setDomain(restSecProps.getCookieProps().getDomain());
		cookie.setMaxAge(expiresInSeconds);
		httpServletResponse.addCookie(cookie);
	}

	public void setSecureCookie(String name, String value) {
		System.out.println("Set secure cookie 2");
		int expiresInMinutes = restSecProps.getCookieProps().getMaxAgeInMinutes();
		setSecureCookie(name, value, expiresInMinutes);
	}

	public void deleteSecureCookie(String name) {
		System.out.println("delete secure cookie");
		int expiresInSeconds = 0;
		Cookie cookie = new Cookie(name, null);
		cookie.setHttpOnly(restSecProps.getCookieProps().isHttpOnly());
		cookie.setSecure(restSecProps.getCookieProps().isSecure());
		cookie.setPath(restSecProps.getCookieProps().getPath());
		cookie.setDomain(restSecProps.getCookieProps().getDomain());
		cookie.setMaxAge(expiresInSeconds);
		httpServletResponse.addCookie(cookie);
	}
	
	public void deleteCookie(String name) {
		System.out.println("delete cookie");
		int expiresInSeconds = 0;
		Cookie cookie = new Cookie(name, null);
		cookie.setPath(restSecProps.getCookieProps().getPath());
		cookie.setDomain(restSecProps.getCookieProps().getDomain());
		cookie.setMaxAge(expiresInSeconds);
		httpServletResponse.addCookie(cookie);
	}

}