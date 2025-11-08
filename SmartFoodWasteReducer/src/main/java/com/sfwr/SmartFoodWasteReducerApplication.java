package com.sfwr;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * Application bootstrap for Smart Food Waste Reducer.
 * Starts the Spring Boot context and embedded Tomcat.
 */
@SpringBootApplication
public class SmartFoodWasteReducerApplication {

    /**
     * Entry point for the application.
     * @param args CLI arguments
     */
    public static void main(String[] args) {
        SpringApplication.run(SmartFoodWasteReducerApplication.class, args);
    }
}


