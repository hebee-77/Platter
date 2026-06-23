package com.Servlets;

import java.io.IOException;
import java.io.PrintWriter;
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

@WebServlet("/cart-api")
public class CartServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	private final CartDAO cartDao = new CartDAOImpl();

	/**
	 * GET /cart-api
	 * Returns the full cart state for the logged-in user.
	 * Response:
	 *   { "items": [{ "dishId": 12, "quantity": 2 }, ...],
	 *     "cartItemCount": 3,
	 *     "cartTotal": 540 }
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");

		HttpSession session = request.getSession(false);
		User user = (session != null) ? (User) session.getAttribute("loggedInUser") : null;

		if (user == null) {
			response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
			response.getWriter().write("{\"error\":\"Not logged in\"}");
			return;
		}

		int userId = user.getUserId();
		List<CartItem> items = cartDao.getCartItemsByUser(userId);
		int count = cartDao.getCartItemCount(userId);
		int total = cartDao.getCartTotal(userId);

		PrintWriter out = response.getWriter();
		StringBuilder sb = new StringBuilder();
		sb.append("{");
		sb.append("\"items\":[");
		for (int i = 0; i < items.size(); i++) {
			CartItem ci = items.get(i);
			sb.append("{\"dishId\":").append(ci.getDishId())
			  .append(",\"quantity\":").append(ci.getQuantity()).append("}");
			if (i < items.size() - 1) sb.append(",");
		}
		sb.append("],");
		sb.append("\"cartItemCount\":").append(count).append(",");
		sb.append("\"cartTotal\":").append(total);
		sb.append("}");
		out.write(sb.toString());
	}

	/**
	 * POST /cart-api
	 * Params: dishId (int), action (add | increment | decrement)
	 * Response:
	 *   { "dishId": 12, "newQty": 2, "cartItemCount": 3, "cartTotal": 540 }
	 */
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");

		HttpSession session = request.getSession(false);
		User user = (session != null) ? (User) session.getAttribute("loggedInUser") : null;

		if (user == null) {
			response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
			response.getWriter().write("{\"error\":\"Not logged in\"}");
			return;
		}

		int userId = user.getUserId();

		String dishIdStr = request.getParameter("dishId");
		String action    = request.getParameter("action");

		if (dishIdStr == null || action == null) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			response.getWriter().write("{\"error\":\"Missing parameters\"}");
			return;
		}

		int dishId;
		try {
			dishId = Integer.parseInt(dishIdStr.trim());
		} catch (NumberFormatException e) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			response.getWriter().write("{\"error\":\"Invalid dishId\"}");
			return;
		}

		switch (action.trim().toLowerCase()) {
			case "add":
			case "increment":
				cartDao.addOrIncrement(userId, dishId);
				break;
			case "decrement":
				cartDao.decrement(userId, dishId);
				break;
			default:
				response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
				response.getWriter().write("{\"error\":\"Unknown action\"}");
				return;
		}

		// Fetch fresh counts from DB — do not compute in Java
		int count = cartDao.getCartItemCount(userId);
		int total = cartDao.getCartTotal(userId);

		// Find the new quantity for this specific dish
		int newQty = 0;
		for (CartItem ci : cartDao.getCartItemsByUser(userId)) {
			if (ci.getDishId() == dishId) {
				newQty = ci.getQuantity();
				break;
			}
		}

		PrintWriter out = response.getWriter();
		out.write("{\"dishId\":" + dishId +
		          ",\"newQty\":" + newQty +
		          ",\"cartItemCount\":" + count +
		          ",\"cartTotal\":" + total + "}");
	}
}
