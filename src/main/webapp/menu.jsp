<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.Model.User, com.Model.Restaurant, com.Model.Dish, java.util.List" %>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<%
    Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    int favCount = 0;
    int cartCount = 0;
    if (loggedInUser != null) {
        favCount = new com.DAOImpl.FavoriteDAOImpl().getFavoritesCount(loggedInUser.getUserId());
        cartCount = new com.DAOImpl.CartDAOImpl().getCartItemCount(loggedInUser.getUserId());
    }
    List<Dish> dishes = (List<Dish>) request.getAttribute("dishes");
    Integer dishCount = (Integer) request.getAttribute("dishCount");
    if (dishCount == null) dishCount = 0;
    String restName = (restaurant != null) ? restaurant.getName() : "Restaurant";
%>
<title>Platter | <%= restName %> — Menu</title>
<meta name="description" content="Explore the full menu of <%= restName %> on Platter. Browse dishes, ratings, and order your favourites.">

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
<link rel="stylesheet" href="css/menu.css?v=3.0.0">
</head>

<body>

<!-- Background Blobs -->
<div class="blur blob-1"></div>
<div class="blur blob-2"></div>
<div class="blur blob-3"></div>

<!-- =========================================================
     NAVBAR
     ========================================================= -->
<header class="navbar" id="mainNavbar">
    <div class="navbar-container">

        <div class="logo" onclick="window.location.href='home'" style="cursor:pointer;">
            <span>P</span>latter
        </div>

        <form class="nav-search-bar" action="restaurants" method="get" role="search">
            <i class="fa-solid fa-magnifying-glass search-icon"></i>
            <input type="text" name="q" id="navSearchInput"
                   placeholder="Search restaurants or cuisines..."
                   autocomplete="off">
            <div class="search-shortcut" title="Press Enter to search">&#8984;K</div>
        </form>

        <div class="nav-actions">

            <a href="favorites" class="nav-btn-icon" aria-label="Favorites" title="Favorites">
                <i class="fa-regular fa-heart"></i>
                <span class="badge badge-primary fav-badge-count" <%= favCount == 0 ? "style=\"display: none;\"" : "" %>><%= favCount %></span>
            </a>

            <a href="#" class="nav-btn-icon" aria-label="Cart" title="Cart">
                <i class="fa-solid fa-bag-shopping"></i>
                <span class="badge badge-secondary cart-badge-count" <%= cartCount == 0 ? "style=\"display: none;\"" : "" %>><%= cartCount %></span>
            </a>

            <div class="profile-container" id="profileTrigger">
                <button class="profile-avatar-btn" aria-label="User profile">
                    <div class="avatar-initials">
                        <%= loggedInUser.getName().toUpperCase().charAt(0) %>
                    </div>
                </button>
                <div class="profile-dropdown" id="profileDropdown">
                    <div class="profile-dropdown-header">
                        <strong><%= loggedInUser.getName() %></strong>
                        <span><%= loggedInUser.getEmail() %></span>
                    </div>
                    <div class="dropdown-divider"></div>
                    <a href="#"      class="profile-item"><i class="fa-regular fa-user"></i> My Profile</a>
                    <a href="#"      class="profile-item"><i class="fa-solid fa-clock-rotate-left"></i> Order History</a>
                    <a href="#"      class="profile-item"><i class="fa-solid fa-wallet"></i> Platter Wallet</a>
                    <a href="#"      class="profile-item"><i class="fa-solid fa-gear"></i> Settings</a>
                    <div class="dropdown-divider"></div>
                    <a href="logout" class="profile-item logout-link">
                        <i class="fa-solid fa-arrow-right-from-bracket"></i> Logout
                    </a>
                </div>
            </div>

            <button class="hamburger-btn" id="hamburgerBtn" aria-label="Open menu">
                <i class="fa-solid fa-bars-staggered"></i>
            </button>

        </div>
    </div>
</header>

