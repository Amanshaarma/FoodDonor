package com.sfwr.repository;

import com.sfwr.model.Analytics;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

/**
 * Repository for Analytics entity.
 */
public interface AnalyticsRepository extends JpaRepository<Analytics, Long> {

    /** Top donors by total donations. */
    @Query(value = "SELECT * FROM analytics ORDER BY total_donations DESC LIMIT 5", nativeQuery = true)
    List<Analytics> findTopDonors();
}



