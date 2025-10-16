<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 50px; }
        form { max-width: 400px; margin: 0 auto; }
        input[type="text"], input[type="password"], input[type="email"], textarea, select { width: 100%; padding: 10px; margin: 10px 0; }
        input[type="submit"] { width: 100%; padding: 10px; background: #28a745; color: white; border: none; cursor: pointer; }
        .error { color: red; }
    </style>
</head>
<body>
    <h2>Login</h2>
    <form action="${pageContext.request.contextPath}/register" method="post">
        <label for="username">Username:</label>
        <input type="text" id="username" name="username" required>
        
        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required>
        
        <label for="fullname">Full Name:</label>
        <input type="text" id="fullname" name="fullname" required>
        
        <label for="address">Address:</label>
        <textarea id="address" name="address" rows="3"></textarea>
        
        <label for="email">Email:</label>
        <input type="email" id="email" name="email">
        
        <label for="role">Role:</label>
        <select id="role" name="role">
            <option value="user">User</option>
            <option value="admin">Admin</option>
        </select>
        
        <label for="phone">Phone:</label>
        <input type="text" id="phone" name="phone">
        
        <input type="submit" value="Register">
    </form>
    <p><a href="${pageContext.request.contextPath}/login">Login</a></p>
    <% if (request.getAttribute("error") != null) { %>
        <p class="error"><%= request.getAttribute("error") %></p>
    <% } %>
    <% if (request.getAttribute("success") != null) { %>
        <p style="color: green;">Registration successful! <a href="${pageContext.request.contextPath}/login">Login here</a></p>
    <% } %>
</body>
</html>