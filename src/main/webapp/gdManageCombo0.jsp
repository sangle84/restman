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

    ComboDAO0 comboDAO = new ComboDAO0();
    Combo0[] listCombo = comboDAO.getAllCombo();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lí combo - RestMan</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <h2>QUẢN LÍ MENU COMBO</h2>

        <div style="margin-bottom: 20px; text-align: right;">
            <form action="gdAddCombo0.jsp" method="get" style="display: inline-block;">
                <input type="submit" id="btnAddCombo" name="btnAddCombo" value="Thêm combo mới" class="btn btn-primary">
            </form>
        </div>

        <table id="tblCombo" border="1" cellpadding="8" cellspacing="0">
            <thead>
                <tr>
                    <th class="text-center" style="width: 100px;">Mã combo</th>
                    <th style="width: 250px;">Tên combo</th>
                    <th class="text-right" style="width: 140px;">Giá bán</th>
                    <th>Mô tả</th>
                </tr>
            </thead>
            <tbody>
            <%
                if (listCombo != null && listCombo.length > 0) {
                    for (Combo0 c : listCombo) {
            %>
                <tr>
                    <td class="text-center"><%= c.getId() %></td>
                    <td><b><%= c.getName() %></b></td>
                    <td class="text-right price-text"><%= String.format("%,.0f đ", c.getPrice()) %></td>
                    <td style="color: #495057;"><%= c.getDescription() %></td>
                </tr>
            <%
                    }
                } else {
            %>
                <tr>
                    <td colspan="4" class="text-center" style="color: #6c757d; padding: 24px;">Chưa có combo nào trong hệ thống!</td>
                </tr>
            <%
                }
            %>
            </tbody>
        </table>

        <div class="back-box">
            <a id="btnBack" href="gdManagerHome0.jsp" class="btn btn-secondary">Quay lại</a>
        </div>
    </div>
</body>
</html>
