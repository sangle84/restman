package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.Combo0;
import model.ComboDetail0;
import model.Dish0;

public class ComboDAO0 extends DAO0 {

    public ComboDAO0() {
        super();
    }

    /**
     * Lấy danh sách combo hiện có từ tblCombo0 (kèm chi tiết món ăn)
     */
    public Combo0[] getAllCombo() {
        List<Combo0> list = new ArrayList<>();
        if (con == null) {
            return new Combo0[0];
        }

        String sqlCombo = "SELECT id, name, image, price, description FROM tblCombo0 ORDER BY id ASC";
        String sqlDetail = "SELECT cd.id, cd.quantity, d.id AS dish_id, d.name AS dish_name, " +
                           "d.image AS dish_image, d.price AS dish_price, d.description AS dish_desc " +
                           "FROM tblComboDetail0 cd " +
                           "JOIN tblDish0 d ON cd.tblDish0id = d.id " +
                           "WHERE cd.tblCombo0id = ? " +
                           "ORDER BY cd.id ASC";

        try (PreparedStatement psCombo = con.prepareStatement(sqlCombo);
             ResultSet rsCombo = psCombo.executeQuery()) {

            while (rsCombo.next()) {
                int comboId = rsCombo.getInt("id");
                Combo0 combo = new Combo0(
                    comboId,
                    rsCombo.getString("name"),
                    rsCombo.getString("image"),
                    rsCombo.getFloat("price"),
                    rsCombo.getString("description")
                );

                // Lấy chi tiết các món thuộc combo này
                List<ComboDetail0> details = new ArrayList<>();
                try (PreparedStatement psDetail = con.prepareStatement(sqlDetail)) {
                    psDetail.setInt(1, comboId);
                    try (ResultSet rsDetail = psDetail.executeQuery()) {
                        while (rsDetail.next()) {
                            Dish0 dish = new Dish0(
                                rsDetail.getInt("dish_id"),
                                rsDetail.getString("dish_name"),
                                rsDetail.getString("dish_image"),
                                rsDetail.getFloat("dish_price"),
                                rsDetail.getString("dish_desc")
                            );
                            ComboDetail0 cd = new ComboDetail0(
                                rsDetail.getInt("id"),
                                rsDetail.getInt("quantity"),
                                dish
                            );
                            details.add(cd);
                        }
                    }
                }

                combo.setDsComboDetail(details);
                list.add(combo);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list.toArray(new Combo0[0]);
    }

    /**
     * Dùng Transaction (con.setAutoCommit(false)), lưu vào tblCombo0,
     * lấy id tự tăng (RETURN_GENERATED_KEYS), lưu tiếp danh sách dsComboDetail vào tblComboDetail0,
     * commit() và trả về true (hoặc rollback() và trả về false nếu lỗi).
     */
    public boolean addCombo(Combo0 combo) {
        if (con == null || combo == null) {
            return false;
        }

        boolean success = false;
        try {
            con.setAutoCommit(false);

            String sqlCombo = "INSERT INTO tblCombo0 (name, image, price, description) VALUES (?, ?, ?, ?)";
            try (PreparedStatement psCombo = con.prepareStatement(sqlCombo, Statement.RETURN_GENERATED_KEYS)) {
                psCombo.setString(1, combo.getName());
                psCombo.setString(2, combo.getImage());
                psCombo.setFloat(3, combo.getPrice());
                psCombo.setString(4, combo.getDescription());
                psCombo.executeUpdate();

                try (ResultSet rs = psCombo.getGeneratedKeys()) {
                    if (rs.next()) {
                        int generatedId = rs.getInt(1);
                        combo.setId(generatedId);
                    }
                }
            }

            if (combo.getDsComboDetail() != null && !combo.getDsComboDetail().isEmpty()) {
                String sqlDetail = "INSERT INTO tblComboDetail0 (quantity, tblCombo0id, tblDish0id) VALUES (?, ?, ?)";
                try (PreparedStatement psDetail = con.prepareStatement(sqlDetail)) {
                    for (ComboDetail0 cd : combo.getDsComboDetail()) {
                        if (cd != null && cd.getDish() != null) {
                            psDetail.setInt(1, cd.getQuantity());
                            psDetail.setInt(2, combo.getId());
                            psDetail.setInt(3, cd.getDish().getId());
                            psDetail.executeUpdate();
                        }
                    }
                }
            }

            con.commit();
            success = true;
        } catch (Exception e) {
            try {
                con.rollback();
            } catch (Exception rollbackEx) {
                rollbackEx.printStackTrace();
            }
            e.printStackTrace();
            success = false;
        } finally {
            try {
                con.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }

        return success;
    }
}
