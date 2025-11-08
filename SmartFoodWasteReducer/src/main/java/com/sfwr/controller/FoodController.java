package com.sfwr.controller;

import com.sfwr.model.Food;
import com.sfwr.model.User;
import com.sfwr.repository.UserRepository;
import com.sfwr.service.FoodService;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

/**
 * FoodController exposes endpoints for donors to post food and for listing nearby donations.
 */
@RestController
@RequestMapping("/api/food")
public class FoodController {

    private final FoodService foodService;
    private final UserRepository userRepository;

    public FoodController(FoodService foodService, UserRepository userRepository) {
        this.foodService = foodService;
        this.userRepository = userRepository;
    }

    /** Donor posts new food donation. */
    @PostMapping("/post")
    public ResponseEntity<Food> postFood(
                                         @RequestParam @NotBlank String foodName,
                                         @RequestParam @Min(1) int quantity,
                                         @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime expiryTime,
                                         @RequestParam(required = false) String imageUrl,
                                         @RequestParam @NotBlank String location) {
        User currentUser = getCurrentUser();
        return ResponseEntity.ok(foodService.postFood(currentUser.getId(), foodName, quantity, expiryTime, imageUrl, location));
    }

    /** List pending food nearby by location prefix. */
    @GetMapping("/nearby")
    public ResponseEntity<List<Food>> nearby(@RequestParam String locationPrefix) {
        return ResponseEntity.ok(foodService.findPendingNearby(locationPrefix));
    }

    /** Get all food donated by the current user. */
    @GetMapping("/my-donations")
    public ResponseEntity<List<Food>> getMyDonations() {
        User currentUser = getCurrentUser();
        return ResponseEntity.ok(foodService.findByDonor(currentUser.getId()));
    }

    private User getCurrentUser() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String email = auth.getName();
        return userRepository.findByEmail(email).orElseThrow();
    }
    @GetMapping("/all")
    public ResponseEntity<List<Food>> getAll()
    {
    	return ResponseEntity.ok(foodService.getAll());
    }
}



