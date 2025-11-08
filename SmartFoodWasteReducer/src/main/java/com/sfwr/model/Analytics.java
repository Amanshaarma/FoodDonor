package com.sfwr.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import jakarta.persistence.*;

/**
 * Analytics entity aggregates donation metrics per user.
 */
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler", "password"})
@Entity
@Table(name = "analytics")
public class Analytics {

    /** Primary key (one row per user). */
    @Id
    @Column(name = "user_id")
    private Long userId;

    /** Total number of donations by the user. */
    private long totalDonations;

    /** Estimated number of meals saved by the user. */
    private long mealsSaved;

    public Analytics() {}

    public Analytics(Long userId, long totalDonations, long mealsSaved) {
        this.userId = userId;
        this.totalDonations = totalDonations;
        this.mealsSaved = mealsSaved;
    }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public long getTotalDonations() { return totalDonations; }
    public void setTotalDonations(long totalDonations) { this.totalDonations = totalDonations; }

    public long getMealsSaved() { return mealsSaved; }
    public void setMealsSaved(long mealsSaved) { this.mealsSaved = mealsSaved; }

    @Override
    public String toString() {
        return "Analytics{" +
                "userId=" + userId +
                ", totalDonations=" + totalDonations +
                ", mealsSaved=" + mealsSaved +
                '}';
    }
}


