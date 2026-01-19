package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Database Connection Utility
 * Shared by both Photographer and Client portals
 */
public class DBConnection {
    
    static {
        try {
            Class.forName("org.postgresql.Driver");
            System.out.println("PostgreSQL JDBC Driver loaded");
        } catch (ClassNotFoundException e) {
            System.err.println("PostgreSQL JDBC Driver not found!");
            e.printStackTrace();
        }
    }
    
    public static Connection getConnection() throws SQLException {
        Connection conn = null;
        String dbUrl = System.getenv("JDBC_DATABASE_URL");
        
        if (dbUrl != null && !dbUrl.isEmpty()) {
            conn = DriverManager.getConnection(dbUrl);
        } else {
            // Fallback for local development if env var is not set
            String url = "jdbc:postgresql://localhost:5432/ksstudio";
            String user = "postgres";
            String password = "postgres123"; 
            conn = DriverManager.getConnection(url, user, password);
        }

        if (conn != null) {
            conn.setAutoCommit(true);
        }
        return conn;
    }
    
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}