<!-- Mobile Side Drawer -->
<div class="mobile-drawer" id="mobileDrawer">
    <div class="drawer-header">
        <div class="logo"><span>P</span>latter</div>
        <button class="close-drawer-btn" id="closeDrawerBtn" aria-label="Close menu">
            <i class="fa-solid fa-xmark"></i>
        </button>
    </div>
    <div class="drawer-body">
        <nav class="drawer-nav">
            <a href="home"        class="drawer-nav-item"><i class="fa-solid fa-house"></i> Home</a>
            <a href="restaurants" class="drawer-nav-item"><i class="fa-solid fa-utensils"></i> Restaurants</a>
            <a href="favorites"           class="drawer-nav-item"><i class="fa-regular fa-heart"></i> Favorites
                <span class="nav-badge fav-badge-count" <%= favCount == 0 ? "style=\"display: none;\"" : "" %>><%= favCount %></span>
            </a>
            <a href="#"           class="drawer-nav-item"><i class="fa-solid fa-bag-shopping"></i> My Cart
                <span class="nav-badge sec cart-badge-count" <%= cartCount == 0 ? "style=\"display: none;\"" : "" %>><%= cartCount %></span>
            </a>
            <a href="#"           class="drawer-nav-item"><i class="fa-regular fa-user"></i> My Profile</a>
            <a href="#"           class="drawer-nav-item"><i class="fa-solid fa-headset"></i> Help &amp; Support</a>
        </nav>
    </div>
    <div class="drawer-footer">
        <button class="drawer-logout-btn" onclick="window.location.href='logout'">
            <i class="fa-solid fa-arrow-right-from-bracket"></i> Logout
        </button>
    </div>
</div>
<div class="drawer-overlay" id="drawerOverlay"></div>


<!-- =========================================================
     CINEMATIC HERO BANNER
     ========================================================= -->
<section class="menu-hero">
    <% if (restaurant != null && restaurant.getImagePath() != null) { %>
    <img src="<%= restaurant.getImagePath() %>"
         alt="<%= restaurant.getName() %>"
         class="menu-hero-image">
    <% } else { %>
    <img src="images/restaurants/pizza.jpg" alt="Restaurant" class="menu-hero-image">
    <% } %>

    <div class="menu-hero-overlay"></div>

    <div class="menu-hero-content">

        <!-- Breadcrumb -->
        <div class="menu-breadcrumb">
            <a href="restaurants" class="breadcrumb-link">
                <i class="fa-solid fa-arrow-left"></i> All Restaurants
            </a>
            <span class="breadcrumb-sep">/</span>
            <span class="breadcrumb-current"><%= restName %></span>
        </div>

        <!-- Status badges -->
        <div class="menu-hero-top-badges">
            <% if (restaurant != null) { %>
                <% if (restaurant.isOpen()) { %>
                    <span class="hero-open-badge open">
                        <i class="fa-solid fa-circle" style="font-size:.55rem;"></i> Open Now
                    </span>
                <% } else { %>
                    <span class="hero-open-badge closed">
                        <i class="fa-solid fa-circle" style="font-size:.55rem;"></i> Closed
                    </span>
                <% } %>
                <% if (restaurant.isTopRated()) { %>
                    <span class="hero-top-rated-badge">
                        <i class="fa-solid fa-star"></i> Top Rated
                    </span>
                <% } %>
                <% if (restaurant.isFreeDelivery()) { %>
                    <span class="hero-free-del-badge">
                        <i class="fa-solid fa-truck-fast"></i> Free Delivery
                    </span>
                <% } %>
            <% } %>
        </div>

        <!-- Restaurant name -->
        <h1 class="menu-restaurant-name"><%= restName %></h1>

        <!-- Cuisine tags -->
        <% if (restaurant != null && restaurant.getCuisine() != null) { %>
        <div class="menu-cuisine-tags">
            <% String[] cuisines = restaurant.getCuisine().split(",");
               for (String c : cuisines) { %>
            <span class="cuisine-tag-pill"><%= c.trim() %></span>
            <% } %>
        </div>
        <% } %>

        <!-- Stats bar -->
        <% if (restaurant != null) { %>
        <div class="menu-hero-stats">
            <div class="hero-rating-chip">
                <i class="fa-solid fa-star"></i>
                <%= restaurant.getRating() %>
            </div>
            <div class="hero-stat-divider"></div>
            <div class="hero-stat-item">
                <i class="fa-regular fa-clock"></i>
                <%= restaurant.getDeliveryTime() %>
            </div>
            <div class="hero-stat-divider"></div>
            <div class="hero-stat-item">
                <i class="fa-solid fa-location-dot"></i>
                <%= restaurant.getDistance() %> km away
            </div>
            <div class="hero-stat-divider"></div>
            <div class="hero-stat-item">
                <i class="fa-solid fa-indian-rupee-sign"></i>
                &#8377;<%= restaurant.getCostForOne() %> for two
            </div>
        </div>
        <% } %>

    </div>
