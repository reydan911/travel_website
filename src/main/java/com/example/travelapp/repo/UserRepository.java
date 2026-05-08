package com.example.travelapp.repo;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.travelapp.model.User;

public interface UserRepository extends JpaRepository<User, Long> {

    User findByEmail(String email);

    User findByUsername(String username);
}
