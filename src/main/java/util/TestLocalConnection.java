package util;

import java.sql.Connection;
import java.sql.SQLException;

public class TestLocalConnection {
    public static void main(String[] args) {
        System.out.println("Testing connection using DBConnection class...");
        Connection conn = DBConnection.getConnection();
        if (conn != null) {
            System.out.println("SUCCESS: Connection established!");
            try {
                conn.close();
                System.out.println("Connection closed.");
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } else {
            System.out.println("FAILURE: Could not connect.");
            System.out.println("Please check your PostgreSQL password and ensure the database 'ksstudio' exists.");
        }
    }
}
