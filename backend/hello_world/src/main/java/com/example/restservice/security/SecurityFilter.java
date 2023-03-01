package com.example.restservice.security;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;

import com.example.restservice.security.models.Credentials;
import com.example.restservice.security.models.Credentials.CredentialType;
import com.example.restservice.security.models.SecurityProperties;
import com.example.restservice.security.models.User;
import com.example.restservice.security.roles.RoleConstants;
import com.example.restservice.security.roles.RoleService;
import lombok.extern.slf4j.Slf4j;

@Component
@Slf4j
public class SecurityFilter extends OncePerRequestFilter {

	@Autowired
	private SecurityService securityService;

	@Autowired
	private CookieService cookieUtils;

	@Autowired
	private SecurityProperties securityProps;

	@Autowired
	RoleService securityRoleService;

	@Autowired
	private FirebaseAuth firebaseAuth;

	@Override
	protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
			throws ServletException, IOException {
		authorize(request);
		filterChain.doFilter(request, response);
	}

	private void authorize(HttpServletRequest request) {
		System.out.println("Security filter auth");
		String sessionCookieValue = null;
		FirebaseToken decodedToken = null;
		CredentialType type = null;
		// Token verification
		boolean strictServerSessionEnabled = securityProps.getFirebaseProps().isEnableStrictServerSession();
		Cookie sessionCookie = cookieUtils.getCookie("session");
		String token = securityService.getBearerToken(request);
		System.out.println("token");
		System.out.println(token);
		try {
			if (sessionCookie != null) {
				System.out.println("session cookie not null");
				sessionCookieValue = sessionCookie.getValue();
				decodedToken = firebaseAuth.verifySessionCookie(sessionCookieValue,
						securityProps.getFirebaseProps().isEnableCheckSessionRevoked());
				type = CredentialType.SESSION;
			} else if (!strictServerSessionEnabled && token != null && !token.equals("null")
					&& !token.equalsIgnoreCase("undefined")) {
						System.out.println("null cookie");
				decodedToken = firebaseAuth.verifyIdToken(token);
				type = CredentialType.ID_TOKEN;
			}
		} catch (FirebaseAuthException e) {
			log.error("Firebase Exception:: ", e.getLocalizedMessage());
		}
		List<GrantedAuthority> authorities = new ArrayList<>();
		User user = firebaseTokenToUserDto(decodedToken);
		// Handle roles
		if (user != null && decodedToken != null) {
			// Handle Super Role
			if (securityProps.getSuperAdmins().contains(user.getEmail())) {
				if (!decodedToken.getClaims().containsKey(RoleConstants.ROLE_SUPER)) {
					try {
						securityRoleService.addRole(decodedToken.getUid(), RoleConstants.ROLE_SUPER);
					} catch (Exception e) {
						log.error("Super Role registeration expcetion ", e);
					}
				}
				authorities.add(new SimpleGrantedAuthority(RoleConstants.ROLE_SUPER));
			}
			// Handle Other roles
			decodedToken.getClaims().forEach((k, v) -> authorities.add(new SimpleGrantedAuthority(k)));
			// Set security context
			UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(user,
					new Credentials(type, decodedToken, token, sessionCookieValue), authorities);
			authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
			SecurityContextHolder.getContext().setAuthentication(authentication);
		}
	}

	private User firebaseTokenToUserDto(FirebaseToken decodedToken) {
		User user = null;
		if (decodedToken != null) {
			user = new User();
			user.setUid(decodedToken.getUid());
			user.setName(decodedToken.getName());
			user.setEmail(decodedToken.getEmail());
			System.out.println(decodedToken.getEmail());

		}
		return user;
	}

}