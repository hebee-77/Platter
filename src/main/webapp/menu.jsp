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
<link rel="stylesheet" href="css/menu.css?v=1.0.0">
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

            <a href="#" class="nav-btn-icon" aria-label="Favorites" title="Favorites">
                <i class="fa-regular fa-heart"></i>
            </a>

            <a href="#" class="nav-btn-icon" aria-label="Cart" title="Cart">
                <i class="fa-solid fa-bag-shopping"></i>
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
            <a href="#"           class="drawer-nav-item"><i class="fa-regular fa-heart"></i> Favorites</a>
            <a href="#"           class="drawer-nav-item"><i class="fa-solid fa-bag-shopping"></i> My Cart</a>
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
<div class="menu-content-area">

    <!-- Filter row -->
    <div class="menu-filter-row scroll-reveal">
        <div class="menu-filter-left">
            <h2 class="menu-section-heading">Our Menu</h2>
            <span class="menu-dish-count" id="dishCountLabel"><%= dishCount %> items available</span>
        </div>

        <div class="menu-type-tabs" role="group" aria-label="Filter by type">
            <button class="type-tab active" id="tabAll" data-filter="all">
                <i class="fa-solid fa-border-all"></i> All
            </button>
            <button class="type-tab" id="tabVeg" data-filter="veg">
                <span class="tab-veg-dot"></span> Veg
            </button>
            <button class="type-tab" id="tabNonVeg" data-filter="nonveg">
                <span class="tab-non-veg-dot"></span> Non-Veg
            </button>
        </div>
    </div>

    <!-- Dish grid -->
    <div class="menu-dishes-grid" id="menuDishesGrid">

        <%
            boolean hasDishes = (dishes != null && !dishes.isEmpty());
            if (hasDishes) {
                int cardDelay = 0;
                for (Dish d : dishes) {
                    cardDelay += 60;
                    String vegClass    = d.isVeg() ? "veg" : "non-veg";
                    String vegDataAttr = d.isVeg() ? "veg" : "nonveg";

                    // Tag badge class
                    String tag = d.getTag();
                    String tagBadgeClass = "";
                    String tagIcon = "";
                    if (tag != null && !tag.isEmpty()) {
                        switch (tag.toLowerCase()) {
                            case "trending":        tagBadgeClass = "trending";   tagIcon = "fa-fire";     break;
                            case "bestseller":      tagBadgeClass = "bestseller"; tagIcon = "fa-star";     break;
                            case "new":             tagBadgeClass = "new-tag";    tagIcon = "fa-sparkles"; break;
                            case "most loved":      tagBadgeClass = "most-loved"; tagIcon = "fa-heart";    break;
                            default:                tagBadgeClass = "trending";   tagIcon = "fa-fire";     break;
                        }
                    }
        %>

        <div class="menu-dish-card"
             style="animation-delay: <%= cardDelay %>ms;"
             data-type="<%= vegDataAttr %>"
             data-name="<%= d.getName().toLowerCase() %>"
             id="dishCard-<%= d.getDishId() %>">

            <!-- Image -->
            <div class="dish-img-wrap">
                <img src="<%= d.getImagePath() %>" alt="<%= d.getName() %>" loading="lazy">

                <% if (tag != null && !tag.isEmpty()) { %>
                <span class="dish-tag-badge <%= tagBadgeClass %>">
                    <i class="fa-solid <%= tagIcon %>"></i> <%= tag %>
                </span>
                <% } %>

                <div class="dish-type-indicator <%= vegClass %>" title="<%= d.isVeg() ? "Vegetarian" : "Non-Vegetarian" %>">
                    <span class="dot"></span>
                </div>

                <button class="dish-wishlist-btn" aria-label="Wishlist" title="Add to wishlist">
                    <i class="fa-regular fa-heart"></i>
                </button>
            </div>

            <!-- Body -->
            <div class="dish-body">

                <div class="dish-name-row">
                    <h3 class="dish-title"><%= d.getName() %></h3>
                    <% if (d.getCalories() != null && !d.getCalories().isEmpty()) { %>
                    <span class="dish-calories-tag"><%= d.getCalories() %></span>
                    <% } %>
                </div>

                <% if (d.getDescription() != null && !d.getDescription().isEmpty()) { %>
                <p class="dish-desc"><%= d.getDescription() %></p>
                <% } %>

                <div class="dish-meta-row">
                    <div class="dish-rating-chip">
                        <i class="fa-solid fa-star"></i>
                        <span><%= d.getRating() %></span>
                    </div>
                    <span class="dish-price">&#8377;<%= d.getPrice() %></span>
                </div>

                <div class="dish-action-row">
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
        </div>

        <% } } else { %>

        <!-- Empty state -->
        <div class="menu-empty-state">
            <div class="menu-empty-icon">
                <i class="fa-solid fa-bowl-food"></i>
            </div>
            <h3>No Dishes Available Yet</h3>
            <p>
                This restaurant's menu is being updated. Check back soon for delicious options!
            </p>
        </div>

        <% } %>

    </div><!-- /menu-dishes-grid -->

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
    var navbar    = document.getElementById('mainNavbar');
    var lastScrollY = window.scrollY;
    window.addEventListener('scroll', function () {
        var y = window.scrollY;
        navbar.classList.toggle('scrolled', y > 80);
        if (y > lastScrollY + 10 && y > 300) {
            navbar.classList.add('navbar-hidden');
        } else if (y < lastScrollY - 5) {
            navbar.classList.remove('navbar-hidden');
        }
        lastScrollY = y;
    }, { passive: true });

    /* ── Profile dropdown ── */
    var profileTrigger = document.getElementById('profileTrigger');
    if (profileTrigger) {
        profileTrigger.addEventListener('click', function (e) {
            e.stopPropagation();
            profileTrigger.classList.toggle('active');
        });
        document.addEventListener('click', function (e) {
            if (!profileTrigger.contains(e.target)) profileTrigger.classList.remove('active');
        });
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
    var revealEls = document.querySelectorAll('.scroll-reveal');
    var revealObs = new IntersectionObserver(function (entries) {
        entries.forEach(function (entry) {
            if (entry.isIntersecting) { entry.target.classList.add('revealed'); revealObs.unobserve(entry.target); }
        });
    }, { threshold: 0.08 });
    revealEls.forEach(function (el) { revealObs.observe(el); });

    /* ── Wishlist toggle ── */
    document.querySelectorAll('.dish-wishlist-btn').forEach(function (btn) {
        btn.addEventListener('click', function (e) {
            e.stopPropagation();
            btn.classList.toggle('is-fav');
            var icon = btn.querySelector('i');
            if (btn.classList.contains('is-fav')) {
                icon.classList.replace('fa-regular', 'fa-solid');
            } else {
                icon.classList.replace('fa-solid', 'fa-regular');
            }
        });
    });

    /* ── Veg / Non-Veg filter tabs ── */
    var tabs        = document.querySelectorAll('.type-tab');
    var allCards    = document.querySelectorAll('.menu-dish-card');
    var countLabel  = document.getElementById('dishCountLabel');

    tabs.forEach(function (tab) {
        tab.addEventListener('click', function () {
            tabs.forEach(function (t) { t.classList.remove('active'); });
            tab.classList.add('active');

            var filter  = tab.dataset.filter;
            var visible = 0;

            allCards.forEach(function (card) {
                var type = card.dataset.type; // 'veg' or 'nonveg'
                var show = (filter === 'all') ||
                           (filter === 'veg'    && type === 'veg') ||
                           (filter === 'nonveg' && type === 'nonveg');

                if (show) {
                    card.style.display = '';
                    visible++;
                } else {
                    card.style.display = 'none';
                }
            });

            if (countLabel) {
                countLabel.textContent = visible + ' item' + (visible !== 1 ? 's' : '') + ' available';
            }
        });
    });

})();

/* ── Cart quantity helpers (global scope for onclick= attributes) ── */
function handleAddToCart(dishId) {
    var addBtn  = document.getElementById('addBtn-' + dishId);
    var qtySel  = document.getElementById('qtySel-' + dishId);
    var qtyNum  = document.getElementById('qtyNum-' + dishId);
    if (!addBtn || !qtySel) return;
    qtyNum.textContent = '1';
    addBtn.classList.add('hidden');
    qtySel.classList.add('visible');
}

function changeQty(dishId, delta) {
    var qtyNum = document.getElementById('qtyNum-' + dishId);
    var qtySel = document.getElementById('qtySel-' + dishId);
    var addBtn = document.getElementById('addBtn-' + dishId);
    if (!qtyNum) return;

    var current = parseInt(qtyNum.textContent) || 1;
    var next    = current + delta;

    if (next <= 0) {
        qtySel.classList.remove('visible');
        addBtn.classList.remove('hidden');
        qtyNum.textContent = '1';
    } else {
        qtyNum.textContent = next;
    }
}
</script>

</body>
</html>
