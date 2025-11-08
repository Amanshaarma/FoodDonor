package com.sfwr.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;

/**
 * Request entity captures a receiver's request for a specific food donation.
 */
@Entity
@Table(name = "requests")
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler", "password"})
public class Request {

    /** Primary key for the request. */
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "request_id")
    private Long id;

    /** The food being requested. */
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "food_id")
    private Food food;

    /** The receiver making the request. */
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "receiver_id")
    private User receiver;

    /** Current status of the request. */
    @NotNull
    @Enumerated(EnumType.STRING)
    private RequestStatus status;

    public Request() {}

    public Request(Long id, Food food, User receiver, RequestStatus status) {
        this.id = id;
        this.food = food;
        this.receiver = receiver;
        this.status = status;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Food getFood() { return food; }
    public void setFood(Food food) { this.food = food; }

    public User getReceiver() { return receiver; }
    public void setReceiver(User receiver) { this.receiver = receiver; }

    public RequestStatus getStatus() { return status; }
    public void setStatus(RequestStatus status) { this.status = status; }

    @Override
    public String toString() {
        return "Request{" +
                "id=" + id +
                ", foodId=" + (food != null ? food.getId() : null) +
                ", receiverId=" + (receiver != null ? receiver.getId() : null) +
                ", status=" + status +
                '}';
    }
}


