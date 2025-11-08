package com.sfwr.service;

import com.sfwr.model.*;
import com.sfwr.repository.FoodRepository;
import com.sfwr.repository.RequestRepository;
import com.sfwr.repository.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * RequestService manages receiver requests and donor approvals.
 */
@Service
public class RequestService {
    private final RequestRepository requestRepository;
    private final FoodRepository foodRepository;
    private final UserRepository userRepository;

    public RequestService(RequestRepository requestRepository, FoodRepository foodRepository, UserRepository userRepository) {
        this.requestRepository = requestRepository;
        this.foodRepository = foodRepository;
        this.userRepository = userRepository;
    }

    /** Receiver requests a specific food. */
    @Transactional
    public Request requestFood(Long foodId, Long receiverId) {
        Food food = foodRepository.findById(foodId).orElseThrow();
        User receiver = userRepository.findById(receiverId).orElseThrow();
        Request req = new Request();
        req.setFood(food);
        req.setReceiver(receiver);
        req.setStatus(RequestStatus.REQUESTED);
//        food.setStatus(FoodStatus.APPROVED);
        return requestRepository.save(req);
    }

    /** Donor approves the request and advances food status. */
    @Transactional
    public Request approveRequest(Long requestId) {
        Request req = requestRepository.findById(requestId).orElseThrow();
        req.setStatus(RequestStatus.APPROVED);
        Food food = req.getFood();
        food.setStatus(FoodStatus.APPROVED);
        return req;
    }

    /** Update pickup status. */
    @Transactional
    public Request markDecline(Long requestId) {
        Request req = requestRepository.findById(requestId).orElseThrow();
        req.setStatus(RequestStatus.PICKED);
        req.getFood().setStatus(FoodStatus.DECLINE);
        return req;
    }

    /** Update delivered status. */
    @Transactional
    public Request markDelivered(Long requestId) {
        Request req = requestRepository.findById(requestId).orElseThrow();
        req.setStatus(RequestStatus.DELIVERED);
        req.getFood().setStatus(FoodStatus.DELIVERED);
        return req;
    }

    /** List requests for a receiver. */
    public List<Request> listForReceiver(Long receiverId) {
        User receiver = userRepository.findById(receiverId).orElseThrow();
        return requestRepository.findByReceiver(receiver);
    }

    /** List all requests for a specific food item. */
    public List<Request> listByFood(Long foodId) {
        Food food = foodRepository.findById(foodId).orElseThrow();
        return requestRepository.findByFood(food);
    }
}


