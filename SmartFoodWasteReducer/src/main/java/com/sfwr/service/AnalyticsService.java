package com.sfwr.service;

import com.sfwr.model.*;
import com.sfwr.repository.AnalyticsRepository;
import com.sfwr.repository.FoodRepository;
import com.sfwr.repository.RequestRepository;
import com.sfwr.repository.UserRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * AnalyticsService aggregates and retrieves KPI metrics.
 */
@Service
public class AnalyticsService {
    private final AnalyticsRepository analyticsRepository;
    private final FoodRepository foodRepository;
    private final RequestRepository requestRepository;
    private final UserRepository userRepository;

    public AnalyticsService(AnalyticsRepository analyticsRepository, FoodRepository foodRepository,
                           RequestRepository requestRepository, UserRepository userRepository) {
        this.analyticsRepository = analyticsRepository;
        this.foodRepository = foodRepository;
        this.requestRepository = requestRepository;
        this.userRepository = userRepository;
    }

    /** Get top donors for dashboard. */
    public List<Analytics> getTopDonors() {
        return analyticsRepository.findTopDonors();
    }

    /** Total meals saved across the system. */
    public long getTotalMealsSaved() {
        return analyticsRepository.findAll().stream().mapToLong(Analytics::getMealsSaved).sum();
    }

    /** Get monthly analytics for a user. */
    public Map<String, Object> getMonthlyAnalytics(Long userId, Integer year, Integer month) {
        User user = userRepository.findById(userId).orElseThrow();
        int currentYear = year != null ? year : LocalDateTime.now().getYear();
        int currentMonth = month != null ? month : LocalDateTime.now().getMonthValue();

        LocalDateTime start = LocalDateTime.of(currentYear, currentMonth, 1, 0, 0);
        LocalDateTime end = start.plusMonths(1);

        List<Food> foods = foodRepository.findByDonor(user).stream()
                .filter(f -> f.getExpiryTime().isAfter(start) && f.getExpiryTime().isBefore(end))
                .collect(Collectors.toList());

        long totalDonations = foods.size();
        long mealsSaved = foods.stream().mapToLong(Food::getQuantity).sum();
        long deliveredCount = foods.stream()
                .filter(f -> f.getStatus() == FoodStatus.DELIVERED)
                .count();

        Map<String, Object> result = new HashMap<>();
        result.put("month", currentMonth);
        result.put("year", currentYear);
        result.put("totalDonations", totalDonations);
        result.put("mealsSaved", mealsSaved);
        result.put("deliveredCount", deliveredCount);
        return result;
    }

    /** Get yearly analytics for a user. */
    public Map<String, Object> getYearlyAnalytics(Long userId, Integer year) {
        User user = userRepository.findById(userId).orElseThrow();
        int currentYear = year != null ? year : LocalDateTime.now().getYear();

        LocalDateTime start = LocalDateTime.of(currentYear, 1, 1, 0, 0);
        LocalDateTime end = start.plusYears(1);

        List<Food> foods = foodRepository.findByDonor(user).stream()
                .filter(f -> f.getExpiryTime().isAfter(start) && f.getExpiryTime().isBefore(end))
                .collect(Collectors.toList());

        long totalDonations = foods.size();
        long mealsSaved = foods.stream().mapToLong(Food::getQuantity).sum();
        long deliveredCount = foods.stream()
                .filter(f -> f.getStatus() == FoodStatus.DELIVERED)
                .count();

        // Monthly breakdown
        Map<Integer, Long> monthlyData = new HashMap<>();
        for (int m = 1; m <= 12; m++) {
            int month = m;
            long monthlyMeals = foods.stream()
                    .filter(f -> f.getExpiryTime().getMonthValue() == month)
                    .mapToLong(Food::getQuantity)
                    .sum();
            monthlyData.put(month, monthlyMeals);
        }

        Map<String, Object> result = new HashMap<>();
        result.put("year", currentYear);
        result.put("totalDonations", totalDonations);
        result.put("mealsSaved", mealsSaved);
        result.put("deliveredCount", deliveredCount);
        result.put("monthlyData", monthlyData);
        return result;
    }
}



