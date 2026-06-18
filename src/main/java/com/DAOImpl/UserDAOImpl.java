package com.DAOImpl;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.DAO.UserDAO;
import com.Utility.DBConnection;
import com.Model.User;

public class UserDAOImpl implements UserDAO {

    private Connection con;

    private PreparedStatement pstmt;

    private ResultSet res;

    public UserDAOImpl() {

        con = DBConnection.getConnection();

    }

    // ====================================
    // SIGNUP
    // ====================================

    @Override

    public int addUser(User user) {

        String query =

                "INSERT INTO users(name,email,password) VALUES(?,?,?)";

        try {

            pstmt = con.prepareStatement(query);

            pstmt.setString(1, user.getName());

            pstmt.setString(2, user.getEmail());

            pstmt.setString(3, user.getPassword());

            return pstmt.executeUpdate();

        }

        catch (SQLException e) {

            e.printStackTrace();

        }

        return 0;

    }

    // ====================================
    // LOGIN
    // ====================================

    @Override

    public User getUserByEmail(String email) {

        String query =

                "SELECT * FROM users WHERE email=?";

        try {

            pstmt = con.prepareStatement(query);

            pstmt.setString(1, email);

            res = pstmt.executeQuery();

            if (res.next()) {

                User user = new User();

                user.setUserId(

                        res.getInt("user_id")

                );

                user.setName(

                        res.getString("name")

                );

                user.setEmail(

                        res.getString("email")

                );

                user.setPassword(

                        res.getString("password")

                );

                return user;

            }

        }

        catch (SQLException e) {

            e.printStackTrace();

        }

        return null;

    }

}