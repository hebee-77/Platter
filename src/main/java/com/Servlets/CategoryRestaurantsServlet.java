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

@WebServlet("/category")
public class CategoryRestaurantsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Auth guard — redirect to login if not logged in
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            String category = req.getParameter("name");
            String redirectUrl = "index.jsp?showLogin=true&redirectTo=category";
            if (category != null && !category.trim().isEmpty()) {
                redirectUrl += "%3Fname%3D" + category.trim();
            }
            resp.sendRedirect(redirectUrl);
            return;
        }

        String categoryParam = req.getParameter("name");
        final String category = categoryParam == null ? "" : categoryParam;

        RestaurantDAO dao = new RestaurantDAOImpl();
        List<Restaurant> allRestaurants = dao.getAllRestaurants();
        List<Restaurant> filteredRestaurants;

        if (category.trim().isEmpty()) {
            filteredRestaurants = allRestaurants;
        } else {
            filteredRestaurants = allRestaurants.stream()
                    .filter(r -> matchesCategory(r, category))
                    .collect(Collectors.toList());
        }

        req.setAttribute("restaurantList", filteredRestaurants);
        req.setAttribute("categoryName", category);
        req.setAttribute("totalCount", filteredRestaurants.size());

        req.getRequestDispatcher("/restaurants.jsp").forward(req, resp);
    }

    private boolean matchesCategory(Restaurant r, String category) {
        if (category == null || category.trim().isEmpty()) {
            return true;
        }
        String cat = category.trim().toLowerCase();
        String name = r.getName().toLowerCase();
        String cuisine = r.getCuisine().toLowerCase();

        switch (cat) {
            case "pizza":
                return name.contains("pizza") || cuisine.contains("pizza") || cuisine.contains("italian");
            case "burger":
                return name.contains("burger") || cuisine.contains("burger") || cuisine.contains("fast food")
                        || cuisine.contains("american");
            case "chinese":
                return name.contains("chinese") || cuisine.contains("chinese");
            case "biryani":
                return name.contains("biryani") || cuisine.contains("biryani") || cuisine.contains("hyderabadi");
            case "coffee":
                return name.contains("coffee") || cuisine.contains("coffee") || cuisine.contains("cafe")
                        || cuisine.contains("beverages");
            case "desserts":
                return name.contains("dessert") || cuisine.contains("dessert") || cuisine.contains("bakery");
            case "healthy":
                return name.contains("healthy") || cuisine.contains("healthy") || cuisine.contains("salad");
            case "indian":
                return name.contains("indian") || cuisine.contains("indian");
            default:
                return name.contains(cat) || cuisine.contains(cat);
        }
    }
}
