<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Products - Camping Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .product-card {
            transition: transform 0.3s;
            margin-bottom: 20px;
            height: 100%;
        }
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .product-image { height: 200px; object-fit: cover; }
        .price { color: #e74c3c; font-weight: bold; font-size: 1.2em; }
        .stock-info { font-size: 0.9em; }
        .in-stock { color: #28a745; }
        .out-of-stock { color: #dc3545; }
        .welcome-message {
            background: linear-gradient(45deg, #28a745, #20c997);
            color: white; padding: 15px; border-radius: 10px;
            margin-bottom: 20px; text-align: center;
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/cart">ตะกร้าสินค้า</a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/orders">ประวัติการสั่งซื้อ</a>
                        <span class="navbar-text">สวัสดี, <c:out value="${sessionScope.user.fullname}"/></span>
                        <a class="nav-link" href="${pageContext.request.contextPath}/logout">ออกจากระบบ</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </nav>

    <c:if test="${not empty sessionScope.user}">
        <div class="container mt-4">
            <div class="welcome-message">
                <h3>🎉 ยินดีต้อนรับ, <c:out value="${sessionScope.user.fullname}"/>!</h3>
                <p class="mb-0">คุณได้เข้าสู่ระบบเรียบร้อยแล้ว สามารถช้อปปิ้งสินค้าได้เลย</p>
            </div>
        </div>
    </c:if>

    <div class="container mt-4">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">หน้าแรก</a></li>
                <c:if test="${not empty productType}">
                    <li class="breadcrumb-item active" aria-current="page"><c:out value="${productType.typeName}"/></li>
                </c:if>
            </ol>
        </nav>
        <h1>
            <c:choose>
                <c:when test="${not empty productType}">สินค้าประเภท: <c:out value="${productType.typeName}"/></c:when>
                <c:otherwise>สินค้าทั้งหมด</c:otherwise>
            </c:choose>
        </h1>
    </div>

    <div class="container mt-4">
        <div class="row">
            <c:choose>
                <c:when test="${not empty products && products.size() > 0}">
                    <c:forEach var="product" items="${products}">
                        <div class="col-md-4 col-lg-3">
                            <div class="card product-card">
                                <img src="https://via.placeholder.com/300x200?text=${product.productName}" class="card-img-top product-image" alt="${product.productName}">
                                <div class="card-body d-flex flex-column">
                                    <h5 class="card-title"><c:out value="${product.productName}"/></h5>
                                    <p class="card-text flex-grow-1">
                                        <small class="text-muted">
                                            <c:out value="${not empty product.description ? product.description : 'ไม่มีคำอธิบาย'}"/>
                                        </small>
                                    </p>
                                    <div class="mt-auto">
                                        <div class="price mb-2">฿<fmt:formatNumber value="${product.price}" pattern="#,##0.00"/></div>
                                        <div class="stock-info mb-2">
                                            <c:choose>
                                                <c:when test="${not empty product.stocks && product.stocks[0].qty > 0}">
                                                    <span class="in-stock">📦 มีสินค้า <strong><c:out value="${product.stocks[0].qty}"/></strong> ชิ้น</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="out-of-stock">❌ สินค้าหมด</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        
                                        <c:if test="${not empty sessionScope.user}">
                                            <form action="${pageContext.request.contextPath}/cart/add" method="post" class="mt-2">
                                                <input type="hidden" name="productId" value="${product.productId}">
                                                <div class="input-group input-group-sm">
                                                    <input type="number" name="quantity" value="1" min="1" 
                                                        <c:if test="${not empty product.stocks && product.stocks[0].qty > 0}">max="${product.stocks[0].qty}"</c:if>
                                                        class="form-control" style="max-width: 80px;">
                                                    <button type="submit" class="btn btn-success btn-sm" <c:if test="${empty product.stocks || product.stocks[0].qty == 0}">disabled</c:if>>
                                                        🛒 เพิ่มตะกร้า
                                                    </button>
                                                </div>
                                            </form>
                                        </c:if>
                                        <c:if test="${empty sessionScope.user}">
                                            <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-primary btn-sm w-100">
                                                เข้าสู่ระบบเพื่อซื้อ
                                            </a>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="col-12">
                        <div class="alert alert-info text-center">
                            <h4>ไม่พบสินค้าในประเภทนี้</h4>
                            <p>กรุณาเลือกประเภทสินค้าอื่น</p>
                            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">กลับสู่หน้าหลัก</a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <footer class="bg-dark text-white mt-5 py-4">
        <div class="container text-center"><p>&copy; 2024 Camping Store. All rights reserved.</p></div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>