</section>


<!-- =========================================================
     MENU CONTENT AREA
     ========================================================= -->
<div class="menu-content-area" id="menuContentArea">

    <!-- Filter Chips -->
    <div class="filter-chips-bar scroll-reveal">
        <button class="filter-chip active" data-filter="all">
            <i class="fa-solid fa-border-all"></i> All
        </button>
        <button class="filter-chip" data-filter="veg">
            <span class="chip-veg-dot"></span> Veg
        </button>
        <button class="filter-chip" data-filter="nonveg">
            <span class="chip-nonveg-dot"></span> Non-Veg
        </button>
        <button class="filter-chip" data-filter="bestseller">
            <i class="fa-solid fa-star"></i> Bestseller
        </button>
        <button class="filter-chip" data-filter="toprated">
            <i class="fa-solid fa-fire"></i> Top Rated
        </button>
        <button class="filter-chip" data-filter="under200">
            <i class="fa-solid fa-indian-rupee-sign"></i> Under ₹200
        </button>
    </div>

    <%
        // Group dishes by section
        java.util.LinkedHashMap<String, java.util.List<Dish>> sectionMap =
            new java.util.LinkedHashMap<String, java.util.List<Dish>>();
        sectionMap.put("Recommended For You", new java.util.ArrayList<Dish>());
        sectionMap.put("Main Course",         new java.util.ArrayList<Dish>());
        sectionMap.put("Rice & Biryani",      new java.util.ArrayList<Dish>());
        sectionMap.put("Wraps",               new java.util.ArrayList<Dish>());
        sectionMap.put("Desserts",            new java.util.ArrayList<Dish>());

        boolean anyDishes = (dishes != null && !dishes.isEmpty());
        if (anyDishes) {
            for (Dish d : dishes) {
                String sec = d.getSection();
                if (sec == null) sec = "";
                sec = sec.toLowerCase().trim();
                if      (sec.contains("main"))                               sectionMap.get("Main Course").add(d);
                else if (sec.contains("rice") || sec.contains("biryani"))    sectionMap.get("Rice & Biryani").add(d);
                else if (sec.contains("wrap"))                               sectionMap.get("Wraps").add(d);
                else if (sec.contains("dessert") || sec.contains("sweet"))   sectionMap.get("Desserts").add(d);
                else                                                         sectionMap.get("Recommended For You").add(d);
            }
        }
    %>

    <% if (!anyDishes) { %>
    <div class="menu-empty-state">
        <div class="menu-empty-icon"><i class="fa-solid fa-bowl-food"></i></div>
        <h3>No Dishes Available Yet</h3>
        <p>This restaurant’s menu is being updated. Check back soon!</p>
    </div>
    <% } else { %>

    <div class="menu-sections-wrap" id="menuDishesGrid">
    <%
        int cardDelay = 0;
        for (java.util.Map.Entry<String, java.util.List<Dish>> entry : sectionMap.entrySet()) {
            String sectionName = entry.getKey();
            java.util.List<Dish> sectionDishes = entry.getValue();
            if (sectionDishes.isEmpty()) continue;
    %>
        <div class="menu-section-block">
            <div class="menu-section-header">
                <h2 class="menu-section-title"><%= sectionName %></h2>
                <span class="menu-section-count"><%= sectionDishes.size() %> item<%= sectionDishes.size() != 1 ? "s" : "" %></span>
            </div>
            <div class="menu-section-dishes">
            <% for (Dish d : sectionDishes) {
                cardDelay += 40;
                String vegClass    = d.isVeg() ? "veg"    : "non-veg";
                String vegDataAttr = d.isVeg() ? "veg"    : "nonveg";
                String tag = d.getTag();
                String tagBadgeClass = "", tagIcon = "";
                if (tag != null && !tag.isEmpty()) {
                    switch (tag.toLowerCase()) {
                        case "trending":   tagBadgeClass="trending";   tagIcon="fa-fire";    break;
                        case "bestseller": tagBadgeClass="bestseller"; tagIcon="fa-star";    break;
                        case "new":        tagBadgeClass="new-tag";    tagIcon="fa-sparkles"; break;
                        case "most loved": tagBadgeClass="most-loved"; tagIcon="fa-heart";   break;
                        default:           tagBadgeClass="trending";   tagIcon="fa-fire";    break;
                    }
                }
                String tagLower = (tag != null) ? tag.toLowerCase() : "";
            %>
                <div class="menu-dish-card scroll-reveal"
                     style="animation-delay: <%= cardDelay %>ms;"
                     data-type="<%= vegDataAttr %>"
                     data-name="<%= d.getName().toLowerCase() %>"
                     data-tag="<%= tagLower %>"
                     data-rating="<%= d.getRating() %>"
                     data-price="<%= d.getPrice() %>"
                     id="dishCard-<%= d.getDishId() %>">

                    <!-- Left: Image -->
                    <div class="dish-img-wrap">
                        <img src="<%= d.getImagePath() %>" alt="<%= d.getName() %>" loading="lazy">
                        <% if (tag != null && !tag.isEmpty()) { %>
                        <span class="dish-tag-badge <%= tagBadgeClass %>">
                            <i class="fa-solid <%= tagIcon %>"></i> <%= tag %>
                        </span>
                        <% } %>
                    </div>

                    <!-- Middle: Info -->
                    <div class="dish-body">
                        <div class="dish-name-row">
                            <div class="dish-type-indicator <%= vegClass %>" title="<%= d.isVeg() ? "Vegetarian" : "Non-Vegetarian" %>">
                                <span class="dot"></span>
                            </div>
                            <h3 class="dish-title"><%= d.getName() %></h3>
                        </div>
                        <% if (d.getDescription() != null && !d.getDescription().isEmpty()) { %>
                        <p class="dish-desc"><%= d.getDescription() %></p>
                        <% } %>
                        <div class="dish-meta-row">
                            <div class="dish-rating-chip">
                                <i class="fa-solid fa-star"></i>
                                <span><%= d.getRating() %></span>
                            </div>
                            <% if (d.getCalories() != null && !d.getCalories().isEmpty()) { %>
                            <span class="dish-calories-tag"><%= d.getCalories() %></span>
                            <% } %>
                        </div>
                    </div>

                    <!-- Right: Price + Wishlist + Add -->
                    <div class="dish-row-right">
                        <span class="dish-price">&#8377;<%= d.getPrice() %></span>
                        <%
                            boolean isFavDish = false;
                            if (loggedInUser != null) {
                                isFavDish = new com.DAOImpl.FavoriteDAOImpl().isDishFavorite(loggedInUser.getUserId(), d.getDishId());
                            }
                            String favDishClass = isFavDish ? "dish-wishlist-btn active" : "dish-wishlist-btn";
                            String favDishIcon = isFavDish ? "fa-solid fa-heart" : "fa-regular fa-heart";
                            String favDishTitle = isFavDish ? "Remove from wishlist" : "Add to wishlist";
                        %>
                        <button class="<%= favDishClass %>" data-dish-id="<%= d.getDishId() %>" aria-label="<%= favDishTitle %>" title="<%= favDishTitle %>">
                            <i class="<%= favDishIcon %>"></i>
                        </button>
                        <div class="dish-add-wrap">
                            <button class="add-to-cart-btn" id="addBtn-<%= d.getDishId() %>"
                                    onclick="handleAddToCart(<%= d.getDishId() %>)">
                                <i class="fa-solid fa-plus"></i> Add
                            </button>
                            <div class="qty-selector" id="qtySel-<%= d.getDishId() %>">
                                <button class="qty-btn" onclick="changeQty(<%= d.getDishId() %>, -1)">
                                    <i class="fa-solid fa-minus"></i>
                                </button>
                                <span class="qty-num" id="qtyNum-<%= d.getDishId() %>">1</span>
                                <button class="qty-btn" onclick="changeQty(<%= d.getDishId() %>, 1)">
                                    <i class="fa-solid fa-plus"></i>
                                </button>
                            </div>
                        </div>
                    </div>

                </div><!-- /menu-dish-card -->
            <% } %>
            </div><!-- /menu-section-dishes -->
        </div><!-- /menu-section-block -->
    <% } %>
    </div><!-- /menu-sections-wrap -->

    <% } %>

    <!-- Fixed Cart Bar -->
    <div class="menu-cart-bar" id="menuCartBar">
        <div class="cart-bar-left">
            <div class="cart-icon-badge">
                <i class="fa-solid fa-bag-shopping"></i>
                <span class="cart-count-dot" id="cartBadgeNum">0</span>
            </div>
            <div class="cart-bar-text">
                <span class="cart-bar-count-text" id="cartBarCount">0 items added</span>
                <span class="cart-bar-names" id="cartBarNames"></span>
            </div>
        </div>
        <div class="cart-bar-mid">
            <span class="cart-bar-total-amount" id="cartBarTotal">&#8377;0</span>
            <span class="cart-bar-delivery-est">Estimated delivery: <%= restaurant != null && restaurant.getDeliveryTime() != null ? restaurant.getDeliveryTime() : "30 min" %></span>
        </div>
        <button class="cart-bar-view-btn" onclick="window.location.href='cart'">
            View Cart <i class="fa-solid fa-arrow-right"></i>
        </button>
    </div>

