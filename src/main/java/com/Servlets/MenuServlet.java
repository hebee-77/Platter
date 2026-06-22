package com.Servlets;

import java.io.IOException;
import java.util.List;

import com.DAO.DishDAO;
import com.DAO.RestaurantDAO;
import com.DAOImpl.DishDAOImpl;
import com.DAOImpl.RestaurantDAOImpl;
import com.Model.Dish;
import com.Model.Restaurant;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/menu")
public class MenuServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Auth guard — redirect to login if not logged in
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            String idParam = req.getParameter("id");
            String redirectUrl = "index.jsp?showLogin=true&redirectTo=menu";
            if (idParam != null && !idParam.trim().isEmpty()) {
                redirectUrl += "%3Fid%3D" + idParam.trim();
            }
            resp.sendRedirect(redirectUrl);
            return;
        }

        // Read restaurant id
        String idParam = req.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            resp.sendRedirect("restaurants");
            return;
        }

        int restaurantId;
        try {
            restaurantId = Integer.parseInt(idParam.trim());
        } catch (NumberFormatException e) {
            resp.sendRedirect("restaurants");
            return;
        }

        RestaurantDAO restaurantDao = new RestaurantDAOImpl();
        Restaurant restaurant = restaurantDao.getRestaurant(restaurantId);

        if (restaurant == null) {
            resp.sendRedirect("restaurants");
            return;
        }

        DishDAO dishDao = new DishDAOImpl();
        List<Dish> dishes = dishDao.getDishesByRestaurantName(restaurant.getName());

        req.setAttribute("restaurant", restaurant);
        req.setAttribute("dishes", dishes);
        req.setAttribute("dishCount", dishes.size());

        req.getRequestDispatcher("/menu.jsp").forward(req, resp);
    }
}
