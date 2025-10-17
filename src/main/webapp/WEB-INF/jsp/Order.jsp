<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>ประวัติการสั่งซื้อ - Camping Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .welcome-message {
            background: linear-gradient(45deg, #28a745, #20c997);
            color: white; padding: 15px; border-radius: 10px;
            margin-bottom: 20px; text-align: center;
        }
        .order-card { border-left: 5px solid #007bff; margin-bottom: 20px; }
        .order-detail-card { border-left: 5px solid #28a745; }
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/orders">ประวัติการสั่งซื้อ</a>
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
                <h3>📦 ประวัติการสั่งซื้อ</h3>
                <p class="mb-0">รายการสั่งซื้อทั้งหมดของคุณ</p>
            </div>
        </div>
    </c:if>

    <div class="container mt-4">
        <c:choose>
            <%-- Case 1: แสดงรายละเอียดออร์เดอร์เดียว (หลังกดสั่งซื้อสำเร็จ) --%>
            <c:when test="${not empty order && empty orders}">
                <div class="card order-detail-card">
                    <div class="card-header bg-success text-white"><h4 class="mb-0">✅ สั่งซื้อสำเร็จ</h4></div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <h5>ข้อมูลออร์เดอร์</h5>
                                <p><strong>หมายเลขออร์เดอร์:</strong> #${order.orderid}</p>
                                <p><strong>วันที่สั่งซื้อ:</strong> ${order.orderdate}</p>
                                <p><strong>ยอดรวม:</strong> ฿<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></p>
                            </div>
                            <div class="col-md-6">
                                <h5>ข้อมูลการจัดส่ง</h5>
                                <p><strong>ชื่อ:</strong> ${order.user.fullname}</p>
                                <p><strong>ที่อยู่:</strong> ${order.user.addresss}</p>
                                <p><strong>โทรศัพท์:</strong> ${order.user.phone}</p>
                            </div>
                        </div>
                        <hr>
                        <h5>รายการสินค้า</h5>
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr><th>สินค้า</th><th>ราคา</th><th>จำนวน</th><th>รวม</th></tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="detail" items="${orderDetails}">
                                        <tr>
                                            <td>${detail.product.productName}</td>
                                            <td>฿<fmt:formatNumber value="${detail.price}" pattern="#,##0.00"/></td>
                                            <td>${detail.quantity}</td>
                                            <td>฿<fmt:formatNumber value="${detail.subtotal}" pattern="#,##0.00"/></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                                <tfoot>
                                    <tr>
                                        <td colspan="3" class="text-end"><strong>ยอดรวม:</strong></td>
                                        <td><strong>฿<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></strong></td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                        <div class="text-center mt-4">
                            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">ช้อปปิ้งต่อ</a>
                            <a href="${pageContext.request.contextPath}/orders" class="btn btn-outline-secondary">ดูประวัติการสั่งซื้อทั้งหมด</a>
                        </div>
                    </div>
                </div>
            </c:when>
            
            <%-- Case 2: แสดงประวัติออร์เดอร์ทั้งหมด --%>
            <c:when test="${not empty orders}">
                <h2>ประวัติการสั่งซื้อทั้งหมด</h2>
                <c:choose>
                    <c:when test="${orders.size() > 0}">
                        <c:forEach var="o" items="${orders}">
                            <div class="card order-card mb-3">
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-8">
                                            <h5>ออร์เดอร์ #${o.orderid}</h5>
                                            <p class="mb-1"><strong>วันที่:</strong> ${o.orderdate}</p>
                                            <p class="mb-1"><strong>ยอดรวม:</strong> ฿<fmt:formatNumber value="${o.totalAmount}" pattern="#,##0.00"/></p>
                                        </div>
                                        <div class="col-md-4 text-end">
                                            <a href="${pageContext.request.contextPath}/order/${o.orderid}" class="btn btn-info">ดูรายละเอียด</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-info text-center">
                            <h4>ไม่มีประวัติการสั่งซื้อ</h4>
                            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">ช้อปปิ้งเลย</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </c:when>
            
            <%-- Case 3: ไม่พบข้อมูล --%>
            <c:otherwise>
                <div class="alert alert-warning text-center"><h4>ไม่พบข้อมูลออร์เดอร์</h4></div>
            </c:otherwise>
        </c:choose>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>