</div><!-- /menu-content-area -->


<!-- =========================================================
     FOOTER
     ========================================================= -->
<footer class="premium-footer scroll-reveal">
    <div class="footer-container">
        <div class="footer-brand-row">
            <a href="home" class="footer-logo"><span>P</span>latter</a>
        </div>
        <div class="footer-links-grid">
            <div class="footer-column">
                <h4 class="column-title">Eternal</h4>
                <ul class="column-links">
                    <li><a href="#">Platter</a></li>
                    <li><a href="#">Platter Express</a></li>
                    <li><a href="#">District</a></li>
                    <li><a href="#">Hyperpure</a></li>
                    <li><a href="#">Feeding India</a></li>
                    <li><a href="#">Investor Relations</a></li>
                </ul>
            </div>
            <div class="footer-column">
                <h4 class="column-title">For Restaurants</h4>
                <ul class="column-links">
                    <li><a href="#">Partner With Us</a></li>
                    <li><a href="#">Apps For You</a></li>
                    <li><a href="#">Restaurant Consulting</a></li>
                </ul>
            </div>
            <div class="footer-column">
                <h4 class="column-title">For Delivery Partners</h4>
                <ul class="column-links">
                    <li><a href="#">Partner With Us</a></li>
                    <li><a href="#">Apps For You</a></li>
                </ul>
            </div>
            <div class="footer-column">
                <h4 class="column-title">Learn More</h4>
                <ul class="column-links">
                    <li><a href="#">Privacy</a></li>
                    <li><a href="#">Security</a></li>
                    <li><a href="#">Terms of Service</a></li>
                    <li><a href="#">Help &amp; Support</a></li>
                    <li><a href="#">Blog</a></li>
                </ul>
            </div>
        </div>
        <hr class="footer-divider">
        <p class="footer-bottom-text">
            By continuing past this page, you agree to our Terms of Service, Cookie Policy, Privacy Policy and
            Content Policies. All trademarks are properties of their respective owners.
            2008-2026 &copy; Platter&trade; Ltd. All rights reserved.
        </p>
    </div>
