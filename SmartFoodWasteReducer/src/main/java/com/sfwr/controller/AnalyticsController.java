package com.sfwr.controller;

import com.sfwr.model.Analytics;
import com.sfwr.model.User;
import com.sfwr.repository.UserRepository;
import com.sfwr.service.AnalyticsService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;  
import java.util.List;
import java.util.Map;

/**
 * AnalyticsController exposes KPI metrics for dashboards.
 */
@RestController
@RequestMapping("/api/analytics")
public class AnalyticsController {

    private final AnalyticsService analyticsService;
    private final UserRepository userRepository;

    public AnalyticsController(AnalyticsService analyticsService, UserRepository userRepository) {
        this.analyticsService = analyticsService;
        this.userRepository = userRepository;
    }

    /** Overall metrics including total meals saved and top donors. */
    @GetMapping("/summary")
    public ResponseEntity<Map<String, Object>> summary() {
        long meals = analyticsService.getTotalMealsSaved();
        List<Analytics> top = analyticsService.getTopDonors();
        Map<String, Object> resp = new HashMap<>();
        resp.put("totalMealsSaved", meals);
        resp.put("topDonors", top);
        return ResponseEntity.ok(resp);
    }

    /** Get monthly analytics for the current user. */
    @GetMapping("/monthly")
    public ResponseEntity<Map<String, Object>> monthly(@RequestParam(required = false) Integer year,
                                                          @RequestParam(required = false) Integer month) {
        User currentUser = getCurrentUser();
        return ResponseEntity.ok(analyticsService.getMonthlyAnalytics(currentUser.getId(), year, month));
    }

    /** Get yearly analytics for the current user. */
    @GetMapping("/yearly")
    public ResponseEntity<Map<String, Object>> yearly(@RequestParam(required = false) Integer year) {
        User currentUser = getCurrentUser();
        return ResponseEntity.ok(analyticsService.getYearlyAnalytics(currentUser.getId(), year));
    }

    private User getCurrentUser() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String email = auth.getName();
        return userRepository.findByEmail(email).orElseThrow();
    }
}



