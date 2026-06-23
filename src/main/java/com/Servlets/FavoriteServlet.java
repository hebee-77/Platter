package com.Servlets;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.DAO.FavoriteDAO;
import com.DAOImpl.FavoriteDAOImpl;
import com.Model.Dish;
import com.Model.Restaurant;
import com.Model.User;

@WebServlet("/favorites")
public class FavoriteServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final FavoriteDAO favoriteDao = new FavoriteDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedInUser") : null;

        if (user == null) {
            response.sendRedirect("index.jsp?showLogin=true&redirectTo=favorites");
            return;
        }

        int userId = user.getUserId();
        List<Restaurant> favoriteRestaurants = favoriteDao.getFavoriteRestaurants(userId);
        List<Dish> favoriteDishes = favoriteDao.getFavoriteDishes(userId);

        request.setAttribute("favoriteRestaurants", favoriteRestaurants);
        request.setAttribute("favoriteDishes", favoriteDishes);

        request.getRequestDispatcher("/favorites.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedInUser") : null;

        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json");
            response.getWriter().write("{\"error\":\"Not logged in\"}");
            return;
        }

        int userId = user.getUserId();
        String type = request.getParameter("type");
        String idStr = request.getParameter("id");

        if (type == null || idStr == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.setContentType("application/json");
            response.getWriter().write("{\"error\":\"Missing parameters\"}");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr.trim());
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.setContentType("application/json");
            response.getWriter().write("{\"error\":\"Invalid id\"}");
            return;
        }

        boolean added = false;
        if ("restaurant".equalsIgnoreCase(type)) {
            added = favoriteDao.toggleRestaurantFavorite(userId, id);
        } else if ("dish".equalsIgnoreCase(type)) {
            added = favoriteDao.toggleDishFavorite(userId, id);
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.setContentType("application/json");
            response.getWriter().write("{\"error\":\"Invalid type\"}");
            return;
        }

        int totalFavorites = favoriteDao.getFavoritesCount(userId);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"status\":\"success\",\"added\":" + added + ",\"favoriteCount\":" + totalFavorites + "}");
    }
}
