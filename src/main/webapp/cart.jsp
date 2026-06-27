<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.Model.User, com.Model.CartItem, com.Model.Dish, java.util.List" %>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<%
    User loggedInUser = (User) request.getAttribute("loggedInUser");
    if (loggedInUser == null) {
        loggedInUser = (User) session.getAttribute("loggedInUser");
    }
    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
    Integer cartCountObj = (Integer) request.getAttribute("cartCount");
    Integer cartTotalObj = (Integer) request.getAttribute("cartTotal");

    int cartCount = (cartCountObj != null) ? cartCountObj : 0;
    int cartTotal = (cartTotalObj != null) ? cartTotalObj : 0;

    int deliveryFee = (cartCount > 0) ? 40 : 0;
    int taxes = (int) Math.round(cartTotal * 0.05);
    int grandTotal = cartTotal + deliveryFee + taxes;
    
    String restaurantName = "Restaurants";
    if (cartItems != null && !cartItems.isEmpty()) {
        CartItem firstItem = cartItems.get(0);
        if (firstItem.getDish() != null && firstItem.getDish().getRestaurantName() != null) {
            restaurantName = firstItem.getDish().getRestaurantName();
        }
    }
%>
<title>Platter | Your Cart</title>
<meta name="description" content="Review your selected dishes, select delivery address, and place your order on Platter.">

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/cart.css?v=1.0.0">
</head>

<body>

<!-- Background Blobs -->
<div class="blur blob-1"></div>
<div class="blur blob-2"></div>
<div class="blur blob-3"></div>

<!-- NAVBAR -->
<header class="navbar">
    <div class="navbar-container">
        <a href="${pageContext.request.contextPath}/home" class="logo">
            <span>P</span>latter
        </a>
        <div class="nav-actions">
            <a href="${pageContext.request.contextPath}/favorites" class="nav-btn-icon" title="Favorites">
                <i class="fa-regular fa-heart"></i>
            </a>
            <a href="${pageContext.request.contextPath}/cart" class="nav-btn-icon" title="Cart">
                <i class="fa-solid fa-cart-shopping"></i>
                <span class="nav-badge" id="navCartBadge"><%= cartCount %></span>
            </a>
            <% if (loggedInUser != null) { %>
                <div class="user-avatar" title="<%= loggedInUser.getName() %>">
                    <%= loggedInUser.getName().substring(0, 1).toUpperCase() %>
                </div>
            <% } else { %>
                <a href="${pageContext.request.contextPath}/login" class="btn-secondary-action">Sign in</a>
            <% } %>
        </div>
    </div>
</header>

