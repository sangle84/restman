package dao;

import static org.junit.Assert.*;

import model.*;
import org.junit.BeforeClass;
import org.junit.Test;

public class DAOTest0 {

    @BeforeClass
    public static void setUp() {
        // Khởi tạo DAO0 để đảm bảo DB và schema sẵn sàng
        new DAO0();
    }

    @Test
    public void testCustomerLoginSuccess() {
        UserDAO0 userDAO = new UserDAO0();
        User0 user = userDAO.checkLogin("customer1", "123456");
        assertNotNull("User customer1 should be found in DB", user);
        assertTrue("User customer1 must be instance of Customer0", user instanceof Customer0);
        assertEquals("Nguyễn Văn Khách", user.getName());
    }

    @Test
    public void testManagerLoginSuccess() {
        UserDAO0 userDAO = new UserDAO0();
        User0 user = userDAO.checkLogin("manager1", "123456");
        assertNotNull("User manager1 should be found in DB", user);
        assertTrue("User manager1 must be instance of Manager0", user instanceof Manager0);
        assertEquals("Lê Quản Lý", user.getName());
        Manager0 manager = (Manager0) user;
        assertEquals("Quản lý nhà hàng", manager.getPosition());
    }

    @Test
    public void testLoginFailure() {
        UserDAO0 userDAO = new UserDAO0();
        User0 user = userDAO.checkLogin("nonexistent", "wrongpass");
        assertNull("Non-existent user should return null", user);
    }

    @Test
    public void testGetAllCategory() {
        CategoryDAO0 categoryDAO = new CategoryDAO0();
        Category0[] categories = categoryDAO.getAllCategory();
        assertNotNull(categories);
        assertTrue("Should have at least 4 categories", categories.length >= 4);
    }

    @Test
    public void testSearchDishByName() {
        DishDAO0 dishDAO = new DishDAO0();
        Dish0[] dishes = dishDAO.searchDishByName("Bò bít tết");
        assertNotNull(dishes);
        assertTrue("Should find at least 1 dish with name Bò bít tết", dishes.length >= 1);
        assertEquals("Bò bít tết sốt tiêu đen", dishes[0].getName());
    }

    @Test
    public void testSearchDishByCategory() {
        DishDAO0 dishDAO = new DishDAO0();
        // category 1 = Khai vị
        Dish0[] dishes = dishDAO.searchDish("", 1);
        assertNotNull(dishes);
        assertTrue("Should find dishes in category 1", dishes.length >= 2);
    }

    @Test
    public void testGetDishById() {
        DishDAO0 dishDAO = new DishDAO0();
        Dish0 dish = dishDAO.getDishById(1);
        assertNotNull("Dish 1 should exist", dish);
        assertEquals("Gỏi cuốn tôm thịt", dish.getName());
    }

    @Test
    public void testComboModelAddAndRemoveDetail() {
        Combo0 combo = new Combo0();
        Dish0 d1 = new Dish0(1, "Dish 1", "img1.jpg", 10000, "Desc 1");
        Dish0 d2 = new Dish0(2, "Dish 2", "img2.jpg", 20000, "Desc 2");

        ComboDetail0 cd1 = new ComboDetail0(0, 1, d1);
        combo.addComboDetail(cd1);
        assertEquals(1, combo.getDsComboDetail().size());
        assertEquals(1, combo.getDsComboDetail().get(0).getQuantity());

        // Thêm tiếp d1 -> cộng dồn
        ComboDetail0 cd1Again = new ComboDetail0(0, 2, d1);
        combo.addComboDetail(cd1Again);
        assertEquals(1, combo.getDsComboDetail().size());
        assertEquals(3, combo.getDsComboDetail().get(0).getQuantity());

        // Thêm d2
        ComboDetail0 cd2 = new ComboDetail0(0, 1, d2);
        combo.addComboDetail(cd2);
        assertEquals(2, combo.getDsComboDetail().size());

        // Xóa d1
        combo.removeComboDetail(1);
        assertEquals(1, combo.getDsComboDetail().size());
        assertEquals(2, combo.getDsComboDetail().get(0).getDish().getId());
    }

    @Test
    public void testGetAllComboAndAddCombo() {
        ComboDAO0 comboDAO = new ComboDAO0();
        Combo0[] combos = comboDAO.getAllCombo();
        assertNotNull(combos);
        int initialCount = combos.length;
        assertTrue(initialCount >= 2);

        // Test add new combo with transaction
        DishDAO0 dishDAO = new DishDAO0();
        Dish0 d1 = dishDAO.getDishById(1);
        Dish0 d2 = dishDAO.getDishById(8);

        Combo0 newCombo = new Combo0();
        newCombo.setName("Combo Thử Nghiệm " + System.currentTimeMillis());
        newCombo.setPrice(75000);
        newCombo.setImage("combo_test.jpg");
        newCombo.setDescription("Combo test mô tả");

        ComboDetail0 cd1 = new ComboDetail0(0, 2, d1);
        ComboDetail0 cd2 = new ComboDetail0(0, 1, d2);
        newCombo.addComboDetail(cd1);
        newCombo.addComboDetail(cd2);

        boolean added = comboDAO.addCombo(newCombo);
        assertTrue("Add combo should succeed", added);
        assertTrue("New combo should have generated id > 0", newCombo.getId() > 0);

        Combo0[] afterCombos = comboDAO.getAllCombo();
        assertEquals(initialCount + 1, afterCombos.length);
    }
}
