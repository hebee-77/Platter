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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/cart.css?v=<%= System.currentTimeMillis() %>">
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
        <div class="cart-grid">

            <!-- Cart Items List (Scrolls internally if items overflow) -->
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
                        <form action="${pageContext.request.contextPath}/cart-action" method="post" class="cart-action-form">
                            <input type="hidden" name="dishId" value="<%= item.getDishId() %>">
                            <input type="hidden" name="redirect" value="cart">
                            <div class="stepper">
                                <button type="submit" name="action" value="decrement" class="stepper-btn qty-decrease" aria-label="Decrease quantity">&minus;</button>
                                <span class="qty-val"><%= item.getQuantity() %></span>
                                <button type="submit" name="action" value="increment" class="stepper-btn qty-increase" aria-label="Increase quantity">+</button>
                            </div>
                            <span class="cart-item-line-total">₹<%= lineTotal %></span>
                            <button type="submit" name="action" value="remove" class="remove-btn" aria-label="Remove item">
                                <i class="fa-regular fa-trash-can"></i>
                            </button>
                        </form>
                    </div>
                </div>
                <% } %>
            </section>

            <!-- Summary Sidebar -->
            <aside class="cart-summary-sidebar">
                <form action="${pageContext.request.contextPath}/checkout" method="post" class="summary-card unified-checkout-card">
                    
                    <!-- Section 1: Order Summary -->
                    <div class="summary-section">
                        <h2 class="section-title">Order Summary</h2>
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

                    <div class="card-divider"></div>

                    <!-- Section 2: Delivery Address -->
                    <div class="summary-section">
                        <div class="section-header-row">
                            <h2 class="section-title">Delivery Address</h2>
                            <a href="#" class="address-change-btn">Change</a>
                        </div>
                        <div class="delivery-address-box">
                            <i class="fa-solid fa-location-dot"></i>
                            <div class="address-info">
                                <strong>Home</strong>
                                <span>221B Baker Street, Central Avenue, City</span>
                            </div>
                        </div>
                        <input type="hidden" name="addressId" value="1">
                    </div>

                    <div class="card-divider"></div>

                    <!-- Section 3: Payment Method -->
                    <div class="summary-section">
                        <h2 class="section-title">Payment Method</h2>
                        <div class="payment-options-list">
                            <label class="payment-option-card">
                                <input type="radio" name="paymentMethod" value="cod" checked>
                                <div class="payment-option-inner">
                                    <div class="payment-icon-wrapper cod-icon">
                                        <i class="fa-solid fa-money-bill-wave"></i>
                                    </div>
                                    <div class="payment-details">
                                        <span class="payment-title">Cash on Delivery</span>
                                        <span class="payment-subtitle">Pay with cash upon delivery</span>
                                    </div>
                                    <div class="payment-check-indicator">
                                        <i class="fa-solid fa-circle-check"></i>
                                    </div>
                                </div>
                            </label>

                            <label class="payment-option-card">
                                <input type="radio" name="paymentMethod" value="card">
                                <div class="payment-option-inner">
                                    <div class="payment-icon-wrapper card-icon">
                                        <i class="fa-solid fa-credit-card"></i>
                                    </div>
                                    <div class="payment-details">
                                        <span class="payment-title">Credit / Debit Card</span>
                                        <span class="payment-subtitle">Visa, Mastercard, RuPay</span>
                                    </div>
                                    <div class="payment-check-indicator">
                                        <i class="fa-solid fa-circle-check"></i>
                                    </div>
                                </div>
                            </label>

                            <label class="payment-option-card">
                                <input type="radio" name="paymentMethod" value="upi">
                                <div class="payment-option-inner">
                                    <div class="payment-icon-wrapper upi-icon">
                                        <i class="fa-solid fa-qrcode"></i>
                                    </div>
                                    <div class="payment-details">
                                        <span class="payment-title">UPI / Net Banking</span>
                                        <span class="payment-subtitle">Google Pay, PhonePe, Paytm</span>
                                    </div>
                                    <div class="payment-check-indicator">
                                        <i class="fa-solid fa-circle-check"></i>
                                    </div>
                                </div>
                            </label>
                        </div>
                    </div>

                    <!-- Section 4: Checkout Button -->
                    <button type="submit" class="btn-checkout">
                        Place Order <i class="fa-solid fa-arrow-right"></i>
                    </button>

                </form>
            </aside>

        </div>
        <% } %>

        <!-- Empty Cart Card -->
        <div class="empty-cart-card <% if (cartItems == null || cartItems.isEmpty()) { %>is-visible<% } %>" id="emptyCart">
            <div class="empty-cart-icon">
                <i class="fa-solid fa-basket-shopping"></i>
            </div>
            <h2>Your cart is empty</h2>
            <p>Looks like you haven't added any delicious food items to your cart yet.</p>
            <a href="${pageContext.request.contextPath}/restaurants" class="btn-checkout" style="max-width: 240px; text-decoration: none;">
                Explore Restaurants
            </a>
        </div>

    </main>

    <script src="${pageContext.request.contextPath}/js/cart.js"></script>
</body>

</html>