<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.ComboDAO0" %>
<%@ page import="model.Combo0" %>
<%@ page import="model.Manager0" %>
<%
    request.setCharacterEncoding("UTF-8");
    Manager0 manager = (Manager0) session.getAttribute("manager");
    if (manager == null) {
        response.sendRedirect("gdLogin0.jsp");
        return;
    }

    Combo0 combo = (Combo0) session.getAttribute("combo");
    boolean result = false;
    String message = null;

    if (combo == null || combo.getDsComboDetail() == null || combo.getDsComboDetail().isEmpty()) {
        message = "Lỗi: Chưa chọn món ăn nào vào combo!";
    } else {
        String txtComboName = request.getParameter("txtComboName");
        String txtComboPrice = request.getParameter("txtComboPrice");
        String txtComboImage = request.getParameter("txtComboImage");
        String txtDescription = request.getParameter("txtDescription");

        try {
            combo.setName(txtComboName);
            combo.setPrice(Float.parseFloat(txtComboPrice != null ? txtComboPrice.trim() : "0"));
            combo.setImage(txtComboImage != null ? txtComboImage.trim() : "");
            combo.setDescription(txtDescription != null ? txtDescription.trim() : "");

            ComboDAO0 comboDAO = new ComboDAO0();
            result = comboDAO.addCombo(combo);

            if (result) {
                session.removeAttribute("combo");
                message = "Thêm combo thành công!";
            } else {
                message = "Thêm combo thất bại! Vui lòng thử lại.";
            }
        } catch (Exception e) {
            result = false;
            message = "Lỗi dữ liệu: " + e.getMessage();
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Kết quả thêm combo - RestMan</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <h2>KẾT QUẢ THÊM MENU COMBO</h2>

        <% if (result) { %>
            <div class="msg-success">
                <%= message %>
            </div>
            <p style="text-align: center; color: #495057;">Combo đã được ghi nhận vào cơ sở dữ liệu hệ thống.</p>
        <% } else { %>
            <div class="msg-error">
                <%= message %>
            </div>
        <% } %>

        <div class="action-box">
            <a href="gdManageCombo0.jsp" class="btn btn-primary">Quay lại Quản lí combo</a>
        </div>
    </div>
</body>
</html>
