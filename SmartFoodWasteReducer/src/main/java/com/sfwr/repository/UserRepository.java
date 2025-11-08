package com.sfwr.repository;

import com.sfwr.model.Role;
import com.sfwr.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

/**
 * Repository for User entity.
 */
public interface UserRepository extends JpaRepository<User, Long> {

    /** Find by unique email. */
    Optional<User> findByEmail(String email);

    /** Find users by location and role. */
    List<User> findByLocationAndRole(String location, Role role);

    /** SQL-based nearby matching example using LIKE prefix for locality proximity. */
    @Query(value = "SELECT * FROM users u WHERE u.location LIKE CONCAT(?1, '%') AND u.role = 'RECEIVER'", nativeQuery = true)
    List<User> findNearbyReceivers(String locationPrefix);
}



