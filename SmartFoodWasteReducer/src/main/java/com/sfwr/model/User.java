package com.sfwr.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

/**
 * User entity represents application users with roles.
 */
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler", "password"})
@Entity
@Table(name = "users", uniqueConstraints = {@UniqueConstraint(columnNames = {"email"})})
public class User {

    /** Primary key for the user. */
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    private Long id;

    /** Full name of the user. */
    @NotBlank
    @Size(min = 2, max = 100)
    private String name;

    /** Unique email used for authentication. */
    @Email
    @NotBlank
    private String email;

    /** BCrypt-hashed password. */
    @NotBlank
    @Size(min = 6)
    private String password;

    /** Role used for authorization. */
    @Enumerated(EnumType.STRING)
    private Role role;

    /** City or locality used for SQL-based matching. */
    @NotBlank
    private String location;

    public User() {}

    public User(Long id, String name, String email, String password, Role role, String location) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.password = password;
        this.role = role;
        this.location = location;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public Role getRole() { return role; }
    public void setRole(Role role) { this.role = role; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                ", role=" + role +
                ", location='" + location + '\'' +
                '}';
    }
}