</footer>


<!-- =========================================================
     JAVASCRIPT
     ========================================================= -->
<script>
(function () {
    "use strict";

    /* ── Navbar scroll behaviour ── */
    var navbar = document.getElementById('mainNavbar');
    var lastScrollY = window.scrollY;
    window.addEventListener('scroll', function () {
        var y = window.scrollY;
        navbar.classList.toggle('scrolled', y > 80);
        if (y > lastScrollY + 10 && y > 300) navbar.classList.add('navbar-hidden');
        else if (y < lastScrollY - 5) navbar.classList.remove('navbar-hidden');
        lastScrollY = y;
    }, { passive: true });

    /* ── Profile dropdown ── */
    var profileTrigger = document.getElementById('profileTrigger');
    if (profileTrigger) {
        profileTrigger.addEventListener('click', function (e) { e.stopPropagation(); profileTrigger.classList.toggle('active'); });
        document.addEventListener('click', function (e) { if (!profileTrigger.contains(e.target)) profileTrigger.classList.remove('active'); });
    }

    /* ── Mobile drawer ── */
    var hamburgerBtn   = document.getElementById('hamburgerBtn');
    var mobileDrawer   = document.getElementById('mobileDrawer');
    var drawerOverlay  = document.getElementById('drawerOverlay');
    var closeDrawerBtn = document.getElementById('closeDrawerBtn');
    function openDrawer()  { mobileDrawer.classList.add('is-open');    drawerOverlay.classList.add('is-open');    document.body.style.overflow = 'hidden'; }
    function closeDrawer() { mobileDrawer.classList.remove('is-open'); drawerOverlay.classList.remove('is-open'); document.body.style.overflow = ''; }
    if (hamburgerBtn)   hamburgerBtn.addEventListener('click', openDrawer);
    if (closeDrawerBtn) closeDrawerBtn.addEventListener('click', closeDrawer);
    if (drawerOverlay)  drawerOverlay.addEventListener('click', closeDrawer);

    /* ── Scroll reveal ── */
    var revealObs = new IntersectionObserver(function (entries) {
        entries.forEach(function (entry) {
            if (entry.isIntersecting) { entry.target.classList.add('revealed'); revealObs.unobserve(entry.target); }
        });
    }, { threshold: 0.05 });
    document.querySelectorAll('.scroll-reveal').forEach(function (el) { revealObs.observe(el); });

    /* ── Wishlist toggle ── */
    document.querySelectorAll('.dish-wishlist-btn').forEach(function (btn) {
        btn.addEventListener('click', function (e) {
            e.stopPropagation();
            var dishId = btn.getAttribute('data-dish-id');
            if (!dishId) return;

            fetch('favorites', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'type=dish&id=' + dishId
            })
            .then(function (res) {
                if (res.ok) return res.json();
                throw new Error('Network response was not ok.');
            })
            .then(function (data) {
                if (data.status === 'success') {
                    btn.classList.toggle('active', data.added);
                    var icon = btn.querySelector('i');
                    if (data.added) {
                        icon.className = 'fa-solid fa-heart';
                        btn.title = 'Remove from wishlist';
                    } else {
                        icon.className = 'fa-regular fa-heart';
                        btn.title = 'Add to wishlist';
                    }
                    
                    // Update header and mobile drawer badges
                    document.querySelectorAll('.fav-badge-count').forEach(function (badge) {
                        badge.textContent = data.favoriteCount;
                        if (data.favoriteCount > 0) {
                            badge.style.display = '';
                        } else {
                            badge.style.display = 'none';
                        }
                    });
                }
            })
            .catch(function (err) {
                console.error('Error toggling favorite:', err);
            });
        });
    });

    /* ── Filter Chips ── */
    var chips    = document.querySelectorAll('.filter-chip');
    var allCards = document.querySelectorAll('.menu-dish-card');

    function applyFilter(filter) {
        allCards.forEach(function (card) {
            var show;
            if      (filter === 'all')        show = true;
            else if (filter === 'veg')        show = card.dataset.type === 'veg';
            else if (filter === 'nonveg')     show = card.dataset.type === 'nonveg';
            else if (filter === 'bestseller') show = (card.dataset.tag || '').toLowerCase() === 'bestseller';
            else if (filter === 'toprated')   show = parseFloat(card.dataset.rating || 0) >= 4.5;
            else if (filter === 'under200')   show = parseInt(card.dataset.price || 9999) < 200;
            card.style.display = show ? '' : 'none';
        });
        updateSectionVisibility();
    }

    chips.forEach(function (chip) {
        chip.addEventListener('click', function () {
            chips.forEach(function (c) { c.classList.remove('active'); });
            chip.classList.add('active');
            applyFilter(chip.dataset.filter);
        });
    });

    /* ── Section visibility after filtering ── */
    function updateSectionVisibility() {
        document.querySelectorAll('.menu-section-block').forEach(function (sec) {
            var visible = false;
            sec.querySelectorAll('.menu-dish-card').forEach(function (c) { if (c.style.display !== 'none') visible = true; });
            sec.style.display = visible ? '' : 'none';
        });
    }

    /* ── Override navbar search for client-side menu filtering ── */
    var navForm  = document.querySelector('.nav-search-bar');
    var navInput = document.getElementById('navSearchInput');
    if (navInput) {
        navInput.placeholder = 'Search dishes in <%= restName %>...';
        if (navForm) {
            navForm.addEventListener('submit', function (e) {
                e.preventDefault();
                filterBySearch(navInput.value.trim().toLowerCase());
            });
        }
        navInput.addEventListener('input', function () { filterBySearch(this.value.trim().toLowerCase()); });
    }

    function filterBySearch(q) {
        if (!q) {
            allCards.forEach(function (c) { c.style.display = ''; });
            if (chips[0]) { chips.forEach(function(c){c.classList.remove('active');}); chips[0].classList.add('active'); }
        } else {
            allCards.forEach(function (c) {
                var name = c.dataset.name || '';
                var desc = (c.querySelector('.dish-desc') || {}).textContent || '';
                c.style.display = (name.includes(q) || desc.toLowerCase().includes(q)) ? '' : 'none';
            });
            chips.forEach(function(c){c.classList.remove('active');});
        }
        updateSectionVisibility();
    }

})();

