<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Customer0" %>
<%
    Customer0 customer = (Customer0) session.getAttribute("customer");
    if (customer == null) {
        response.sendRedirect("gdLogin0.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Trang chủ Khách hàng - RestMan</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <h2>TRANG CHỦ KHÁCH HÀNG</h2>
        
        <p class="welcome-text">Xin chào khách hàng: <b><%= customer.getName() %></b></p>

        <div class="action-box">
            <a id="btnSearchDish" href="gdSearchDish0.jsp" class="btn btn-primary">Tìm kiếm món ăn</a>
        </div>

        <div class="logout-box">
            <a href="gdLogin0.jsp?action=logout" class="btn btn-secondary">Đăng xuất</a>
        </div>
    </div>
</body>
</html>
