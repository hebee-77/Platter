package com.Servlets;

import java.io.IOException;

import com.DAO.UserDAO;
import com.DAOImpl.UserDAOImpl;
import com.Model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")

public class LoginServlet extends HttpServlet {

	protected void doPost(

			HttpServletRequest req,

			HttpServletResponse resp)

			throws ServletException, IOException {

		String email =

				req.getParameter("email");

		String password =

				req.getParameter("password");

		UserDAO dao =

				new UserDAOImpl();

		User user =

				dao.getUserByEmail(email);

		if (user != null && user.getPassword().equals(password)) {

			HttpSession session =

					req.getSession();

			session.setAttribute("loggedInUser", user);

			resp.sendRedirect("home");

		}

		else {

			resp.sendRedirect("index.jsp?error=invalid");

		}

	}

}
