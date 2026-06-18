package com.Servlets;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/home")

public class HomeServlet extends HttpServlet {

	protected void doGet(

			HttpServletRequest req,

			HttpServletResponse resp)

			throws ServletException, IOException {

		HttpSession session =

				req.getSession(false);

		if (session == null ||

				session.getAttribute("loggedInUser") == null) {

			resp.sendRedirect("index.jsp?showLogin=true");

			return;

		}

		// Forward request to PopularRestaurantsServlet to load restaurant data
		req.getRequestDispatcher("/popularRestaurants").forward(req, resp);

	}

}