package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Dish0;

public class DishDAO0 extends DAO0 {

    public DishDAO0() {
        super();
    }

    /**
     * Tìm món ăn có name LIKE ?
     */
    public Dish0[] searchDishByName(String name) {
        List<Dish0> list = new ArrayList<>();
        if (con == null) {
            return new Dish0[0];
        }

        String sql = "SELECT id, name, image, price, description FROM tblDish0 WHERE name LIKE ? ORDER BY id ASC";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            String keyword = (name != null) ? "%" + name.trim() + "%" : "%";
            ps.setString(1, keyword);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Dish0 dish = new Dish0(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("image"),
                        rs.getFloat("price"),
                        rs.getString("description")
                    );
                    list.add(dish);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list.toArray(new Dish0[0]);
    }

    /**
     * Tìm món ăn theo tên và/hoặc categoryId (nếu categoryId == 0 thì lấy tất cả danh mục)
     */
    public Dish0[] searchDish(String name, int categoryId) {
        List<Dish0> list = new ArrayList<>();
        if (con == null) {
            return new Dish0[0];
        }

        String keyword = (name != null) ? "%" + name.trim() + "%" : "%";
        String sql;
        if (categoryId == 0) {
            sql = "SELECT id, name, image, price, description FROM tblDish0 WHERE name LIKE ? ORDER BY id ASC";
        } else {
            sql = "SELECT id, name, image, price, description FROM tblDish0 WHERE name LIKE ? AND tblCategory0id = ? ORDER BY id ASC";
        }

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, keyword);
            if (categoryId > 0) {
                ps.setInt(2, categoryId);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Dish0 dish = new Dish0(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("image"),
                        rs.getFloat("price"),
                        rs.getString("description")
                    );
                    list.add(dish);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list.toArray(new Dish0[0]);
    }

    /**
     * Lấy chi tiết 1 món ăn theo id
     */
    public Dish0 getDishById(int id) {
        if (con == null) {
            return null;
        }

        String sql = "SELECT id, name, image, price, description FROM tblDish0 WHERE id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Dish0(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("image"),
                        rs.getFloat("price"),
                        rs.getString("description")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}
