package com.springboot.repository;

import com.springboot.model.Stock;
import com.springboot.model.Product;
import org.springframework.data.jpa.repository.JpaRepository;

public interface StockRepository extends JpaRepository<Stock, Integer> {
    Stock findByProduct(Product product);
}