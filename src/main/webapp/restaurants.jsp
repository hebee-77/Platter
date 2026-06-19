<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.Model.User, com.Model.Restaurant, java.util.List" %>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Platter | All Restaurants</title>
<meta name="description" content="Browse all restaurants on Platter — search, filter by rating, delivery speed, and more.">

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
<link rel="stylesheet" href="css/restaurants.css?v=1.0.4">
</head>

<body>

<!-- Background Blobs -->
<div class="blur blob-1"></div>
<div class="blur blob-2"></div>
<div class="blur blob-3"></div>

<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");

    String searchQuery  = (String)  request.getAttribute("searchQuery");
    String activeFilter = (String)  request.getAttribute("activeFilter");
    Integer totalCount  = (Integer) request.getAttribute("totalCount");

    if (searchQuery  == null) searchQuery  = "";
    if (activeFilter == null) activeFilter = "";
    if (totalCount   == null) totalCount   = 0;

    /* Pre-compute safe chip class strings (avoids double-quote conflicts in JSP attributes) */
    String qParam       = searchQuery.isEmpty() ? "" : "?q=" + searchQuery;
    String qParamAmp    = searchQuery.isEmpty() ? "" : "&q=" + searchQuery;
    String chipAll      = "all".equals(activeFilter)           ? "filter-chip active" : "filter-chip";
    String chipTopRated = "topRated".equals(activeFilter)      ? "filter-chip active" : "filter-chip";
    String chipFree     = "freeDelivery".equals(activeFilter)  ? "filter-chip active" : "filter-chip";
    String chipOpen     = "openNow".equals(activeFilter)       ? "filter-chip active" : "filter-chip";
    String chipFast     = "fastDelivery".equals(activeFilter)  ? "filter-chip active" : "filter-chip";

    /* Pre-compute section label */
    String sectionLabel;
    if (!searchQuery.isEmpty()) {
        sectionLabel = "Results for &ldquo;" + searchQuery + "&rdquo;";
    } else if ("topRated".equals(activeFilter)) {
        sectionLabel = "&#11088; Top Rated Restaurants";
    } else if ("freeDelivery".equals(activeFilter)) {
        sectionLabel = "Free Delivery Restaurants";
    } else if ("openNow".equals(activeFilter)) {
        sectionLabel = "Open Now";
    } else if ("fastDelivery".equals(activeFilter)) {
        sectionLabel = "&#9889; Fast Delivery Restaurants";
    } else {
        sectionLabel = "All Restaurants";
    }
%>

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
                   value="<%= searchQuery %>"
                   autocomplete="off">
            <% if (!activeFilter.isEmpty()) { %>
                <input type="hidden" name="filter" value="<%= activeFilter %>">
            <% } %>
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
            <a href="restaurants" class="drawer-nav-item active"><i class="fa-solid fa-utensils"></i> Restaurants</a>
            <a href="#"           class="drawer-nav-item"><i class="fa-regular fa-heart"></i> Favorites</a>
            <a href="#"           class="drawer-nav-item"><i class="fa-solid fa-bag-shopping"></i> My Cart</a>
            <a href="#"           class="drawer-nav-item"><i class="fa-regular fa-user"></i> My Profile</a>
            <a href="#"           class="drawer-nav-item"><i class="fa-solid fa-ticket"></i> Offers &amp; Coupons</a>
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
     HERO / HEADER SECTION
     ========================================================= -->
<section class="restaurants-hero">

    <div class="restaurants-hero-content">
        <h1 class="restaurants-page-title">
            All <span>Restaurants</span> <span class="title-count-badge"><%= totalCount %></span>
        </h1>
        <p class="restaurants-page-subtitle">
            <i class="fa-solid fa-location-dot"></i>
            Discover curated restaurants near you &bull; Whitefield, Bangalore
        </p>
    </div>

    <!-- Filters and Sort Row -->
    <div class="hero-actions-row">
        <!-- Filter Chips -->
        <div class="filter-chips-row" role="group" aria-label="Filter restaurants">

            <a href="restaurants?filter=all<%= qParamAmp %>" class="<%= chipAll %>" id="chip-all">
                <i class="fa-solid fa-border-all"></i> All
            </a>

            <a href="restaurants?filter=topRated<%= qParamAmp %>" class="<%= chipTopRated %>" id="chip-toprated">
                <i class="fa-solid fa-star"></i> Top Rated
            </a>

            <a href="restaurants?filter=freeDelivery<%= qParamAmp %>" class="<%= chipFree %>" id="chip-free">
                <i class="fa-solid fa-truck-fast"></i> Free Delivery
            </a>

            <a href="restaurants?filter=openNow<%= qParamAmp %>" class="<%= chipOpen %>" id="chip-open">
                <i class="fa-solid fa-circle-dot"></i> Open Now
            </a>

            <a href="restaurants?filter=fastDelivery<%= qParamAmp %>" class="<%= chipFast %>" id="chip-fast">
                <i class="fa-solid fa-bolt"></i> Fast Delivery
            </a>

        </div>

        <select class="grid-sort-select" id="sortSelect" aria-label="Sort restaurants">
            <option value="default">Sort: Recommended</option>
            <option value="rating">Sort: Highest Rated</option>
            <option value="distance">Sort: Nearest First</option>
            <option value="price_low">Sort: Price Low&#8594;High</option>
            <option value="price_high">Sort: Price High&#8594;Low</option>
        </select>
    </div>

