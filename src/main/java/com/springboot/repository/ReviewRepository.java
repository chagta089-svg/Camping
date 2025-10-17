package com.springboot.repository;

import com.springboot.model.Review;
import com.springboot.model.User;
import com.springboot.model.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ReviewRepository extends JpaRepository<Review, Integer> {
    List<Review> findByUser(User user);
    List<Review> findByProduct(Product product);
}