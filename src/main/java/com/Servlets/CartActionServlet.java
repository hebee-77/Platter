package com.Servlets;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.DAO.CartDAO;
import com.DAOImpl.CartDAOImpl;
import com.Model.User;

@WebServlet("/cart-action")
public class CartActionServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private final CartDAO cartDao = new CartDAOImpl();

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		User user = (session != null) ? (User) session.getAttribute("loggedInUser") : null;

		if (user == null) {
			response.sendRedirect("login");
			return;
		}

		int userId = user.getUserId();
		String dishIdStr = request.getParameter("dishId");
		String action = request.getParameter("action");
		String redirect = request.getParameter("redirect");

		if (dishIdStr != null && action != null) {
			try {
				int dishId = Integer.parseInt(dishIdStr.trim());
				switch (action.trim().toLowerCase()) {
					case "add":
					case "increment":
						cartDao.addOrIncrement(userId, dishId);
						break;
					case "decrement":
						cartDao.decrement(userId, dishId);
						break;
					case "remove":
					case "delete":
						cartDao.removeItem(userId, dishId);
						break;
				}
			} catch (NumberFormatException e) {
				e.printStackTrace();
			}
		}

		if (redirect == null || redirect.trim().isEmpty()) {
			redirect = "cart";
		} else {
			redirect = redirect.trim();
		}

		response.sendRedirect(redirect);
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request, response);
	}
}
