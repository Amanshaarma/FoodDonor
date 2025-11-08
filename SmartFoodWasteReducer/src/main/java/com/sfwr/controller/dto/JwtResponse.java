package com.sfwr.controller.dto;

/**
 * JWT response wrapper used by auth endpoints.
 */
public class JwtResponse {
    private String token;

    public JwtResponse() {}
    public JwtResponse(String token) { this.token = token; }
    public String getToken() { return token; }
    public void setToken(String token) { this.token = token; }

    @Override
    public String toString() {
        return "JwtResponse{" +
                "token='" + (token != null ? token.substring(0, Math.min(20, token.length())) + "..." : null) + '\'' +
                '}';
    }
}


