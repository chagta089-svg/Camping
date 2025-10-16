package com.springboot.service;

import com.springboot.model.*;
import com.springboot.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CampingService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ProductTypeRepository productTypeRepository;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private StockRepository stockRepository;

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private OrderDetailRepository orderDetailRepository;

    @Autowired
    private ReportRepository reportRepository;

    @Autowired
    private ReviewRepository reviewRepository;

    // User methods
    public List<User> findAllUsers() {
        return userRepository.findAll();
    }

    public User findUserById(Integer id) {
        return userRepository.findById(id).orElse(null);
    }

    public User saveUser(User user) {
        return userRepository.save(user);
    }

    public void deleteUserById(Integer id) {
        userRepository.deleteById(id);
    }

    // ProductType methods
    public List<ProductType> findAllProductTypes() {
        return productTypeRepository.findAll();
    }

    public ProductType findProductTypeById(Integer id) {
        return productTypeRepository.findById(id).orElse(null);
    }

    public ProductType saveProductType(ProductType productType) {
        return productTypeRepository.save(productType);
    }

    public void deleteProductTypeById(Integer id) {
        productTypeRepository.deleteById(id);
    }

    // Product methods
    public List<Product> findAllProducts() {
        return productRepository.findAll();
    }

    public Product findProductById(Integer id) {
        return productRepository.findById(id).orElse(null);
    }

    public Product saveProduct(Product product) {
        return productRepository.save(product);
    }

    public void deleteProductById(Integer id) {
        productRepository.deleteById(id);
    }

    // Stock methods
    public List<Stock> findAllStocks() {
        return stockRepository.findAll();
    }

    public Stock findStockById(Integer id) {
        return stockRepository.findById(id).orElse(null);
    }

    public Stock saveStock(Stock stock) {
        return stockRepository.save(stock);
    }

    public void deleteStockById(Integer id) {
        stockRepository.deleteById(id);
    }

    // Order methods
    public List<Order> findAllOrders() {
        return orderRepository.findAll();
    }

    public Order findOrderById(Integer id) {
        return orderRepository.findById(id).orElse(null);
    }

    public Order saveOrder(Order order) {
        return orderRepository.save(order);
    }

    public void deleteOrderById(Integer id) {
        orderRepository.deleteById(id);
    }

    // OrderDetail methods
    public List<OrderDetail> findAllOrderDetails() {
        return orderDetailRepository.findAll();
    }

    public OrderDetail findOrderDetailById(Integer id) {
        return orderDetailRepository.findById(id).orElse(null);
    }

    public OrderDetail saveOrderDetail(OrderDetail orderDetail) {
        return orderDetailRepository.save(orderDetail);
    }

    public void deleteOrderDetailById(Integer id) {
        orderDetailRepository.deleteById(id);
    }

    // Report methods
    public List<Report> findAllReports() {
        return reportRepository.findAll();
    }

    public Report findReportById(Integer id) {
        return reportRepository.findById(id).orElse(null);
    }

    public Report saveReport(Report report) {
        return reportRepository.save(report);
    }

    public void deleteReportById(Integer id) {
        reportRepository.deleteById(id);
    }

    // Review methods
    public List<Review> findAllReviews() {
        return reviewRepository.findAll();
    }

    public Review findReviewById(Integer id) {
        return reviewRepository.findById(id).orElse(null);
    }

    public Review saveReview(Review review) {
        return reviewRepository.save(review);
    }

    public void deleteReviewById(Integer id) {
        reviewRepository.deleteById(id);
    }

    // Additional business methods if needed
    public void updateStockAfterOrder(Integer productId, Integer quantity) {
        Stock stock = findStockById(productId);
        if (stock != null) {
            stock.setQty(stock.getQty() - quantity);
            saveStock(stock);
        }
    }

    public double calculateOrderTotal(List<OrderDetail> orderDetails) {
        double total = 0.0;
        for (OrderDetail detail : orderDetails) {
            total += detail.getSubtotal().doubleValue();
        }
        return total;
    }
}