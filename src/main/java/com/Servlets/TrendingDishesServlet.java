package com.Servlets;

import java.io.IOException;
import java.util.List;

import com.DAO.DishDAO;
import com.DAOImpl.DishDAOImpl;
import com.Model.Dish;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/trendingDishes")
public class TrendingDishesServlet extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

		DishDAO dishDAO = new DishDAOImpl();
		List<Dish> trendingDishes = dishDAO.getDishesBySection("trending");

		req.setAttribute("trendingDishes", trendingDishes);

		req.getRequestDispatcher("home.jsp").forward(req, resp);
	}
}
