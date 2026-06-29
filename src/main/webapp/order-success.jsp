<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.Model.User, com.Model.Order, com.Model.CartItem, com.Model.Dish, java.util.List" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    Order order = (Order) request.getAttribute("placedOrder");
    if (order == null) {
        order = (Order) session.getAttribute("lastPlacedOrder");
    }
    
    if (order == null) {
        response.sendRedirect("home");
        return;
    }
%>
    <title>Platter | Order Confirmation</title>
    <meta name="description" content="Thank you for your order on Platter. Your delicious food is being prepared.">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/order-success.css?v=1.0.0">
</head>

<body>

    <!-- Background Blobs -->
    <div class="blur blob-1"></div>
    <div class="blur blob-2"></div>

    <!-- NAVBAR -->
    <header class="navbar">
        <div class="navbar-container">
            <a href="${pageContext.request.contextPath}/home" class="logo">
                <span>P</span>latter
            </a>
            <% if (loggedInUser != null) { %>
                <div class="user-avatar" title="<%= loggedInUser.getName() %>">
                    <%= loggedInUser.getName().substring(0, 1).toUpperCase() %>
                </div>
            <% } %>
        </div>
    </header>

    <main class="order-wrap">

        <!-- Hero Celebration Banner -->
        <div class="success-hero-card">
            <div class="success-icon-badge">
                <i class="fa-solid fa-circle-check"></i>
            </div>
            <h1>Order Placed Successfully!</h1>
            <p>Thank you for ordering with Platter! Your food is being prepared with high standards of safety and love.</p>
            <div class="delivery-status-pill">
                <span class="pulse-dot"></span>
                <span>Estimated Delivery: 25 - 30 Mins</span>
            </div>
        </div>

        <!-- Order Details Grid -->
        <div class="order-grid">

            <!-- Left Box: Items summary -->
            <div class="order-box">
                <div class="box-title">
                    <span>Ordered Items</span>
                    <span style="font-size: 13px; color: var(--muted); text-transform: none;"><%= (order.getItems() != null) ? order.getItems().size() : 0 %> Dishes</span>
                </div>
                <div class="order-items-list">
                    <% 
                    if (order.getItems() != null && !order.getItems().isEmpty()) {
                        for (CartItem item : order.getItems()) {
                            Dish dish = item.getDish();
                            String name = (dish != null) ? dish.getName() : "Dish #" + item.getDishId();
                            int price = (dish != null) ? dish.getPrice() : 0;
                            String img = (dish != null && dish.getImagePath() != null) ? dish.getImagePath() : "";
                            int lineTotal = price * item.getQuantity();
                    %>
                    <div class="order-item-row">
                        <% if (!img.isEmpty()) { %>
                            <div class="order-item-img" style="background-image: url('<%= img %>');"></div>
                        <% } else { %>
                            <div class="order-item-img icon-img"><i class="fa-solid fa-utensils"></i></div>
                        <% } %>
                        <div class="order-item-meta">
                            <h4><%= name %></h4>
                            <span class="order-item-qty">Qty: <%= item.getQuantity() %> &bull; ₹<%= price %> each</span>
                        </div>
                        <span class="order-item-price">₹<%= lineTotal %></span>
                    </div>
                    <% 
                        }
                    } 
                    %>
                </div>
            </div>

            <!-- Right Box: Payment & Delivery -->
            <div class="order-box">
                <div class="box-title">
                    <span>Receipt</span>
                    <span class="order-id-tag">#<%= order.getOrderId() %></span>
                </div>

                <div class="info-group">
                    <span class="info-label">Delivery Address</span>
                    <div class="info-card">
                        <i class="fa-solid fa-location-dot"></i>
                        <span><%= order.getAddress() %></span>
                    </div>
                </div>

                <div class="info-group">
                    <span class="info-label">Payment Method</span>
                    <div class="info-card">
                        <% if ("Cash on Delivery".equalsIgnoreCase(order.getPaymentMethod())) { %>
                            <i class="fa-solid fa-money-bill-wave"></i>
                        <% } else if ("Credit / Debit Card".equalsIgnoreCase(order.getPaymentMethod())) { %>
                            <i class="fa-solid fa-credit-card"></i>
                        <% } else { %>
                            <i class="fa-solid fa-qrcode"></i>
                        <% } %>
                        <span><%= order.getPaymentMethod() %></span>
                    </div>
                </div>

                <div class="price-breakdown">
                    <div class="price-row">
                        <span>Item Subtotal</span>
                        <span>₹<%= order.getSubtotal() %></span>
                    </div>
                    <div class="price-row">
                        <span>Delivery Fee</span>
                        <span>₹<%= order.getDeliveryFee() %></span>
                    </div>
                    <div class="price-row">
                        <span>Taxes &amp; Fees (5%)</span>
                        <span>₹<%= order.getTaxes() %></span>
                    </div>
                    <div class="price-row total-row">
                        <span>Amount Paid</span>
                        <span>₹<%= order.getGrandTotal() %></span>
                    </div>
                </div>

                <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/restaurants" class="btn-primary-action">
                        Explore More <i class="fa-solid fa-arrow-right"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/home" class="btn-outline-action">
                        Home
                    </a>
                </div>

            </div>

        </div>

    </main>

</body>

</html>
