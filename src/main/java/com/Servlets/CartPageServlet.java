package com.Servlets;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.DAO.CartDAO;
import com.DAOImpl.CartDAOImpl;
import com.Model.CartItem;
import com.Model.User;

@WebServlet("/cart")
public class CartPageServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private final CartDAO cartDao = new CartDAOImpl();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		User user = (session != null) ? (User) session.getAttribute("loggedInUser") : null;

		if (user == null) {
			response.sendRedirect("login");
			return;
		}

		int userId = user.getUserId();
		List<CartItem> cartItems = cartDao.getCartItemsWithDetailsByUser(userId);
		int cartCount = cartDao.getCartItemCount(userId);
		int cartTotal = cartDao.getCartTotal(userId);

		request.setAttribute("cartItems", cartItems);
		request.setAttribute("cartCount", cartCount);
		request.setAttribute("cartTotal", cartTotal);

		request.getRequestDispatcher("cart.jsp").forward(request, response);
	}
}
