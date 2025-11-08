package com.sfwr.repository;

import com.sfwr.model.Food;
import com.sfwr.model.FoodStatus;
import com.sfwr.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

/**
 * Repository for Food entity.
 */
public interface FoodRepository extends JpaRepository<Food, Long> {

    /** Find food by donor. */
    List<Food> findByDonor(User donor);

    /** Find available food in a location. */
    List<Food> findByLocationAndStatus(String location, FoodStatus status);

    /** Native SQL to find food by location prefix for proximity. */
    @Query(value = "SELECT * FROM food f WHERE f.location LIKE CONCAT(?1, '%') AND f.status = 'PENDING'", nativeQuery = true)
    List<Food> findPendingByLocationPrefix(String locationPrefix);
}



