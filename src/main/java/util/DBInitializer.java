package util;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.File;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.sql.SQLException;
import java.net.URI;

public class DBInitializer {
    public static void main(String[] args) {
        String herokuDbUrl = args.length > 0 ? args[0] : null;
        if (herokuDbUrl == null) {
            System.err.println("Please provide the Heroku DATABASE_URL as the first argument.");
            return;
        }

        Connection conn = null;
        try {
            // Parse Heroku URL: postgres://user:pass@host:port/dbname
            URI dbUri = new URI(herokuDbUrl);
            String username = dbUri.getUserInfo().split(":")[0];
            String password = dbUri.getUserInfo().split(":")[1];
            String dbUrl = "jdbc:postgresql://" + dbUri.getHost() + ':' + dbUri.getPort() + dbUri.getPath() + "?sslmode=require";

            System.out.println("Connecting to database: " + dbUrl);
            conn = DriverManager.getConnection(dbUrl, username, password);
            System.out.println("Connected successfully!");

            // Read SQL file
            File sqlFile = new File("database/KSStudio_Postgres.sql");
            BufferedReader br = new BufferedReader(new FileReader(sqlFile));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                // Remove comments
                if (line.trim().startsWith("--")) continue;
                sb.append(line).append(" ");
            }
            br.close();

            // Split into statements
            String[] statements = sb.toString().split(";");
            Statement stmt = conn.createStatement();
            
            int count = 0;
            for (String sql : statements) {
                if (sql.trim().isEmpty()) continue;
                try {
                    stmt.execute(sql.trim());
                    count++;
                    System.out.print(".");
                } catch (SQLException e) {
                    System.err.println("\nError executing: " + sql.substring(0, Math.min(sql.length(), 50)) + "...");
                    System.err.println(e.getMessage());
                }
            }
            System.out.println("\nExecuted " + count + " statements.");

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (SQLException e) {}
            }
        }
    }
}
