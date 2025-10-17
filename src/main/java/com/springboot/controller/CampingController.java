package com.springboot.controller;

import com.springboot.model.*;
import com.springboot.service.CampingService;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.*;

@Controller
public class CampingController {
   
	@Autowired
    private CampingService campingService;

    // ** ย้ายการสร้าง cartItems ไปไว้ใน ModelAttribute เพื่อให้มันถูกสร้างใหม่สำหรับแต่ละ Session **
    @ModelAttribute("cartItems")
    public List<OrderDetail> initializeCart() {
        return new ArrayList<>();
    }

    // ========== ระบบตะกร้าสินค้าและออร์เดอร์ (ใช้ Session) ==========

    // เพิ่มสินค้าในตะกร้า
    @PostMapping("/cart/add")
    public ModelAndView addToCart(@RequestParam Integer productId,
                                  @RequestParam Integer quantity,
                                  HttpSession session, // <-- ใช้ Session
                                  @ModelAttribute("cartItems") List<OrderDetail> cartItems) { // <-- ดึงตะกร้าจาก Session

        User user = (User) session.getAttribute("user"); // <-- ดึง user จาก Session
        if (user == null) {
            return new ModelAndView("redirect:/login");
        }

        Product product = campingService.findProductById(productId);
        if (product == null) {
            return new ModelAndView("redirect:/");
        }

        Stock stock = campingService.findStockByProduct(product);
        if (stock == null || stock.getQty() < quantity) {
            ModelAndView mv = new ModelAndView("redirect:/products/" +
                    (product.getProductType() != null ? product.getProductType().getProductTypeid() : ""));
            mv.addObject("error", "สินค้ามีไม่พอ");
            return mv;
        }

        OrderDetail cartItem = new OrderDetail();
        cartItem.setProduct(product);
        cartItem.setQuantity(quantity);
        cartItem.setPrice(product.getPrice());
        BigDecimal subtotal = product.getPrice().multiply(BigDecimal.valueOf(quantity));
        cartItem.setSubtotal(subtotal);

        boolean found = false;
        for (OrderDetail item : cartItems) {
            if (item.getProduct().getProductId().equals(productId)) {
                item.setQuantity(item.getQuantity() + quantity);
                item.setSubtotal(item.getPrice().multiply(BigDecimal.valueOf(item.getQuantity())));
                found = true;
                break;
            }
        }

        if (!found) {
            cartItems.add(cartItem);
        }

        ModelAndView mv = new ModelAndView("redirect:/cart");
        mv.addObject("success", "เพิ่มสินค้าในตะกร้าเรียบร้อยแล้ว");
        return mv;
    }

