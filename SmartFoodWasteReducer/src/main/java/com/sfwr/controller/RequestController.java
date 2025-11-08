package com.sfwr.controller;

import com.sfwr.model.Request;
import com.sfwr.service.RequestService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * RequestController manages receiver requests and donor approvals.
 */
@RestController
@RequestMapping("/api/requests")
public class RequestController {

    private final RequestService requestService;

    public RequestController(RequestService requestService) {
        this.requestService = requestService;
    }

    /** Receiver requests a food item. */
    @PostMapping("/create")
    public ResponseEntity<Request> create(@RequestParam Long foodId, @RequestParam Long receiverId) {
    	Request request = requestService.requestFood(foodId, receiverId);
    	requestService.approveRequest(request.getId());
    	return ResponseEntity.ok(request);
    }

    /** Donor approves a request. */
    @PostMapping("/{id}/approve")
    public ResponseEntity<Request> approve(@PathVariable Long id) {
    	System.out.println("this api is called");
        return ResponseEntity.ok(requestService.approveRequest(id));
    }

    /** Mark as picked. */
    @PostMapping("/{id}/picked")
    public ResponseEntity<Request> picked(@PathVariable Long id) {
        return ResponseEntity.ok(requestService.markDecline(id));
    }

    /** Mark as delivered. */
    @PostMapping("/{id}/delivered")
    public ResponseEntity<Request> delivered(@PathVariable Long id) {
        return ResponseEntity.ok(requestService.markDelivered(id));
    }

    /** List receiver's requests. */
    @GetMapping("/receiver/{receiverId}")
    public ResponseEntity<List<Request>> listForReceiver(@PathVariable Long receiverId) {
        return ResponseEntity.ok(requestService.listForReceiver(receiverId));
    }

    /** Get all requests for a specific food item. */
    @GetMapping("/food/{foodId}")
    public ResponseEntity<List<Request>> getRequestsByFood(@PathVariable Long foodId) {
        return ResponseEntity.ok(requestService.listByFood(foodId));
    }
    @PutMapping("/api/requests/{id}/status")
    public ResponseEntity<?> updateRequestStatus(
        @PathVariable Long id, 
        @RequestParam String status
    ) {
        // Update request status logic
        return ResponseEntity.ok().build();
    }
}



