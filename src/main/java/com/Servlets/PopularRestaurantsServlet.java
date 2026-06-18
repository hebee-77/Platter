package com.Servlets;

import java.io.IOException;
import java.util.List;

import com.DAO.RestaurantDAO;
import com.DAOImpl.RestaurantDAOImpl;
import com.Model.Restaurant;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/popularRestaurants")
public class PopularRestaurantsServlet extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

		RestaurantDAO restaurantDAO = new RestaurantDAOImpl();
		List<Restaurant> restaurants = restaurantDAO.getAllRestaurants();

		// Sort by rating descending to get the most popular ones
		restaurants.sort((r1, r2) -> Double.compare(r2.getRating(), r1.getRating()));

		// Take top 8 popular ones
		if (restaurants.size() > 8) {
			restaurants = restaurants.subList(0, 8);
		}

		req.setAttribute("restaurantList", restaurants);

		req.getRequestDispatcher("/recommendedDishes").forward(req, resp);
	}
}
