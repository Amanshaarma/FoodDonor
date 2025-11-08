package com.sfwr.service;

import com.sfwr.model.Role;
import com.sfwr.model.User;
import com.sfwr.repository.UserRepository;
import com.sfwr.security.JwtUtil;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

/**
 * AuthService handles registration and login using JWT.
 */
@Service
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final AuthenticationManager authenticationManager;
    private final JwtUtil jwtUtil;

    public AuthService(UserRepository userRepository,
                       PasswordEncoder passwordEncoder,
                       AuthenticationManager authenticationManager,
                       JwtUtil jwtUtil) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.authenticationManager = authenticationManager;
        this.jwtUtil = jwtUtil;
    }

    /** Register a new user and return JWT token. */
    public String register(String name, String email, String rawPassword, Role role, String location) {
        System.out.println("Registering user - Email: " + email + ", Role: " + role);

        // ✅ Check if user already exists
        if (userRepository.findByEmail(email).isPresent()) {
            throw new RuntimeException("User with this email already exists. Please login instead.");
        }

        // ✅ Encode password before saving
        String encodedPassword = passwordEncoder.encode(rawPassword);

        User user = new User();
        user.setName(name);
        user.setEmail(email);
        user.setPassword(encodedPassword);
        user.setRole(role);
        user.setLocation(location);
        userRepository.save(user);

        System.out.println("User registered successfully: " + email);

        Map<String, Object> claims = new HashMap<>();
        claims.put("role", role.name());
        return jwtUtil.generateToken(email, claims);
    }

    /** Authenticate credentials and return JWT token. */
    public String login(String email, String rawPassword, Role role) {

        // ✅ Check if user exists
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Invalid email or password"));

        // ✅ Validate role
        if (user.getRole() != role) {
            throw new RuntimeException("Invalid role. This account is registered as " + user.getRole());
        }

        // ✅ Check password using PasswordEncoder.matches()
        if (!passwordEncoder.matches(rawPassword, user.getPassword())) {
            throw new RuntimeException("Invalid email or password");
        } 
        

        // ✅ Authenticate using Spring Security
        try {
            authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(email, rawPassword)
            );
        } catch (Exception e) {
            throw new RuntimeException("Authentication failed: " + e.getMessage());
        }

        // ✅ Generate JWT
        Map<String, Object> claims = new HashMap<>();
        claims.put("role", user.getRole().name());
        return jwtUtil.generateToken(email, claims);
    }

    /** Get user by email. */
    public User getUserByEmail(String email) {
        return userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"));
    }
}
