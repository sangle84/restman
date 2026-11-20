<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.UserDAO0" %>
<%@ page import="model.User0" %>
<%@ page import="model.Customer0" %>
<%@ page import="model.Manager0" %>
<%
    request.setCharacterEncoding("UTF-8");
    String errorMessage = null;

    // Xử lý đăng xuất nếu có yêu cầu
    String action = request.getParameter("action");
    if ("logout".equals(action)) {
        session.invalidate();
        response.sendRedirect("gdLogin0.jsp");
        return;
    }

    // Xử lý khi nhấn nút Đăng nhập
    if (request.getParameter("btnLogin") != null) {
        String txtUsername = request.getParameter("txtUsername");
        String txtPassword = request.getParameter("txtPassword");

        UserDAO0 userDAO = new UserDAO0();
        User0 user = userDAO.checkLogin(txtUsername, txtPassword);

        if (user instanceof Customer0) {
            Customer0 customer = (Customer0) user;
            session.setAttribute("customer", customer);
            response.sendRedirect("gdCustomerHome0.jsp");
            return;
        } else if (user instanceof Manager0) {
            Manager0 manager = (Manager0) user;
            session.setAttribute("manager", manager);
            response.sendRedirect("gdManagerHome0.jsp");
            return;
        } else {
            errorMessage = "Tên đăng nhập hoặc mật khẩu không chính xác!";
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập - RestMan</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container" style="max-width: 480px;">
        <h2>ĐĂNG NHẬP RESTMAN</h2>

        <% if (errorMessage != null) { %>
            <div class="msg-error">
                <%= errorMessage %>
            </div>
        <% } %>

        <form action="gdLogin0.jsp" method="post">
            <div class="form-grid" style="grid-template-columns: 120px 1fr; margin-bottom: 20px;">
                <label for="txtUsername">Tên đăng nhập:</label>
                <input type="text" id="txtUsername" name="txtUsername" required placeholder="Nhập tên đăng nhập...">

                <label for="txtPassword">Mật khẩu:</label>
                <input type="password" id="txtPassword" name="txtPassword" required placeholder="Nhập mật khẩu...">

                <div class="form-submit">
                    <input type="submit" id="btnLogin" name="btnLogin" value="Đăng nhập" class="btn btn-primary" style="width: 100%;">
                </div>
            </div>
        </form>

        <div style="background-color: #f8f9fa; border: 1px dashed #ced4da; border-radius: 4px; padding: 12px 16px; margin-top: 24px; font-size: 13px; color: #495057;">
            <p style="font-weight: 600; margin-bottom: 6px;">Tài khoản mẫu từ CSDL:</p>
            <p>• Khách hàng: <code>customer1</code> / Mật khẩu: <code>123456</code></p>
            <p>• Quản lý: <code>manager1</code> / Mật khẩu: <code>123456</code></p>
        </div>
    </div>
</body>
</html>
