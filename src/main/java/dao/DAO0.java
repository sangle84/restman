package dao;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class DAO0 {
    protected Connection con;

    // Cấu hình CSDL: Chuyển USE_MYSQL = true nếu dùng MySQL
    public static final boolean USE_MYSQL = false;

    // Cấu hình kết nối MySQL
    private static final String MYSQL_DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String MYSQL_URL = "jdbc:mysql://localhost:3306/restman?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8";
    private static final String MYSQL_USER = "root";
    private static final String MYSQL_PASS = "";

    // Cấu hình kết nối SQLite
    private static final String SQLITE_DRIVER = "org.sqlite.JDBC";

    public DAO0() {
        try {
            if (USE_MYSQL) {
                Class.forName(MYSQL_DRIVER);
                this.con = DriverManager.getConnection(MYSQL_URL, MYSQL_USER, MYSQL_PASS);
            } else {
                Class.forName(SQLITE_DRIVER);
                String dbPath = resolveSqliteDbPath();
                String sqliteUrl = "jdbc:sqlite:" + dbPath;
                this.con = DriverManager.getConnection(sqliteUrl);
                // Tự động kiểm tra và khởi tạo dữ liệu mẫu nếu bảng chưa tồn tại
                ensureDatabaseInitialized();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Xác định đường dẫn file CSDL SQLite restman.db
     */
    private static String resolveSqliteDbPath() {
        String prop = System.getProperty("restman.db.path");
        if (prop != null && !prop.trim().isEmpty()) {
            return prop.trim();
        }

        // Kiểm tra thư mục hiện tại
        File fCurrent = new File("restman.db");
        if (fCurrent.exists()) {
            return fCurrent.getAbsolutePath();
        }

        // Kiểm tra thư mục gốc dự án
        File fProject = new File("d:/Development/Projects/restman/restman.db");
        if (fProject.exists()) {
            return fProject.getAbsolutePath();
        }

        return "restman.db";
    }

    /**
     * Tự động khởi tạo schema và dữ liệu mẫu nếu CSDL SQLite chưa có bảng
     */
    private void ensureDatabaseInitialized() {
        try {
            boolean tablesExist = false;
            try (Statement st = con.createStatement();
                 ResultSet rs = st.executeQuery("SELECT count(*) FROM sqlite_master WHERE type='table' AND name='tblUser0'")) {
                if (rs.next() && rs.getInt(1) > 0) {
                    tablesExist = true;
                }
            }

            if (!tablesExist) {
                initializeFromSqlScript();
            }
        } catch (Exception e) {
            System.err.println("Notice on DB check: " + e.getMessage());
        }
    }

    private void initializeFromSqlScript() {
        try {
            String sqlContent = null;
            File sqlFile = new File("restman.sql");
            if (!sqlFile.exists()) {
                sqlFile = new File("d:/Development/Projects/restman/restman.sql");
            }

            if (sqlFile.exists()) {
                sqlContent = new String(Files.readAllBytes(sqlFile.toPath()), StandardCharsets.UTF_8);
            } else {
                InputStream is = getClass().getClassLoader().getResourceAsStream("restman.sql");
                if (is != null) {
                    try (BufferedReader reader = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
                        StringBuilder sb = new StringBuilder();
                        String line;
                        while ((line = reader.readLine()) != null) {
                            sb.append(line).append("\n");
                        }
                        sqlContent = sb.toString();
                    }
                }
            }

            if (sqlContent != null) {
                String[] statements = sqlContent.split(";");
                try (Statement stmt = con.createStatement()) {
                    for (String singleSql : statements) {
                        String trimmed = singleSql.trim();
                        if (!trimmed.isEmpty()) {
                            stmt.execute(trimmed);
                        }
                    }
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    public Connection getConnection() {
        return con;
    }
}