/* ── Cart helpers (global scope for onclick= attributes) ── */

function showStepperState(dishId, qty) {
    var addBtn = document.getElementById('addBtn-' + dishId);
    var qtySel = document.getElementById('qtySel-' + dishId);
    var qtyNum = document.getElementById('qtyNum-' + dishId);
    if (!addBtn || !qtySel || !qtyNum) return;
    if (qty <= 0) {
        addBtn.classList.remove('hidden');
        qtySel.classList.remove('visible');
        qtyNum.textContent = '1';
    } else {
        qtyNum.textContent = qty;
        addBtn.classList.add('hidden');
        qtySel.classList.add('visible');
    }
}

function revertToAddButton(dishId) { showStepperState(dishId, 0); }

function updateCartBar(count, total) {
    var bar     = document.getElementById('menuCartBar');
    if (!bar) return;
    var badgeEl = document.getElementById('cartBadgeNum');
    var countEl = document.getElementById('cartBarCount');
    var totalEl = document.getElementById('cartBarTotal');
    var namesEl = document.getElementById('cartBarNames');

    if (badgeEl) badgeEl.textContent = count;
    if (countEl) countEl.textContent = count + ' item' + (count !== 1 ? 's' : '') + ' added';
    if (totalEl) totalEl.textContent = '₹' + total;

    if (namesEl) {
        var names = [];
        document.querySelectorAll('.menu-dish-card').forEach(function (card) {
            var id = card.id.replace('dishCard-', '');
            var qs = document.getElementById('qtySel-' + id);
            if (qs && qs.classList.contains('visible')) {
                var t = card.querySelector('.dish-title');
                if (t) names.push(t.textContent.trim());
            }
        });
        namesEl.textContent = names.slice(0, 3).join(', ') + (names.length > 3 ? '…' : '');
    }

    if (count > 0) { bar.style.display = 'flex'; document.body.classList.add('has-cart'); }
    else           { bar.style.display = 'none';  document.body.classList.remove('has-cart'); }
}

