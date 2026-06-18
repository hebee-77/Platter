package com.DAO;

import com.Model.User;

public interface UserDAO {

    // Sign up

    int addUser(User user);

    // Login

    User getUserByEmail(String email);

}