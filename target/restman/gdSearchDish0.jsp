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

    String txtDishName = request.getParameter("txtDishName");
    Dish0[] listDish = null;

    if (request.getParameter("btnSearch") != null || txtDishName != null) {
        DishDAO0 dishDAO = new DishDAO0();
        listDish = dishDAO.searchDishByName(txtDishName);
        session.setAttribute("listDish", listDish);
    } else {
        listDish = (Dish0[]) session.getAttribute("listDish");
        if (listDish == null) {
            DishDAO0 dishDAO = new DishDAO0();
            listDish = dishDAO.searchDishByName("");
            session.setAttribute("listDish", listDish);
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tìm kiếm món ăn - RestMan</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <h2>TÌM KIẾM MÓN ĂN</h2>

        <form action="gdSearchDish0.jsp" method="get" class="search-form">
            <label for="txtDishName">Tên món ăn:</label>
            <input type="text" id="txtDishName" name="txtDishName" value="<%= (txtDishName != null ? txtDishName : "") %>" placeholder="Nhập tên món ăn..." size="30">
            <input type="submit" id="btnSearch" name="btnSearch" value="Tìm kiếm" class="btn btn-primary">
        </form>

        <table id="tblDish" border="1" cellpadding="8" cellspacing="0">
            <thead>
                <tr>
                    <th class="text-center" style="width: 80px;">Mã món</th>
                    <th>Tên món</th>
                    <th class="text-center" style="width: 130px;">Hình ảnh</th>
                    <th class="text-right" style="width: 120px;">Giá bán</th>
                    <th class="text-center" style="width: 120px;">Thao tác</th>
                </tr>
            </thead>
            <tbody>
            <%
                if (listDish != null && listDish.length > 0) {
                    for (Dish0 d : listDish) {
            %>
                <tr>
                    <td class="text-center"><%= d.getId() %></td>
                    <td><b><%= d.getName() %></b></td>
                    <td class="text-center"><%= d.getImage() %></td>
                    <td class="text-right price-text"><%= String.format("%,.0f đ", d.getPrice()) %></td>
                    <td class="text-center">
                        <a id="selectDish_<%=d.getId()%>" href="gdDishDetail0.jsp?id=<%=d.getId()%>" class="btn-link">Xem chi tiết</a>
                    </td>
                </tr>
            <%
                    }
                } else {
            %>
                <tr>
                    <td colspan="5" class="text-center" style="color: #6c757d; padding: 24px;">Không tìm thấy món ăn nào phù hợp!</td>
                </tr>
            <%
                }
            %>
            </tbody>
        </table>

        <div class="back-box">
            <a id="btnBack" href="gdCustomerHome0.jsp" class="btn btn-secondary">Quay lại</a>
        </div>
    </div>
</body>
</html>
