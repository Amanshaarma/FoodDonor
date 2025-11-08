package com.sfwr.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.HashMap;
import java.util.Map;

/**
 * Global exception handler to ensure all errors return JSON responses.
 */
@RestControllerAdvice
public class GlobalExceptionHandler {

    /** Handle validation errors and return JSON error response. */
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Map<String, String>> handleValidationExceptions(MethodArgumentNotValidException ex) {
        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getAllErrors().forEach((error) -> {
            String fieldName = ((FieldError) error).getField();
            String errorMessage = error.getDefaultMessage();
            errors.put(fieldName, errorMessage);
        });
        
        Map<String, String> response = new HashMap<>();
        if (errors.containsKey("role")) {
            response.put("message", "Invalid role. Please select DONOR or RECEIVER.");
        } else if (errors.containsKey("email")) {
            response.put("message", "Invalid email format.");
        } else if (errors.containsKey("password")) {
            response.put("message", errors.get("password"));
        } else {
            response.put("message", "Validation failed: " + errors.values().iterator().next());
        }
        
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
    }

    /** Handle JSON deserialization errors (e.g., invalid enum values). */
    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<Map<String, String>> handleHttpMessageNotReadableException(HttpMessageNotReadableException ex) {
        Map<String, String> error = new HashMap<>();
        String message = ex.getMessage();
        if (message != null && (message.contains("role") || message.contains("enum") || message.contains("Role"))) {
            error.put("message", "Invalid role. Please select DONOR or RECEIVER.");
        } else {
            error.put("message", "Invalid request format. Please check your input.");
        }
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(error);
    }

    /** Handle IllegalArgumentException for JSON deserialization errors. */
    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<Map<String, String>> handleIllegalArgumentException(IllegalArgumentException ex) {
        Map<String, String> error = new HashMap<>();
        if (ex.getMessage().contains("role") || ex.getMessage().toLowerCase().contains("enum")) {
            error.put("message", "Invalid role. Please select DONOR or RECEIVER.");
        } else {
            error.put("message", ex.getMessage());
        }
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(error);
    }

    /** Handle all other runtime exceptions. */
    @ExceptionHandler(RuntimeException.class)
    public ResponseEntity<Map<String, String>> handleRuntimeException(RuntimeException ex) {
        Map<String, String> error = new HashMap<>();
        error.put("message", ex.getMessage());
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
    }
}

