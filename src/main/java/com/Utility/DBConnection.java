package com.Utility;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    private static Connection con;

    public static Connection getConnection() {

        try {

            Class.forName(

                    "com.mysql.cj.jdbc.Driver"

            );

            return DriverManager.getConnection(

                    "jdbc:mysql://localhost:3306/Platter",

                    "root",

                    "root"

            );

        }

        catch (Exception e) {

            e.printStackTrace();

            return null;

        }

    }

}