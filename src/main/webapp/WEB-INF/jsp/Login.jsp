<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>เข้าสู่ระบบ - Camping Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h4 class="text-center">เข้าสู่ระบบ</h4>
                    </div>
                    <div class="card-body">
                        <!-- Error Message -->
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger" role="alert">
                                <c:out value="${error}"/>
                            </div>
                        </c:if>
                        
                        <!-- Success Message (from register) -->
                        <c:if test="${not empty success}">
                            <div class="alert alert-success" role="alert">
                                <c:out value="${success}"/>
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/login" method="post">
                            <div class="mb-3">
                                <label for="username" class="form-label">ชื่อผู้ใช้</label>
                                <input type="text" class="form-control" id="username" name="username" required>
                            </div>
                            <div class="mb-3">
                                <label for="password" class="form-label">รหัสผ่าน</label>
                                <input type="password" class="form-control" id="password" name="password" required>
                            </div>
                            <button type="submit" class="btn btn-primary w-100">เข้าสู่ระบบ</button>
                        </form>
                        
                        <div class="text-center mt-3">
                            <p>ยังไม่มีบัญชี? <a href="${pageContext.request.contextPath}/register">สมัครสมาชิก</a></p>
                            <a href="${pageContext.request.contextPath}/">← กลับสู่หน้าหลัก</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>