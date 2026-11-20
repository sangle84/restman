package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Category0;

public class CategoryDAO0 extends DAO0 {

    public CategoryDAO0() {
        super();
    }

    /**
     * Lấy toàn bộ danh mục từ tblCategory0
     */
    public Category0[] getAllCategory() {
        List<Category0> list = new ArrayList<>();
        if (con == null) {
            return new Category0[0];
        }

        String sql = "SELECT id, name FROM tblCategory0 ORDER BY id ASC";
        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Category0 cat = new Category0(
                    rs.getInt("id"),
                    rs.getString("name")
                );
                list.add(cat);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list.toArray(new Category0[0]);
    }
}
