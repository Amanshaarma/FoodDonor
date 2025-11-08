package com.sfwr.repository;

import com.sfwr.model.Request;
import com.sfwr.model.RequestStatus;
import com.sfwr.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

/**
 * Repository for Request entity.
 */
public interface RequestRepository extends JpaRepository<Request, Long> {

    /** Find all requests for a receiver. */
    List<Request> findByReceiver(User receiver);

    /** Find requests by status. */
    List<Request> findByStatus(RequestStatus status);

    /** Find all requests for a food item. */
    List<Request> findByFood(com.sfwr.model.Food food);
}



