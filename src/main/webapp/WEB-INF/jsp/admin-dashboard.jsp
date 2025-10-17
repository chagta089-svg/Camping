<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin Dashboard - Camping Store</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">🏕️ Camping Store - Admin</a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="${pageContext.request.contextPath}/">หน้าหลัก</a> 
                <span class="navbar-text">สวัสดี, <c:out value="${sessionScope.user.fullname}"/></span>
                <a class="nav-link" href="${pageContext.request.contextPath}/logout">ออกจากระบบ</a>
            </div>
        </div>
    </nav>

    <div class="container-fluid mt-4">
        <h2>Admin Dashboard</h2>

        <div class="row">
            <div class="col-md-3"><div class="card text-white bg-primary"><div class="card-body"><h5 class="card-title">ผู้ใช้ทั้งหมด</h5><p class="card-text display-6"><c:out value="${users.size()}"/></p></div></div></div>
            <div class="col-md-3"><div class="card text-white bg-success"><div class="card-body"><h5 class="card-title">สินค้าทั้งหมด</h5><p class="card-text display-6"><c:out value="${products.size()}"/></p></div></div></div>
            <div class="col-md-3"><div class="card text-white bg-warning"><div class="card-body"><h5 class="card-title">ออร์เดอร์ทั้งหมด</h5><p class="card-text display-6"><c:out value="${orders.size()}"/></p></div></div></div>
            <div class="col-md-3"><div class="card text-white bg-info"><div class="card-body"><h5 class="card-title">จัดการระบบ</h5><p>ด้านล่างนี้</p></div></div></div>
        </div>

        <div class="card mt-4">
            <div class="card-header"><h5>ผู้ใช้ทั้งหมด</h5></div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped">
                        <thead>
                            <tr><th>ID</th><th>ชื่อผู้ใช้</th><th>ชื่อ-นามสกุล</th><th>อีเมล</th><th>บทบาท</th><th>การจัดการ</th></tr>
                        </thead>
                        <tbody>
                            <c:forEach var="u" items="${users}">
                                <tr>
                                    <td><c:out value="${u.userid}"/></td>
                                    <td><c:out value="${u.username}"/></td>
                                    <td><c:out value="${u.fullname}"/></td>
                                    <td><c:out value="${u.email}"/></td>
                                    <td><span class="badge ${u.role == 'ADMIN' ? 'bg-danger' : 'bg-primary'}"><c:out value="${u.role}"/></span></td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/admin/user/role" method="post" class="d-inline">
                                            <input type="hidden" name="userId" value="${u.userid}">
                                            <select name="role" class="form-select form-select-sm d-inline" style="width: auto;" onchange="this.form.submit()">
                                                <option value="USER" ${u.role == 'USER' ? 'selected' : ''}>USER</option>
                                                <option value="ADMIN" ${u.role == 'ADMIN' ? 'selected' : ''}>ADMIN</option>
                                            </select>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/admin/user/delete" method="post" class="d-inline">
                                            <input type="hidden" name="userId" value="${u.userid}">
                                            <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('ยืนยันการลบผู้ใช้?')">ลบ</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="card mt-4">
            <div class="card-header">
                <h5>สินค้าทั้งหมด</h5>
                <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#addProductModal">+ เพิ่มสินค้า</button>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped">
                        <thead>
                            <tr><th>ID</th><th>ชื่อสินค้า</th><th>ราคา</th><th>ประเภท</th><th>สต็อก</th><th>การจัดการ</th></tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${products}">
                                <tr>
                                    <td><c:out value="${p.productId}"/></td>
                                    <td><c:out value="${p.productName}"/></td>
                                    <td>฿<fmt:formatNumber value="${p.price}" pattern="#,##0.00"/></td>
                                    <td><c:out value="${p.productType.typeName}"/></td>
                                    <td>
                                        <span class="badge ${not empty p.stocks && p.stocks[0].qty > 0 ? 'bg-success' : 'bg-danger'}">
                                            <c:out value="${not empty p.stocks ? p.stocks[0].qty : '0'}"/> ชิ้น
                                        </span>
                                    </td>
                                    <td>
                                        <button class="btn btn-sm btn-info" data-bs-toggle="modal" data-bs-target="#stockModal${p.productId}">จัดการสต็อก</button>
                                        <form action="${pageContext.request.contextPath}/admin/product/delete" method="post" class="d-inline">
                                            <input type="hidden" name="productId" value="${p.productId}">
                                            <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('ยืนยันการลบสินค้า?')">ลบ</button>
                                        </form>
                                    </td>
                                </tr>

                                <div class="modal fade" id="stockModal${p.productId}" tabindex="-1">
                                    <div class="modal-dialog">
                                        <div class="modal-content">
                                            <div class="modal-header"><h5 class="modal-title">จัดการสต็อก: ${p.productName}</h5></div>
                                            <form action="${pageContext.request.contextPath}/admin/stock/update" method="post">
                                                <div class="modal-body">
                                                    <input type="hidden" name="productId" value="${p.productId}">
                                                    <label for="quantity${p.productId}" class="form-label">จำนวนสต็อกใหม่</label>
                                                    <input type="number" class="form-control" id="quantity${p.productId}" name="quantity" value="${not empty p.stocks ? p.stocks[0].qty : '0'}" min="0" required>
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">ปิด</button>
                                                    <button type="submit" class="btn btn-primary">อัพเดท</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="addProductModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header"><h5 class="modal-title">เพิ่มสินค้าใหม่</h5></div>
                <form action="${pageContext.request.contextPath}/admin/product/add" method="post">
                    <div class="modal-body">
                        <div class="mb-3"><label class="form-label">ชื่อสินค้า</label><input type="text" class="form-control" name="productName" required></div>
                        <div class="mb-3"><label class="form-label">ราคา</label><input type="number" class="form-control" name="price" step="0.01" min="0" required></div>
                        <div class="mb-3"><label class="form-label">คำอธิบาย</label><textarea class="form-control" name="description" rows="3"></textarea></div>
                        <div class="mb-3">
                            <label class="form-label">ประเภทสินค้า</label>
                            <select class="form-select" name="productTypeId" required>
                                <option value="">เลือกประเภทสินค้า</option>
                                <c:forEach var="pt" items="${productTypes}"><option value="${pt.productTypeid}">${pt.typeName}</option></c:forEach>
                            </select>
                        </div>
                        <div class="mb-3"><label class="form-label">จำนวนสต็อกเริ่มต้น</label><input type="number" class="form-control" name="stockQuantity" value="0" min="0" required></div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">ปิด</button>
                        <button type="submit" class="btn btn-primary">เพิ่มสินค้า</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>