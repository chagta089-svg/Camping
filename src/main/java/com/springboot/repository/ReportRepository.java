package com.springboot.repository;

import com.springboot.model.Report;
import com.springboot.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ReportRepository extends JpaRepository<Report, Integer> {
    List<Report> findByUser(User user);
}