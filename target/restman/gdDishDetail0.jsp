<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.DishDAO0" %>
<%@ page import="model.Dish0" %>
<%@ page import="model.Customer0" %>
<%
    request.setCharacterEncoding("UTF-8");
    Customer0 customer = (Customer0) session.getAttribute("customer");
    if (customer == null) {
        response.sendRedirect("gdLogin0.jsp");
        return;
    }

    String idParam = request.getParameter("id");
    Dish0 dish = null;
    if (idParam != null && !idParam.trim().isEmpty()) {
        int id = Integer.parseInt(idParam.trim());
        DishDAO0 dishDAO = new DishDAO0();
        dish = dishDAO.getDishById(id);
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi tiết món ăn - RestMan</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <h2>CHI TIẾT MÓN ĂN</h2>

        <% if (dish != null) { %>
            <table class="detail-table">
                <tr>
                    <td>Mã món:</td>
                    <td><span id="dishId"><b><%= dish.getId() %></b></span></td>
                </tr>
                <tr>
                    <td>Tên món:</td>
                    <td><span id="dishName" style="font-size: 16px; font-weight: 600; color: #1a252f;"><%= dish.getName() %></span></td>
                </tr>
                <tr>
                    <td>Hình ảnh:</td>
                    <td><span id="dishImage"><%= dish.getImage() %></span></td>
                </tr>
                <tr>
                    <td>Giá bán:</td>
                    <td><span id="dishPrice" class="price-text" style="font-size: 16px;"><%= String.format("%,.0f đ", dish.getPrice()) %></span></td>
                </tr>
                <tr>
                    <td>Mô tả:</td>
                    <td><span id="dishDescription" style="color: #495057;"><%= dish.getDescription() %></span></td>
                </tr>
            </table>
        <% } else { %>
            <p class="msg-error">Không tìm thấy thông tin món ăn!</p>
        <% } %>

        <div class="back-box">
            <a id="btnBack" href="gdSearchDish0.jsp" class="btn btn-secondary">Quay lại</a>
        </div>
    </div>
</body>
</html>
