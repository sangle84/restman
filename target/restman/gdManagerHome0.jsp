<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Manager0" %>
<%
    Manager0 manager = (Manager0) session.getAttribute("manager");
    if (manager == null) {
        response.sendRedirect("gdLogin0.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Trang chủ Quản lý - RestMan</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <h2>TRANG CHỦ QUẢN LÝ</h2>

        <p class="welcome-text">Xin chào Quản lý: <b><%= manager.getName() %></b></p>

        <div class="action-box">
            <a id="btnManageCombo" href="gdManageCombo0.jsp" class="btn btn-primary">Quản lí combo</a>
        </div>

        <div class="logout-box">
            <a href="gdLogin0.jsp?action=logout" class="btn btn-secondary">Đăng xuất</a>
        </div>
    </div>
</body>
</html>
