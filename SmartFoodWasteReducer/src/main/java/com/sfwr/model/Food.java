package com.sfwr.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

/**
 * Food entity represents a donation posted by a donor.
 */
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler", "password"})
@Entity
@Table(name = "food")
public class Food {

    /** Primary key for the food record. */
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "food_id")
    private Long id;

    /** Donor who posted the food. */
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "donor_id")
    private User donor;

    /** Name/description of the food. */
    @NotBlank
    private String foodName;

    /** Quantity of meals estimated. */
    @Min(1)
    private int quantity;

    /** Expiry time after which food should not be used. */
    @NotNull
    private LocalDateTime expiryTime;

    /** Lifecycle status of the donation. */
    @Enumerated(EnumType.STRING)
    private FoodStatus status;

    /** Optional image URL or path. */
    private String imageUrl;

    /** City/location string duplicated for quick SQL matching. */
    @NotBlank
    private String location;

    public Food() {}

    public Food(Long id, User donor, String foodName, int quantity, LocalDateTime expiryTime, FoodStatus status, String imageUrl, String location) {
        this.id = id;
        this.donor = donor;
        this.foodName = foodName;
        this.quantity = quantity;
        this.expiryTime = expiryTime;
        this.status = status;
        this.imageUrl = imageUrl;
        this.location = location;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public User getDonor() { return donor; }
    public void setDonor(User donor) { this.donor = donor; }

    public String getFoodName() { return foodName; }
    public void setFoodName(String foodName) { this.foodName = foodName; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public LocalDateTime getExpiryTime() { return expiryTime; }
    public void setExpiryTime(LocalDateTime expiryTime) { this.expiryTime = expiryTime; }

    public FoodStatus getStatus() { return status; }
    public void setStatus(FoodStatus status) { this.status = status; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    @Override
    public String toString() {
        return "Food{" +
                "id=" + id +
                ", donorId=" + (donor != null ? donor.getId() : null) +
                ", foodName='" + foodName + '\'' +
                ", quantity=" + quantity +
                ", expiryTime=" + expiryTime +
                ", status=" + status +
                ", imageUrl='" + imageUrl + '\'' +
                ", location='" + location + '\'' +
                '}';
    }
}