</section>

<!-- Subtle Premium Divider -->
<div class="premium-divider"></div>

<!-- =========================================================
     RESTAURANTS GRID SECTION
     ========================================================= -->
<section class="restaurants-page-section scroll-reveal" id="restaurantsGrid">

    <div class="restaurants-grid-header">
        <h2 class="grid-section-label"><%= sectionLabel %></h2>
    </div>

    <%
        List<Restaurant> restaurantList = (List<Restaurant>) request.getAttribute("restaurantList");
        boolean hasResults = (restaurantList != null && !restaurantList.isEmpty());
    %>

    <div class="restaurants-page-grid" id="restaurantsPageGrid">

        <% if (hasResults) {
            int cardDelay = 0;
            for (Restaurant r : restaurantList) {
                cardDelay += 60;
                String openStatusClass = r.isOpen() ? "status-open" : "status-closed";
                String openStatusText  = r.isOpen() ? "Open Now"    : "Closed";
        %>

        <div class="rest-card"
             style="animation-delay: <%= cardDelay %>ms;"
             data-name="<%= r.getName().toLowerCase() %>"
             data-cuisine="<%= r.getCuisine().toLowerCase() %>"
             data-rating="<%= r.getRating() %>"
             data-distance="<%= r.getDistance() %>"
             data-price="<%= r.getCostForOne() %>">

            <!-- Card Image -->
            <div class="rest-card-img-wrap">
                <img src="<%= r.getImagePath() %>" alt="<%= r.getName() %>" loading="lazy">

                <% if (r.isTopRated()) { %>
                    <span class="rest-badge-top badge-top-rated">
                        <i class="fa-solid fa-star"></i> Top Rated
                    </span>
                <% } else { %>
                    <span class="rest-badge-top badge-popular">
                        <i class="fa-solid fa-fire"></i> Popular
                    </span>
                <% } %>

                <span class="rest-open-status <%= openStatusClass %>"><%= openStatusText %></span>

                <button class="rest-fav-btn" aria-label="Add to favourites" title="Favourite">
                    <i class="fa-regular fa-heart"></i>
                </button>
            </div>

            <!-- Card Body -->
            <div class="rest-card-body">

                <div class="rest-card-row1">
                    <h3 class="rest-card-name"><%= r.getName() %></h3>
                    <div class="rest-rating-chip">
                        <i class="fa-solid fa-star"></i>
                        <span><%= r.getRating() %></span>
                    </div>
                </div>

                <p class="rest-cuisine"><%= r.getCuisine() %></p>

                <div class="rest-meta-row-premium">
                    <span><%= r.getDeliveryTime() %> mins</span>
                    <span class="meta-dot">&bull;</span>
                    <span>&#8377;<%= r.getCostForOne() %> for two</span>
                </div>

                <div class="rest-delivery-row">
                    <% if (r.isFreeDelivery()) { %>
                        <span class="delivery-status free"><span class="status-dot">🟢</span> Free Delivery</span>
                    <% } else { %>
                        <span class="delivery-status paid"><span class="status-dot">🟠</span> &#8377;40 Delivery</span>
                    <% } %>
                </div>

                <button class="rest-view-btn">
                    <i class="fa-solid fa-utensils"></i>
                    <span>View Menu</span>
                </button>

            </div>
        </div>

        <% } } else { %>

        <!-- Empty State -->
        <div class="empty-state">
            <div class="empty-icon-wrap">
                <i class="fa-solid fa-store-slash"></i>
            </div>
            <h3>No Restaurants Found</h3>
            <p>
                <% if (!searchQuery.isEmpty()) { %>
                    We couldn&apos;t find any restaurants matching
                    &ldquo;<strong><%= searchQuery %></strong>&rdquo;.
                    Try a different search term.
                <% } else { %>
                    No restaurants match the selected filter.
                    Try removing the filter to see all restaurants.
                <% } %>
            </p>
            <button class="empty-clear-btn" onclick="window.location.href='restaurants'">
                <i class="fa-solid fa-rotate-left"></i> Clear &amp; Browse All
            </button>
        </div>

        <% } %>

    </div>

