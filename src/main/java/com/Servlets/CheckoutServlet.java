package com.Servlets;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Random;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.DAO.CartDAO;
import com.DAOImpl.CartDAOImpl;
import com.Model.CartItem;
import com.Model.Order;
import com.Model.User;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

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
        List<CartItem> items = cartDao.getCartItemsWithDetailsByUser(userId);

        if (items == null || items.isEmpty()) {
            response.sendRedirect("cart");
            return;
        }

        String paymentMethodParam = request.getParameter("paymentMethod");
        String paymentMethod = "Cash on Delivery";
        if (paymentMethodParam != null) {
            switch (paymentMethodParam.trim().toLowerCase()) {
                case "card":
                    paymentMethod = "Credit / Debit Card";
                    break;
                case "upi":
                    paymentMethod = "UPI / Net Banking";
                    break;
                default:
                    paymentMethod = "Cash on Delivery";
                    break;
            }
        }

        int subtotal = cartDao.getCartTotal(userId);
        int deliveryFee = 40;
        int taxes = (int) Math.round(subtotal * 0.05);
        int grandTotal = subtotal + deliveryFee + taxes;

        String orderId = "PLT" + (100000 + new Random().nextInt(900000));

        Order order = new Order();
        order.setOrderId(orderId);
        order.setUserId(userId);
        order.setSubtotal(subtotal);
        order.setDeliveryFee(deliveryFee);
        order.setTaxes(taxes);
        order.setGrandTotal(grandTotal);
        order.setPaymentMethod(paymentMethod);
        order.setAddress("221B Baker Street, Central Avenue, City");
        order.setStatus("Confirmed");
        order.setOrderDate(new Date());
        order.setItems(items);

        // Clear the user's cart in the database
        cartDao.clearCart(userId);

        // Set attributes for the success view
        request.setAttribute("placedOrder", order);
        session.setAttribute("lastPlacedOrder", order);

        request.getRequestDispatcher("order-success.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Order lastOrder = (session != null) ? (Order) session.getAttribute("lastPlacedOrder") : null;

        if (lastOrder != null) {
            request.setAttribute("placedOrder", lastOrder);
            request.getRequestDispatcher("order-success.jsp").forward(request, response);
        } else {
            response.sendRedirect("home");
        }
    }
}
