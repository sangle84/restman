<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.CategoryDAO0" %>
<%@ page import="dao.DishDAO0" %>
<%@ page import="model.Category0" %>
<%@ page import="model.Combo0" %>
<%@ page import="model.ComboDetail0" %>
<%@ page import="model.Dish0" %>
<%@ page import="model.Manager0" %>
<%
    request.setCharacterEncoding("UTF-8");
    Manager0 manager = (Manager0) session.getAttribute("manager");
    if (manager == null) {
        response.sendRedirect("gdLogin0.jsp");
        return;
    }

    // Lấy hoặc khởi tạo combo trong session
    Combo0 combo = (Combo0) session.getAttribute("combo");
    if (combo == null) {
        combo = new Combo0();
        session.setAttribute("combo", combo);
    }

    // Xử lý action add hoặc remove món vào combo
    String action = request.getParameter("action");
    if ("add".equals(action)) {
        String dishIdParam = request.getParameter("dishId");
        if (dishIdParam != null && !dishIdParam.trim().isEmpty()) {
            int dishId = Integer.parseInt(dishIdParam.trim());
            DishDAO0 dishDAO = new DishDAO0();
            Dish0 dish = dishDAO.getDishById(dishId);
            if (dish != null) {
                ComboDetail0 cd = new ComboDetail0();
                cd.setDish(dish);
                cd.setQuantity(1);
                combo.addComboDetail(cd);
            }
        }
    } else if ("remove".equals(action)) {
        String dishIdParam = request.getParameter("dishId");
        if (dishIdParam != null && !dishIdParam.trim().isEmpty()) {
            int dishId = Integer.parseInt(dishIdParam.trim());
            combo.removeComboDetail(dishId);
        }
    }

    // Lấy danh mục cho dropdown
    CategoryDAO0 categoryDAO = new CategoryDAO0();
    Category0[] listCategory = categoryDAO.getAllCategory();

    // Xử lý tìm kiếm món ăn
    String txtSearchDish = request.getParameter("txtSearchDish");
    String cboCategoryParam = request.getParameter("cboCategory");
    int selectedCategoryId = 0;
    if (cboCategoryParam != null && !cboCategoryParam.trim().isEmpty()) {
        try {
            selectedCategoryId = Integer.parseInt(cboCategoryParam.trim());
        } catch (NumberFormatException ignored) {}
    }

    Dish0[] listDish = null;
    if (request.getParameter("btnSearchDish") != null || txtSearchDish != null) {
        DishDAO0 dishDAO = new DishDAO0();
        listDish = dishDAO.searchDish(txtSearchDish, selectedCategoryId);
    } else {
        DishDAO0 dishDAO = new DishDAO0();
        listDish = dishDAO.searchDish("", 0);
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thêm combo mới - RestMan</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <h2>THÊM MENU COMBO MỚI</h2>

        <!-- KHU VỰC 1: TÌM KIẾM MÓN ĂN -->
        <div class="section-box">
            <h3>1. Tìm kiếm món ăn</h3>
            <form action="gdAddCombo0.jsp" method="get" class="search-form" style="justify-content: flex-start; margin-bottom: 16px;">
                <label for="txtSearchDish">Tên món:</label>
                <input type="text" id="txtSearchDish" name="txtSearchDish" value="<%= (txtSearchDish != null ? txtSearchDish : "") %>" placeholder="Nhập tên món..." size="20">

                <label for="cboCategory">Danh mục:</label>
                <select id="cboCategory" name="cboCategory">
                    <option value="0">-- Tất cả danh mục --</option>
                    <%
                        if (listCategory != null) {
                            for (Category0 cat : listCategory) {
                    %>
                        <option value="<%= cat.getId() %>" <%= (selectedCategoryId == cat.getId() ? "selected" : "") %>><%= cat.getName() %></option>
                    <%
                            }
                        }
                    %>
                </select>

                <input type="submit" id="btnSearchDish" name="btnSearchDish" value="Tìm món" class="btn btn-secondary">
            </form>

            <table id="tblSearchResult" border="1" cellpadding="6" cellspacing="0">
                <thead>
                    <tr>
                        <th class="text-center" style="width: 70px;">Mã món</th>
                        <th>Tên món</th>
                        <th class="text-center" style="width: 120px;">Hình ảnh</th>
                        <th class="text-right" style="width: 120px;">Giá bán</th>
                        <th class="text-center" style="width: 130px;">Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    if (listDish != null && listDish.length > 0) {
                        for (Dish0 d : listDish) {
                %>
                    <tr>
                        <td class="text-center"><%= d.getId() %></td>
                        <td><%= d.getName() %></td>
                        <td class="text-center"><%= d.getImage() %></td>
                        <td class="text-right price-text"><%= String.format("%,.0f đ", d.getPrice()) %></td>
                        <td class="text-center">
                            <a id="selectAddDish" href="gdAddCombo0.jsp?action=add&dishId=<%= d.getId() %>&txtSearchDish=<%= (txtSearchDish != null ? txtSearchDish : "") %>&cboCategory=<%= selectedCategoryId %>" class="btn-link">Thêm vào combo</a>
                        </td>
                    </tr>
                <%
                        }
                    } else {
                %>
                    <tr>
                        <td colspan="5" class="text-center" style="color: #6c757d; padding: 16px;">Không tìm thấy món ăn nào phù hợp!</td>
                    </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>

        <!-- KHU VỰC 2: DANH SÁCH MÓN ĐÃ CHỌN & THÔNG TIN COMBO -->
        <div class="section-box">
            <h3>2. Danh sách món đã chọn trong combo</h3>
            <table id="tblComboDish" border="1" cellpadding="6" cellspacing="0">
                <thead>
                    <tr>
                        <th class="text-center" style="width: 70px;">Mã món</th>
                        <th>Tên món</th>
                        <th class="text-right" style="width: 120px;">Đơn giá</th>
                        <th class="text-center" style="width: 80px;">Số lượng</th>
                        <th class="text-right" style="width: 120px;">Thành tiền</th>
                        <th class="text-center" style="width: 90px;">Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    if (combo.getDsComboDetail() != null && !combo.getDsComboDetail().isEmpty()) {
                        for (ComboDetail0 cd : combo.getDsComboDetail()) {
                            float subTotal = cd.getDish().getPrice() * cd.getQuantity();
                %>
                    <tr>
                        <td class="text-center"><%= cd.getDish().getId() %></td>
                        <td><b><%= cd.getDish().getName() %></b></td>
                        <td class="text-right price-text"><%= String.format("%,.0f đ", cd.getDish().getPrice()) %></td>
                        <td class="text-center"><%= cd.getQuantity() %></td>
                        <td class="text-right price-text"><%= String.format("%,.0f đ", subTotal) %></td>
                        <td class="text-center">
                            <a id="selectRemoveDish" href="gdAddCombo0.jsp?action=remove&dishId=<%= cd.getDish().getId() %>&txtSearchDish=<%= (txtSearchDish != null ? txtSearchDish : "") %>&cboCategory=<%= selectedCategoryId %>" class="btn-delete">Xóa</a>
                        </td>
                    </tr>
                <%
                        }
                    } else {
                %>
                    <tr>
                        <td colspan="6" class="text-center" style="color: #6c757d; padding: 20px;"><i>Chưa có món nào được chọn vào combo. Vui lòng chọn món từ Khu vực 1!</i></td>
                    </tr>
                <%
                    }
                %>
                </tbody>
            </table>

            <h3 style="margin-top: 28px;">Thông tin combo & xác nhận lưu</h3>
            <form action="doSaveCombo0.jsp" method="post">
                <div class="form-grid">
                    <label for="txtComboName">Tên Combo:</label>
                    <input type="text" id="txtComboName" name="txtComboName" required placeholder="Nhập tên combo...">

                    <label for="txtComboPrice">Giá bán (VNĐ):</label>
                    <input type="text" id="txtComboPrice" name="txtComboPrice" required placeholder="Ví dụ: 250000">

                    <label for="txtComboImage">Hình ảnh:</label>
                    <input type="text" id="txtComboImage" name="txtComboImage" value="combo_default.jpg">

                    <label for="txtDescription">Mô tả:</label>
                    <input type="text" id="txtDescription" name="txtDescription" placeholder="Mô tả combo...">

                    <div class="form-submit">
                        <input type="submit" id="btnConfirm" name="btnConfirm" value="Xác nhận" class="btn btn-primary" style="padding: 10px 24px; font-size: 15px;">
                    </div>
                </div>
            </form>
        </div>

        <div class="back-box">
            <a id="btnBack" href="gdManageCombo0.jsp" class="btn btn-secondary">Quay lại danh sách combo</a>
        </div>
    </div>
</body>
</html>