</section>


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

    /* Navbar scroll behaviour */
    const navbar = document.getElementById('mainNavbar');
    let lastScrollY = window.scrollY;

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

    /* Profile dropdown */
    var profileTrigger = document.getElementById('profileTrigger');
    if (profileTrigger) {
        profileTrigger.addEventListener('click', function (e) {
            e.stopPropagation();
            profileTrigger.classList.toggle('active');
        });
        document.addEventListener('click', function (e) {
            if (!profileTrigger.contains(e.target)) {
                profileTrigger.classList.remove('active');
            }
        });
    }

    /* Mobile drawer */
    var hamburgerBtn   = document.getElementById('hamburgerBtn');
    var mobileDrawer   = document.getElementById('mobileDrawer');
    var drawerOverlay  = document.getElementById('drawerOverlay');
    var closeDrawerBtn = document.getElementById('closeDrawerBtn');

    function openDrawer()  {
        mobileDrawer.classList.add('is-open');
        drawerOverlay.classList.add('is-open');
        document.body.style.overflow = 'hidden';
    }
    function closeDrawer() {
        mobileDrawer.classList.remove('is-open');
        drawerOverlay.classList.remove('is-open');
        document.body.style.overflow = '';
    }

    if (hamburgerBtn)   hamburgerBtn.addEventListener('click', openDrawer);
    if (closeDrawerBtn) closeDrawerBtn.addEventListener('click', closeDrawer);
    if (drawerOverlay)  drawerOverlay.addEventListener('click', closeDrawer);

    /* Scroll reveal */
    var revealEls = document.querySelectorAll('.scroll-reveal');
    var revealObs = new IntersectionObserver(function (entries) {
        entries.forEach(function (entry) {
            if (entry.isIntersecting) {
                entry.target.classList.add('revealed');
                revealObs.unobserve(entry.target);
            }
        });
    }, { threshold: 0.08 });
    revealEls.forEach(function (el) { revealObs.observe(el); });

    /* Favourite button toggle */
    document.querySelectorAll('.rest-fav-btn').forEach(function (btn) {
        btn.addEventListener('click', function (e) {
            e.stopPropagation();
            btn.classList.toggle('is-fav');
            var icon = btn.querySelector('i');
            if (btn.classList.contains('is-fav')) {
                icon.classList.replace('fa-regular', 'fa-solid');
                btn.title = 'Remove from favourites';
            } else {
                icon.classList.replace('fa-solid', 'fa-regular');
                btn.title = 'Add to favourites';
            }
        });
    });

    /* Client-side sort */
    var sortSelect = document.getElementById('sortSelect');
    var grid       = document.getElementById('restaurantsPageGrid');

    if (sortSelect && grid) {
        sortSelect.addEventListener('change', function () {
            var cards = Array.from(grid.querySelectorAll('.rest-card'));
            var val   = sortSelect.value;

            cards.sort(function (a, b) {
                if (val === 'rating')     return parseFloat(b.dataset.rating)   - parseFloat(a.dataset.rating);
                if (val === 'distance')   return parseFloat(a.dataset.distance) - parseFloat(b.dataset.distance);
                if (val === 'price_low')  return parseInt(a.dataset.price)      - parseInt(b.dataset.price);
                if (val === 'price_high') return parseInt(b.dataset.price)      - parseInt(a.dataset.price);
                return 0;
            });

            cards.forEach(function (card, i) {
                card.style.animation = 'none';
                void card.offsetWidth;
                card.style.animationDelay = (i * 60) + 'ms';
                card.style.animation = '';
                grid.appendChild(card);
            });
        });
    }

    /* Keyboard shortcut Cmd/Ctrl+K focuses search */
    document.addEventListener('keydown', function (e) {
        if ((e.metaKey || e.ctrlKey) && e.key === 'k') {
            e.preventDefault();
            var inp = document.getElementById('restaurantSearchInput');
            if (inp) { inp.focus(); inp.select(); }
        }
    });

})();
</script>

</body>
</html>