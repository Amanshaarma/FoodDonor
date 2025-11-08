package com.sfwr.service;

import com.sfwr.model.*;
import com.sfwr.repository.FoodRepository;
import com.sfwr.repository.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

/**
 * FoodService manages donation lifecycle and matching.
 */
@Service
public class FoodService {
    private final FoodRepository foodRepository;
    private final UserRepository userRepository;

    public FoodService(FoodRepository foodRepository, UserRepository userRepository) {
        this.foodRepository = foodRepository;
        this.userRepository = userRepository;
    }

    /** Donor posts new food donation. */
    @Transactional
    public Food postFood(Long donorId, String name, int quantity, LocalDateTime expiry, String imageUrl, String location) {
        User donor = userRepository.findById(donorId).orElseThrow();
        Food food = new Food();
        food.setDonor(donor);
        food.setFoodName(name);
        food.setQuantity(quantity);
        food.setExpiryTime(expiry);
        food.setStatus(FoodStatus.PENDING);
        food.setImageUrl(imageUrl);
        food.setLocation(location);
        return foodRepository.save(food);
    }

    /** Find pending food available for a location prefix proximity. */
    public List<Food> findPendingNearby(String locationPrefix) {
        return foodRepository.findPendingByLocationPrefix(locationPrefix);
    }

    /** Find all food donated by a specific donor. */
    public List<Food> findByDonor(Long donorId) {
        User donor = userRepository.findById(donorId).orElseThrow();
        return foodRepository.findByDonor(donor);
    }

	public List<Food> getAll() {
		// TODO Auto-generated method stub
		return foodRepository.findAll();
	}
}


