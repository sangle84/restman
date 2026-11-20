package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.Customer0;
import model.Manager0;
import model.User0;

public class UserDAO0 extends DAO0 {

    public UserDAO0() {
        super();
    }

    /**
     * Truy vấn tblUser0 kết hợp kiểm tra bảng tblCustomer0 hoặc tblManager0
     * để trả về đúng đối tượng thực thể Customer0 hoặc Manager0 từ CSDL.
     */
    public User0 checkLogin(String username, String password) {
        if (con == null || username == null || password == null) {
            return null;
        }

        String sqlUser = "SELECT id, username, password, name, email, phone FROM tblUser0 WHERE username = ? AND password = ?";
        try (PreparedStatement psUser = con.prepareStatement(sqlUser)) {
            psUser.setString(1, username);
            psUser.setString(2, password);

            try (ResultSet rsUser = psUser.executeQuery()) {
                if (rsUser.next()) {
                    int id = rsUser.getInt("id");
                    String uName = rsUser.getString("username");
                    String pass = rsUser.getString("password");
                    String name = rsUser.getString("name");
                    String email = rsUser.getString("email");
                    String phone = rsUser.getString("phone");

                    // 1. Kiểm tra xem có phải Manager0 không (tblManager0 nối tblStaff0)
                    String sqlManager = "SELECT s.position FROM tblManager0 m " +
                                        "JOIN tblStaff0 s ON m.tblStaff0id = s.tblUser0id " +
                                        "WHERE m.tblStaff0id = ?";
                    try (PreparedStatement psMgr = con.prepareStatement(sqlManager)) {
                        psMgr.setInt(1, id);
                        try (ResultSet rsMgr = psMgr.executeQuery()) {
                            if (rsMgr.next()) {
                                String position = rsMgr.getString("position");
                                return new Manager0(id, uName, pass, name, email, phone, position);
                            }
                        }
                    }

                    // 2. Kiểm tra xem có phải Customer0 không (tblCustomer0)
                    String sqlCustomer = "SELECT tblUser0id FROM tblCustomer0 WHERE tblUser0id = ?";
                    try (PreparedStatement psCust = con.prepareStatement(sqlCustomer)) {
                        psCust.setInt(1, id);
                        try (ResultSet rsCust = psCust.executeQuery()) {
                            if (rsCust.next()) {
                                return new Customer0(id, uName, pass, name, email, phone);
                            }
                        }
                    }

                    // Mặc định trả về User0 nếu không thuộc nhóm trên
                    return new User0(id, uName, pass, name, email, phone);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}