async function handleAddToCart(dishId) {
    try {
        var res = await fetch('cart-api', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'dishId=' + dishId + '&action=add'
        });
        if (!res.ok) return;
        var data = await res.json();
        showStepperState(dishId, data.newQty);
        updateCartBar(data.cartItemCount, data.cartTotal);
    } catch (err) { console.error('Cart error:', err); }
}

async function changeQty(dishId, delta) {
    try {
        var res = await fetch('cart-api', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'dishId=' + dishId + '&action=' + (delta > 0 ? 'increment' : 'decrement')
        });
        if (!res.ok) return;
        var data = await res.json();
        if (data.newQty <= 0) revertToAddButton(dishId);
        else document.getElementById('qtyNum-' + dishId).textContent = data.newQty;
        updateCartBar(data.cartItemCount, data.cartTotal);
    } catch (err) { console.error('Cart error:', err); }
}

/* ── Restore cart state from server on page load ── */
(function () {
    fetch('cart-api', { method: 'GET' })
        .then(function (res) { return res.ok ? res.json() : null; })
        .then(function (data) {
            if (!data) return;
            if (data.items && Array.isArray(data.items)) {
                data.items.forEach(function (item) { showStepperState(item.dishId, item.quantity); });
            }
            updateCartBar(data.cartItemCount, data.cartTotal);
        })
        .catch(function (err) { console.warn('Cart restore failed:', err); });
})();
</script>

</body>
</html>
