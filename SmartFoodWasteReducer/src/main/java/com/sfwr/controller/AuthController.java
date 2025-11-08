package com.sfwr.controller;

import com.sfwr.controller.dto.JwtResponse;
import com.sfwr.controller.dto.LoginRequest;
import com.sfwr.controller.dto.RegisterRequest;
import com.sfwr.service.AuthService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

/**
 * AuthController exposes JWT-based register and login endpoints.
 */
@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    /** Register a new user and return a JWT token. */
    @PostMapping("/register")
    public ResponseEntity<JwtResponse> register(@Valid @RequestBody RegisterRequest req) {
        String token = authService.register(req.getName(), req.getEmail(), req.getPassword(), req.getRole(), req.getLocation());
        return ResponseEntity.ok(new JwtResponse(token));
    }

    /** Login with email and password and return a JWT token. */
    @PostMapping("/login")
    public ResponseEntity<?> login(@Valid @RequestBody LoginRequest req) {
    	System.out.println("Login request received: " + req);
        try {
            String token = authService.login(req.getEmail(), req.getPassword(), req.getRole());
            System.out.println("Login successful, token generated");
            return ResponseEntity.ok(new JwtResponse(token));
        } catch (RuntimeException e) {
            System.out.println("Login failed: " + e.getMessage());
            e.printStackTrace();
            Map<String, String> error = new HashMap<>();
            error.put("message", e.getMessage());
            return ResponseEntity.status(401).body(error);
        }
    }

    /** Get current user information. */
    @GetMapping("/me")
    public ResponseEntity<Map<String, Object>> getCurrentUser() {
        org.springframework.security.core.Authentication auth = org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication();
        String email = auth.getName();
        com.sfwr.model.User user = authService.getUserByEmail(email);
        Map<String, Object> userInfo = new HashMap<>();
        userInfo.put("id", user.getId());
        userInfo.put("name", user.getName());
        userInfo.put("email", user.getEmail());
        userInfo.put("role", user.getRole());
        userInfo.put("location", user.getLocation());
        return ResponseEntity.ok(userInfo);
    }
}


