package dao;

import java.io.File;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class InitDatabaseRunner {
    public static void main(String[] args) {
        try {
            File dbFile = new File("restman.db");
            if (dbFile.exists()) {
                dbFile.delete();
            }

            Class.forName("org.sqlite.JDBC");
            try (Connection conn = DriverManager.getConnection("jdbc:sqlite:restman.db");
                 Statement stmt = conn.createStatement()) {

                File sqlFile = new File("restman.sql");
                String content = new String(Files.readAllBytes(sqlFile.toPath()), StandardCharsets.UTF_8);
                String[] queries = content.split(";");
                for (String q : queries) {
                    String trimmed = q.trim();
                    if (!trimmed.isEmpty()) {
                        stmt.execute(trimmed);
                    }
                }
                System.out.println("restman.db created and initialized successfully! File size: " + dbFile.length() + " bytes");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
