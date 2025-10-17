<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Camping Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .product-type-card {
            transition: transform 0.3s;
            margin-bottom: 20px;
        }
        .product-type-card:hover {
            transform: translateY(-5px);
        }
        .hero-section {
            background: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.5)), url('https://via.placeholder.com/1500x500');
            background-size: cover;
            color: white;
            padding: 100px 0;
            text-align: center;
        }
        .welcome-message {
            background: linear-gradient(45deg, #28a745, #20c997);
            color: white;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            text-align: center;
        }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/">🏕️ Camping Store</a>
        <div class="navbar-nav ms-auto">
            <a class="nav-link" href="${pageContext.request.contextPath}/">หน้าแรก</a>
            <c:choose>
                <c:when test="${empty sessionScope.user}">
                    <a class="nav-link" href="${pageContext.request.contextPath}/login">เข้าสู่ระบบ</a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/register">สมัครสมาชิก</a>
                </c:when>
                <c:otherwise>
                    <%-- ## เพิ่มส่วนนี้เข้ามา ## --%>
                    <%-- ตรวจสอบว่าเป็น ADMIN หรือไม่ ถ้าใช่ ให้แสดงลิงก์ไปหน้า Dashboard --%>
                    <c:if test="${sessionScope.user.role.equalsIgnoreCase('ADMIN')}">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard" style="color: #ffc107;">⚙️ แผงควบคุม</a>
                    </c:if>
                
                    <a class="nav-link" href="${pageContext.request.contextPath}/cart">ตะกร้าสินค้า</a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/orders">ประวัติการสั่งซื้อ</a>
                    <span class="navbar-text">สวัสดี, <c:out value="${sessionScope.user.fullname}"/></span>
                    <a class="nav-link" href="${pageContext.request.contextPath}/logout">ออกจากระบบ</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</nav>

    <div class="hero-section">
        <div class="container">
            <h1>ยินดีต้อนรับสู่ร้านขายอุปกรณ์แคมป์ปิ้ง</h1>
            <p class="lead">ค้นหาอุปกรณ์แคมป์ปิ้งที่คุณต้องการ</p>
        </div>
    </div>

    <c:if test="${not empty sessionScope.user}">
        <div class="container mt-4">
            <div class="welcome-message">
                <h3>🎉 ยินดีต้อนรับ, <c:out value="${sessionScope.user.fullname}"/>!</h3>
                <p class="mb-0">คุณได้เข้าสู่ระบบเรียบร้อยแล้ว สามารถช้อปปิ้งสินค้าได้เลย</p>
            </div>
        </div>
    </c:if>

    <div class="container mt-5">
        <h2 class="text-center mb-4">ประเภทสินค้า</h2>
        <div class="row">
            <c:forEach var="productType" items="${productTypes}">
                <div class="col-md-4">
                    <div class="card product-type-card">
                        <img src="https://via.placeholder.com/300x200?text=${productType.typeName}" class="card-img-top" alt="${productType.typeName}">
                        <div class="card-body">
                            <h5 class="card-title"><c:out value="${productType.typeName}"/></h5>
                            <p class="card-text">สินค้าจำนวน: 
                                <c:choose>
                                    <c:when test="${not empty productType.products}">
                                        <c:out value="${productType.products.size()}"/>
                                    </c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                                รายการ
                            </p>
                            <a href="${pageContext.request.contextPath}/products/${productType.productTypeid}" class="btn btn-primary">ดูสินค้า</a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <c:if test="${not empty loginSuccess}">
        <div class="container mt-3">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <strong>สำเร็จ!</strong> เข้าสู่ระบบสำเร็จ! ยินดีต้อนรับ <c:out value="${sessionScope.user.fullname}"/>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </div>
    </c:if>

    <c:if test="${not empty logoutSuccess}">
        <div class="container mt-3">
            <div class="alert alert-info alert-dismissible fade show" role="alert">
                ออกจากระบบสำเร็จ
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </div>
    </c:if>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>