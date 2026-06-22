package com.Servlets;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

import com.DAO.RestaurantDAO;
import com.DAOImpl.RestaurantDAOImpl;
import com.Model.Restaurant;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/restaurants")
public class RestaurantsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Auth guard — redirect to login if not logged in
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect("index.jsp?showLogin=true&redirectTo=restaurants");
            return;
        }

        RestaurantDAO dao = new RestaurantDAOImpl();
        List<Restaurant> allRestaurants = dao.getAllRestaurants();

        // Read search and filter query params
        String query  = req.getParameter("q");
        String filter = req.getParameter("filter");   // topRated | freeDelivery | openNow | fastDelivery | all
        if (filter == null) {
            filter = "all";
        }

        // Apply text search
        if (query != null && !query.trim().isEmpty()) {
            final String q = query.trim().toLowerCase();
            allRestaurants = allRestaurants.stream()
                .filter(r -> r.getName().toLowerCase().contains(q)
                          || r.getCuisine().toLowerCase().contains(q))
                .collect(Collectors.toList());
        }

        // Apply filter chip
        if (filter != null && !filter.trim().isEmpty() && !filter.trim().equals("all")) {
            switch (filter.trim()) {
                case "topRated":
                    allRestaurants = allRestaurants.stream()
                        .filter(Restaurant::isTopRated)
                        .collect(Collectors.toList());
                    break;
                case "freeDelivery":
                    allRestaurants = allRestaurants.stream()
                        .filter(Restaurant::isFreeDelivery)
                        .collect(Collectors.toList());
                    break;
                case "openNow":
                    allRestaurants = allRestaurants.stream()
                        .filter(Restaurant::isOpen)
                        .collect(Collectors.toList());
                    break;
                case "fastDelivery":
                    // fast = delivery distance under 2 km
                    allRestaurants = allRestaurants.stream()
                        .filter(r -> r.getDistance() <= 2.0)
                        .collect(Collectors.toList());
                    break;
                default:
                    break;
            }
        }

        req.setAttribute("restaurantList", allRestaurants);
        req.setAttribute("searchQuery",    query  != null ? query  : "");
        req.setAttribute("activeFilter",   filter != null ? filter : "");
        req.setAttribute("totalCount",     allRestaurants.size());

        req.getRequestDispatcher("/restaurants.jsp").forward(req, resp);
    }
}