<main class="wrap">

    <div class="cart-header-sec">
        <a href="${pageContext.request.contextPath}/restaurants" class="back-link">
            <i class="fa-solid fa-arrow-left"></i> Back to <%= restaurantName %>
        </a>
        <h1 class="page-title">Your Cart</h1>
    </div>

    <% if (cartItems != null && !cartItems.isEmpty()) { %>
    <form action="${pageContext.request.contextPath}/checkout" method="post" class="cart-grid">

        <!-- Cart Items List -->
        <section class="cart-items-wrapper" id="cartItemsList">
            <% for (CartItem item : cartItems) { 
                Dish dish = item.getDish();
                int price = (dish != null) ? dish.getPrice() : 0;
                int lineTotal = price * item.getQuantity();
                String name = (dish != null) ? dish.getName() : "Dish #" + item.getDishId();
                String img = (dish != null && dish.getImagePath() != null) ? dish.getImagePath() : "";
                boolean isVeg = (dish != null) ? dish.isVeg() : true;
            %>
            <div class="cart-item-card" data-dish-id="<%= item.getDishId() %>" data-price="<%= price %>">
                <% if (!img.isEmpty()) { %>
                    <div class="cart-item-photo" style="background-image: url('<%= img %>');"></div>
                <% } else { %>
                    <div class="cart-item-photo icon-photo">
                        <i class="fa-solid fa-utensils"></i>
                    </div>
                <% } %>
                
                <div class="cart-item-info">
                    <h3><%= name %></h3>
                    <div class="cart-item-meta">
                        <span class="cart-item-unit-price">₹<%= price %></span>
                        <% if (isVeg) { %>
                            <span class="veg-badge"><i class="fa-solid fa-circle"></i> VEG</span>
                        <% } else { %>
                            <span class="non-veg-badge"><i class="fa-solid fa-triangle-exclamation"></i> NON-VEG</span>
                        <% } %>
                    </div>
                </div>

                <div class="cart-item-controls">
                    <div class="stepper">
                        <button type="button" class="stepper-btn qty-decrease" aria-label="Decrease quantity">&minus;</button>
                        <span class="qty-val"><%= item.getQuantity() %></span>
                        <button type="button" class="stepper-btn qty-increase" aria-label="Increase quantity">+</button>
                    </div>
                    <span class="cart-item-line-total">₹<%= lineTotal %></span>
                    <button type="button" class="remove-btn" aria-label="Remove item">
                        <i class="fa-regular fa-trash-can"></i>
                    </button>
                </div>
            </div>
            <% } %>
        </section>

        <!-- Summary Sidebar -->
        <aside class="cart-summary-sidebar">

            <div class="summary-card">
                <h2>Order Summary</h2>
                <div class="summary-row">
                    <span>Subtotal</span>
                    <span id="subtotal">₹<%= cartTotal %></span>
                </div>
                <div class="summary-row">
                    <span>Delivery fee</span>
                    <span id="deliveryFee">₹<%= deliveryFee %></span>
                </div>
                <div class="summary-row">
                    <span>Taxes &amp; fees (5%)</span>
                    <span id="taxes">₹<%= taxes %></span>
                </div>
                <div class="summary-row total-row">
                    <span>Total Amount</span>
                    <span id="total">₹<%= grandTotal %></span>
                </div>
            </div>

            <div class="summary-card">
                <h2>
                    Delivery Address
                    <a href="#" class="btn-secondary-action" style="padding: 4px 12px; font-size: 12px;">Change</a>
                </h2>
                <div class="delivery-address-box">
                    <i class="fa-solid fa-location-dot"></i>
                    <div class="address-info">
                        <strong>Home</strong>
                        <span>221B Baker Street, Central Avenue, City</span>
                    </div>
                </div>
                <input type="hidden" name="addressId" value="1">
            </div>

            <div class="summary-card">
                <h2>Payment Method</h2>
                <div class="payment-options">
                    <label class="payment-option-label">
                        <input type="radio" name="paymentMethod" value="cod" checked>
                        <i class="fa-solid fa-money-bill-wave"></i> Cash on Delivery
                    </label>
                    <label class="payment-option-label">
                        <input type="radio" name="paymentMethod" value="card">
                        <i class="fa-solid fa-credit-card"></i> Credit / Debit Card
                    </label>
                    <label class="payment-option-label">
                        <input type="radio" name="paymentMethod" value="upi">
                        <i class="fa-solid fa-qrcode"></i> UPI / Net Banking
                    </label>
                </div>
            </div>

            <button type="submit" class="btn-checkout">
                Place Order <i class="fa-solid fa-arrow-right"></i>
            </button>

        </aside>

    </form>
    <% } %>

    <!-- Empty Cart Card -->
    <div class="empty-cart-card <% if (cartItems == null || cartItems.isEmpty()) { %>is-visible<% } %>" id="emptyCart">
        <div class="empty-cart-icon">
            <i class="fa-solid fa-basket-shopping"></i>
        </div>
        <h2>Your cart is empty</h2>
        <p>Looks like you haven't added any delicious food items to your cart yet.</p>
        <a href="${pageContext.request.contextPath}/restaurants" class="btn-checkout" style="max-width: 260px; text-decoration: none;">
            Explore Restaurants
        </a>
    </div>

</main>

<script src="${pageContext.request.contextPath}/js/cart.js"></script>
</body>
</html>
