package com.evcharging.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Database Connection Utility
 * Configures JDBC connection to MySQL database for EV Charging Station Finder.
 */
public class DBConnection {

    // =========================================================================
    // CONFIGURE YOUR MYSQL DATABASE CREDENTIALS HERE
    // Change DB_USER and DB_PASSWORD to match your local MySQL configuration.
    // =========================================================================
    private static final String DB_URL = "jdbc:mysql://localhost:3306/ev_charging_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String DB_USER = "root";       // <-- CHANGE IF NEEDED
    private static final String DB_PASSWORD = "root";   // <-- CHANGE IF NEEDED
    // =========================================================================

    private static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";

    static {
        try {
            Class.forName(DB_DRIVER);
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found in classpath!");
            e.printStackTrace();
        }
    }

    /**
     * Obtains a new database connection.
     * @return active java.sql.Connection
     * @throws SQLException if a database access error occurs
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }

    /**
     * Closes an open database connection safely.
     * @param conn the Connection to close
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