    // ดูตะกร้าสินค้า
    @GetMapping("/cart")
    public ModelAndView viewCart(HttpSession session, @ModelAttribute("cartItems") List<OrderDetail> cartItems) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return new ModelAndView("redirect:/login");
        }

        ModelAndView mv = new ModelAndView("cart");
        BigDecimal totalAmount = BigDecimal.ZERO;
        for (OrderDetail item : cartItems) {
            totalAmount = totalAmount.add(item.getSubtotal());
        }

        mv.addObject("cartItems", cartItems);
        mv.addObject("totalAmount", totalAmount);
        // user จะถูกดึงจาก session ไปแสดงในหน้า JSP โดยอัตโนมัติ
        return mv;
    }

    // อัพเดทจำนวนสินค้าในตะกร้า
    @PostMapping("/cart/update")
    public ModelAndView updateCart(@RequestParam Integer productId,
                                   @RequestParam Integer quantity,
                                   HttpSession session,
                                   @ModelAttribute("cartItems") List<OrderDetail> cartItems) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return new ModelAndView("redirect:/login");
        }

        for (OrderDetail item : cartItems) {
            if (item.getProduct().getProductId().equals(productId)) {
                Stock stock = campingService.findStockByProduct(item.getProduct());
                if (stock != null && quantity <= stock.getQty()) {
                    item.setQuantity(quantity);
                    item.setSubtotal(item.getPrice().multiply(BigDecimal.valueOf(quantity)));
                }
                break;
            }
        }
        return new ModelAndView("redirect:/cart");
    }

    // ลบสินค้าจากตะกร้า
    @PostMapping("/cart/remove")
    public ModelAndView removeFromCart(@RequestParam Integer productId,
                                       HttpSession session,
                                       @ModelAttribute("cartItems") List<OrderDetail> cartItems) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return new ModelAndView("redirect:/login");
        }
        cartItems.removeIf(item -> item.getProduct().getProductId().equals(productId));
        return new ModelAndView("redirect:/cart");
    }

    // สร้างออร์เดอร์
    @PostMapping("/order/create")
    public ModelAndView createOrder(HttpSession session, @ModelAttribute("cartItems") List<OrderDetail> cartItems) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return new ModelAndView("redirect:/login");
        }
        
        if (cartItems.isEmpty()) {
            ModelAndView mv = new ModelAndView("redirect:/cart");
            mv.addObject("error", "ตะกร้าสินค้าว่างเปล่า");
            return mv;
        }
        
        BigDecimal totalAmount = BigDecimal.ZERO;
        for (OrderDetail item : cartItems) {
            totalAmount = totalAmount.add(item.getSubtotal());
        }

        Order order = new Order();
        order.setUser(user);
        order.setOrderdate(LocalDateTime.now());
        order.setTotalAmount(totalAmount);
        Order savedOrder = campingService.saveOrder(order);

        for (OrderDetail cartItem : cartItems) {
            OrderDetail orderDetail = new OrderDetail();
            orderDetail.setOrder(savedOrder);
            orderDetail.setProduct(cartItem.getProduct());
            orderDetail.setQuantity(cartItem.getQuantity());
            orderDetail.setPrice(cartItem.getPrice());
            orderDetail.setSubtotal(cartItem.getSubtotal());
            campingService.saveOrderDetail(orderDetail);
            campingService.updateStockAfterOrder(cartItem.getProduct().getProductId(), cartItem.getQuantity());
        }

        cartItems.clear();

        ModelAndView mv = new ModelAndView("redirect:/order/" + savedOrder.getOrderid());
        mv.addObject("success", "สร้างออร์เดอร์สำเร็จ");
        return mv;
    }

    // ดูออร์เดอร์
    @GetMapping("/order/{orderId}")
    public ModelAndView viewOrder(@PathVariable Integer orderId, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return new ModelAndView("redirect:/login");
        }

        Order order = campingService.findOrderById(orderId);
        if (order == null || !Objects.equals(order.getUser().getUserid(), user.getUserid())) {
            return new ModelAndView("redirect:/");
        }

        List<OrderDetail> orderDetails = campingService.findOrderDetailsByOrder(order);
        ModelAndView mv = new ModelAndView("order");
        mv.addObject("order", order);
        mv.addObject("orderDetails", orderDetails);
        return mv;
    }

    // ดูประวัติออร์เดอร์
    @GetMapping("/orders")
    public ModelAndView viewOrderHistory(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return new ModelAndView("redirect:/login");
        }

        List<Order> orders = campingService.findOrdersByUser(user);
        ModelAndView mv = new ModelAndView("order");
        mv.addObject("orders", orders);
        return mv;
    }

    // ========== หน้าแรกและการจัดการผู้ใช้ทั่วไป (ใช้ Session) ==========

    // หน้าแรก - แสดงประเภทสินค้า
    @GetMapping("/")
    public ModelAndView index() {
        // ไม่ต้องรับ userId เพราะ user object จะถูกดึงจาก session ในหน้า JSP
        ModelAndView mv = new ModelAndView("index");
        mv.addObject("productTypes", campingService.findAllProductTypes());
        return mv;
    }

    // หน้า Login - GET
    @GetMapping("/login")
    public ModelAndView loginPage() {
        return new ModelAndView("login");
    }

    // กระบวนการ Login - POST (สำคัญ)
    @PostMapping("/login")
    public ModelAndView login(@RequestParam String username,
                              @RequestParam String password,
                              HttpSession session) { // <-- รับ HttpSession
        User user = campingService.findUserByUsername(username);

        if (user != null && user.getPassword().equals(password)) {
            session.setAttribute("user", user); // <-- *** เก็บ user object ใน Session ***

            if ("ADMIN".equalsIgnoreCase(user.getRole())) {
                return new ModelAndView("redirect:/admin/dashboard");
            } else {
                ModelAndView mv = new ModelAndView("redirect:/");
                mv.addObject("loginSuccess", true);
                return mv;
            }
        } else {
            ModelAndView mv = new ModelAndView("login");
            mv.addObject("error", "ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง");
            return mv;
        }
    }

    // หน้า Register - GET
    @GetMapping("/register")
    public ModelAndView registerPage() {
        return new ModelAndView("register");
    }

    // กระบวนการ Register - POST
    @PostMapping("/register")
    public ModelAndView register(@RequestParam String username,
                                 @RequestParam String password,
                                 @RequestParam String confirmPassword, // เพิ่มเข้ามา
                                 @RequestParam String fullname,      // เพิ่มเข้ามา
                                 @RequestParam String email,         // เพิ่มเข้ามา
                                 @RequestParam String phone,         // เพิ่มเข้ามา
                                 @RequestParam String addresss,      // เพิ่มเข้ามา
                                 HttpSession session) {

        // 1. ตรวจสอบว่ารหัสผ่านตรงกันหรือไม่
        if (!password.equals(confirmPassword)) {
            ModelAndView mv = new ModelAndView("register");
            mv.addObject("error", "รหัสผ่านไม่ตรงกัน");
            return mv;
        }

        // 2. ตรวจสอบว่ามีชื่อผู้ใช้นี้ในระบบแล้วหรือยัง
        if (campingService.isUsernameExists(username)) {
            ModelAndView mv = new ModelAndView("register");
            mv.addObject("error", "ชื่อผู้ใช้นี้มีอยู่แล้ว");
            return mv;
        }

        // 3. สร้าง User object และตั้งค่าทั้งหมดที่รับมา
        User user = new User();
        user.setUsername(username);
        user.setPassword(password); // ในแอปจริงควรเข้ารหัสรหัสผ่านก่อนเก็บ
        user.setFullname(fullname);
        user.setEmail(email);
        user.setPhone(phone);
        user.setAddresss(addresss);
        user.setRole("USER"); // กำหนด role เริ่มต้นเป็น USER

        // 4. บันทึกข้อมูลลงฐานข้อมูล
        campingService.saveUser(user);
        
        // 5. เมื่อสมัครเสร็จ ให้ล็อกอินโดยเก็บใน Session เลย
        session.setAttribute("user", user);

        // 6. ส่งกลับไปหน้าแรกพร้อมข้อความต้อนรับ
        ModelAndView mv = new ModelAndView("redirect:/");
        mv.addObject("loginSuccess", true);
        return mv;
    }

    // Logout - GET (สำคัญ)
    @GetMapping("/logout")
    public ModelAndView logout(HttpSession session) {
        session.invalidate(); // <-- *** ทำลาย Session ทั้งหมด ***
        ModelAndView mv = new ModelAndView("redirect:/");
        mv.addObject("logoutSuccess", true);
        return mv;
    }

    // หน้าแสดงสินค้าตามประเภท - GET
    @GetMapping("/products/{typeId}")
    public ModelAndView showProductsByType(@PathVariable Integer typeId) {
        ModelAndView mv = new ModelAndView("listproduct");
        ProductType productType = campingService.findProductTypeById(typeId);
        mv.addObject("productType", productType);
        if (productType != null) {
            mv.addObject("products", campingService.findProductsByProductType(productType));
        }
        return mv;
    }
    
    // ========== ระบบจัดการ Admin (ใช้ Session) ==========
    
    // หน้า Admin Dashboard - GET
    @GetMapping("/admin/dashboard")
    public ModelAndView adminDashboard(HttpSession session) {
        User user = (User) session.getAttribute("user");
        // เปลี่ยนจาก .equals เป็น .equalsIgnoreCase เพื่อความยืดหยุ่น
        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) { 
            return new ModelAndView("redirect:/login");
        }
        
        ModelAndView mv = new ModelAndView("admin-dashboard");
        mv.addObject("users", campingService.findAllUsers());
        mv.addObject("products", campingService.findAllProducts());
        mv.addObject("orders", campingService.findAllOrders());
        mv.addObject("productTypes", campingService.findAllProductTypes());
        // ไม่ต้อง addObject user เพราะหน้า JSP จะดึงจาก SessionScope อยู่แล้ว
        return mv;
    }
    // จัดการบทบาทผู้ใช้
    @PostMapping("/admin/user/role")
    public ModelAndView updateUserRole(@RequestParam Integer userId,
                                       @RequestParam String role) {
        User user = campingService.findUserById(userId);
        if (user != null) {
            user.setRole(role);
            campingService.saveUser(user);
        }
        return new ModelAndView("redirect:/admin/dashboard");
    }
   
    // ลบผู้ใช้
    @PostMapping("/admin/user/delete")
    public ModelAndView deleteUser(@RequestParam Integer userId) {
        campingService.deleteUserById(userId);
        return new ModelAndView("redirect:/admin/dashboard");
    }
   
    // อัพเดทสต็อกสินค้า
    @PostMapping("/admin/stock/update")
    public ModelAndView updateStock(@RequestParam Integer productId,
                                   @RequestParam Integer quantity) {
        Product product = campingService.findProductById(productId);
        if (product != null) {
            Stock stock = campingService.findStockByProduct(product);
            if (stock == null) {
                stock = new Stock();
                stock.setProduct(product);
            }
            stock.setQty(quantity);
            campingService.saveStock(stock);
        }
        return new ModelAndView("redirect:/admin/dashboard");
    }
   
    // เพิ่มสินค้าใหม่
    @PostMapping("/admin/product/add")
    public ModelAndView addProduct(@RequestParam String productName,
                                  @RequestParam Double price,
                                  @RequestParam String description,
                                  @RequestParam Integer productTypeId,
                                  @RequestParam Integer stockQuantity) {
        ProductType productType = campingService.findProductTypeById(productTypeId);
   
        Product product = new Product();
        product.setProductName(productName);
        product.setPrice(BigDecimal.valueOf(price));
        product.setDescription(description);
        product.setProductType(productType);
   
        Product savedProduct = campingService.saveProduct(product);
   
        // สร้างสต็อก
        Stock stock = new Stock();
        stock.setProduct(savedProduct);
        stock.setQty(stockQuantity);
        campingService.saveStock(stock);
   
        return new ModelAndView("redirect:/admin/dashboard");
    }
   
    // ลบสินค้า
    @PostMapping("/admin/product/delete")
    public ModelAndView deleteProduct(@RequestParam Integer productId) {
        campingService.deleteProductById(productId);
        return new ModelAndView("redirect:/admin/dashboard");
    }
}