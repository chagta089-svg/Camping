<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>สมัครสมาชิก - Camping Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">
                        <h4 class="text-center">สมัครสมาชิก</h4>
                    </div>
                    <div class="card-body">
                        <!-- Error Message -->
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger" role="alert">
                                <c:out value="${error}"/>
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/register" method="post">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="username" class="form-label">ชื่อผู้ใช้ *</label>
                                        <input type="text" class="form-control" id="username" name="username" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="password" class="form-label">รหัสผ่าน *</label>
                                        <input type="password" class="form-control" id="password" name="password" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="confirmPassword" class="form-label">ยืนยันรหัสผ่าน *</label>
                                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="fullname" class="form-label">ชื่อ-นามสกุล *</label>
                                        <input type="text" class="form-control" id="fullname" name="fullname" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="email" class="form-label">อีเมล</label>
                                        <input type="email" class="form-control" id="email" name="email">
                                    </div>
                                    <div class="mb-3">
                                        <label for="phone" class="form-label">โทรศัพท์</label>
                                        <input type="tel" class="form-control" id="phone" name="phone">
                                    </div>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label for="addresss" class="form-label">ที่อยู่</label>
                                <textarea class="form-control" id="addresss" name="addresss" rows="3"></textarea>
                            </div>
                            <button type="submit" class="btn btn-primary w-100">สมัครสมาชิก</button>
                        </form>
                        
                        <div class="text-center mt-3">
                            <p>มีบัญชีอยู่แล้ว? <a href="${pageContext.request.contextPath}/login">เข้าสู่ระบบ</a></p>
                            <a href="${pageContext.request.contextPath}/">← กลับสู่หน้าหลัก</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>