<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.Model.User, com.Model.Restaurant, com.Model.Dish, java.util.List, com.DAOImpl.FavoriteDAOImpl, com.DAOImpl.CartDAOImpl" %>
<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    if (loggedInUser == null) {
        response.sendRedirect("index.jsp?showLogin=true&redirectTo=favorites");
        return;
    }
    
    List<Restaurant> favoriteRestaurants = (List<Restaurant>) request.getAttribute("favoriteRestaurants");
    List<Dish> favoriteDishes = (List<Dish>) request.getAttribute("favoriteDishes");
    
    int favCount = 0;
    int cartCount = 0;
    FavoriteDAOImpl favoriteDAO = new FavoriteDAOImpl();
    CartDAOImpl cartDAO = new CartDAOImpl();
    if (loggedInUser != null) {
        favCount = favoriteDAO.getFavoritesCount(loggedInUser.getUserId());
        cartCount = cartDAO.getCartItemCount(loggedInUser.getUserId());
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Platter | My Favorites</title>
    <meta name="description" content="Manage and view all your favorite restaurants and dishes on Platter.">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
    <link rel="stylesheet" href="css/home.css?v=1.0.5">
    
    <style>
        /* Favorites page custom styles */
        .favorites-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 120px 20px 60px 20px;
            min-height: calc(100vh - 200px);
        }
        .favorites-header {
            margin-bottom: 40px;
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
        }
        .favorites-title {
            font-size: 2.8rem;
            font-weight: 800;
            background: linear-gradient(135deg, #FFF 0%, #A5B4FC 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 12px;
        }
        .favorites-subtitle {
            color: #94A3B8;
            font-size: 1.1rem;
        }
        .favorites-tabs {
            display: flex;
            justify-content: center;
            align-items: center;
            background: rgba(255, 255, 255, 0.02);
            border: 1px solid rgba(255, 255, 255, 0.06);
            padding: 6px;
            border-radius: 40px;
            backdrop-filter: blur(10px);
            margin: 0 auto 40px auto;
            max-width: fit-content;
            box-shadow: inset 0 1px 1px rgba(255, 255, 255, 0.05);
        }
        .tab-btn {
            background: transparent;
            border: 1px solid transparent;
            padding: 10px 24px;
            border-radius: 35px;
            color: #94A3B8;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 0.95rem;
        }
        .tab-btn i {
            font-size: 0.9rem;
            color: #64748B;
            transition: color 0.3s ease;
        }
        .tab-btn:hover {
            color: #FFF;
        }
        .tab-btn:hover i {
            color: #EF4444;
        }
        .tab-btn.active {
            background: rgba(255, 255, 255, 0.07);
            border: 1px solid rgba(255, 255, 255, 0.08);
            color: #FFF;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2), inset 0 1px 0 rgba(255, 255, 255, 0.05);
        }
        .tab-btn.active i {
            color: #EF4444;
        }
        .tab-btn.active::after {
            display: none !important;
            content: none !important;
        }
        .fav-section {
            display: none;
        }
        .fav-section.active {
            display: block;
        }
        /* Empty state */
        .fav-empty-state {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 80px 20px;
            text-align: center;
            background: rgba(255, 255, 255, 0.02);
            border: 1px dashed rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            backdrop-filter: blur(10px);
        }
        .fav-empty-icon {
            font-size: 4.5rem;
            color: #EF4444;
            margin-bottom: 24px;
            animation: heartBeat 2s infinite;
        }
        .fav-empty-state h3 {
            font-size: 1.6rem;
            font-weight: 700;
            color: #FFF;
            margin-bottom: 12px;
        }
        .fav-empty-state p {
            color: #64748B;
            max-width: 420px;
            margin-bottom: 30px;
            font-size: 1rem;
            line-height: 1.5;
        }
        .fav-empty-btn {
            background: linear-gradient(135deg, #EF4444 0%, #D97706 100%);
            color: #FFF;
            padding: 14px 36px;
            border-radius: 30px;
            font-weight: 600;
            text-decoration: none;
            box-shadow: 0 4px 15px rgba(239, 68, 68, 0.3);
            transition: all 0.3s ease;
        }
        .fav-empty-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(239, 68, 68, 0.4);
        }
        @keyframes heartBeat {
            0% { transform: scale(1); }
            14% { transform: scale(1.1); }
            28% { transform: scale(1); }
            42% { transform: scale(1.1); }
            70% { transform: scale(1); }
        }
    </style>
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

                <a href="favorites" class="nav-btn-icon active" aria-label="Favorites" title="Favorites">
                    <i class="fa-solid fa-heart" style="color: #EF4444;"></i>
                    <span class="badge badge-primary fav-badge-count" <%= favCount == 0 ? "style=\"display: none;\"" : "" %>><%= favCount %></span>
                </a>

                <a href="cart.jsp" class="nav-btn-icon" aria-label="Cart" title="Cart">
                    <i class="fa-solid fa-bag-shopping"></i>
                    <span class="badge badge-secondary cart-badge-count" <%= cartCount == 0 ? "style=\"display: none;\"" : "" %>><%= cartCount %></span>
                </a>

                <div class="profile-container" id="profileTrigger">
                    <button class="profile-avatar-btn" aria-label="User profile">
                        <div class="avatar-initials"><%=loggedInUser.getName().toUpperCase().charAt(0)%></div>
                    </button>
                    <div class="profile-dropdown" id="profileDropdown">
                        <div class="profile-dropdown-header">
                            <strong><%=loggedInUser.getName()%></strong> <span><%=loggedInUser.getEmail()%></span>
                        </div>
                        <div class="dropdown-divider"></div>
                        <a href="#" class="profile-item"><i class="fa-regular fa-user"></i> My Profile</a>
                        <a href="#" class="profile-item"><i class="fa-solid fa-clock-rotate-left"></i> Order History</a>
                        <a href="#" class="profile-item"><i class="fa-solid fa-wallet"></i> Platter Wallet</a>
                        <a href="#" class="profile-item"><i class="fa-solid fa-gear"></i> Settings</a>
                        <div class="dropdown-divider"></div>
                        <a href="logout" class="profile-item logout-link"><i class="fa-solid fa-arrow-right-from-bracket"></i> Logout</a>
                    </div>
                </div>

                <button class="hamburger-btn" id="hamburgerBtn" aria-label="Open menu">
                    <i class="fa-solid fa-bars-staggered"></i>
                </button>
            </div>
        </div>
    </header>

    <!-- MOBILE SIDE DRAWER MENU -->
    <div class="mobile-drawer" id="mobileDrawer">
        <div class="drawer-header">
            <div class="logo">
                <span>P</span>latter
            </div>
            <button class="close-drawer-btn" id="closeDrawerBtn" aria-label="Close menu">
                <i class="fa-solid fa-xmark"></i>
            </button>
        </div>
        <div class="drawer-body">
            <div class="drawer-search">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input type="text" placeholder="Search Platter..." id="drawerSearchInput">
            </div>

            <div class="drawer-location" id="drawerLocationTrigger">
                <div class="loc-left">
                    <i class="fa-solid fa-location-dot"></i>
                    <span>Whitefield, Bangalore</span>
                </div>
                <i class="fa-solid fa-chevron-right"></i>
            </div>

            <nav class="drawer-nav">
                <a href="favorites" class="drawer-nav-item active">
                    <i class="fa-solid fa-heart" style="color:#EF4444;"></i> Favorites
                    <span class="nav-badge fav-badge-count" <%= favCount == 0 ? "style=\"display: none;\"" : "" %>><%= favCount %></span>
                </a>
                <a href="cart.jsp" class="drawer-nav-item">
                    <i class="fa-solid fa-bag-shopping"></i> My Cart
                    <span class="nav-badge sec cart-badge-count" <%= cartCount == 0 ? "style=\"display: none;\"" : "" %>><%= cartCount %></span>
                </a>
                <a href="#" class="drawer-nav-item"><i class="fa-regular fa-user"></i> My Profile</a>
                <a href="#" class="drawer-nav-item"><i class="fa-solid fa-ticket"></i> Offers & Coupons</a>
                <a href="#" class="drawer-nav-item"><i class="fa-solid fa-wallet"></i> Platter Cash</a>
                <a href="#" class="drawer-nav-item"><i class="fa-solid fa-headset"></i> Help & Support</a>
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
         MAIN CONTENT
         ========================================================= -->
    <main class="favorites-container">
        <div class="favorites-header">
            <h1 class="favorites-title">Your Favorites</h1>
            <p class="favorites-subtitle">All your loved restaurants and dishes in one place</p>
        </div>

        <div class="favorites-tabs">
            <button class="tab-btn active" data-tab="restaurants" onclick="switchTab('restaurants')">
                <i class="fa-solid fa-store"></i> Restaurants (<%= favoriteRestaurants != null ? favoriteRestaurants.size() : 0 %>)
            </button>
            <button class="tab-btn" data-tab="dishes" onclick="switchTab('dishes')">
                <i class="fa-solid fa-bowl-food"></i> Dishes (<%= favoriteDishes != null ? favoriteDishes.size() : 0 %>)
            </button>
        </div>

        <div class="favorites-content">
            <!-- Section: Favorite Restaurants -->
            <div id="restaurants" class="fav-section active">
                <% if (favoriteRestaurants == null || favoriteRestaurants.isEmpty()) { %>
                    <div class="fav-empty-state">
                        <div class="fav-empty-icon"><i class="fa-regular fa-heart"></i></div>
                        <h3>No Favorite Restaurants Yet</h3>
                        <p>Explore top-rated restaurants and click the heart icon to save them here!</p>
                        <a href="home" class="fav-empty-btn">Explore Restaurants</a>
                    </div>
                <% } else { %>
                    <div class="restaurants-page-grid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 30px;">
                        <% 
                        int cardDelay = 0;
                        for (Restaurant r : favoriteRestaurants) { 
                            cardDelay += 60;
                            String openStatusClass = r.isOpen() ? "status-open" : "status-closed";
                            String openStatusText  = r.isOpen() ? "Open Now"    : "Closed";
                        %>
                            <div class="rest-card" style="animation-delay: <%= cardDelay %>ms; position: relative;">
                                <div class="rest-image-wrap">
                                    <img src="<%= r.getImagePath() %>" alt="<%= r.getName() %>" class="rest-img" onclick="window.location.href='menu?id=<%= r.getRestaurantId() %>'" style="cursor:pointer; width: 100%; height: 200px; object-fit: cover;">
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
                                    <button class="rest-fav-btn is-fav" data-restaurant-id="<%= r.getRestaurantId() %>" aria-label="Remove from favourites" title="Remove from favourites">
                                        <i class="fa-solid fa-heart" style="color: #EF4444;"></i>
                                    </button>
                                </div>
                                <div class="rest-card-body" onclick="window.location.href='menu?id=<%= r.getRestaurantId() %>'" style="cursor:pointer;">
                                    <div class="rest-card-row1">
                                        <h3 class="rest-card-name"><%= r.getName() %></h3>
                                        <div class="rest-rating-chip">
                                            <i class="fa-solid fa-star"></i>
                                            <span><%= r.getRating() %></span>
                                        </div>
                                    </div>
                                    <p class="rest-cuisine"><%= r.getCuisine() %></p>
                                    <div class="premium-divider" style="margin: 12px 0;"></div>
                                    <div class="rest-card-row3">
                                        <span class="rest-delivery-time"><i class="fa-regular fa-clock"></i> <%= r.getDeliveryTime() %></span>
                                        <span class="rest-cost"><i class="fa-solid fa-indian-rupee-sign"></i><%= r.getCostForOne() %> for one</span>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } %>
            </div>

            <!-- Section: Favorite Dishes -->
            <div id="dishes" class="fav-section">
                <% if (favoriteDishes == null || favoriteDishes.isEmpty()) { %>
                    <div class="fav-empty-state">
                        <div class="fav-empty-icon"><i class="fa-regular fa-heart"></i></div>
                        <h3>No Favorite Dishes Yet</h3>
                        <p>Browse restaurant menus and wishlist dishes to see them here!</p>
                        <a href="home" class="fav-empty-btn">Browse Menus</a>
                    </div>
                <% } else { %>
                    <div class="restaurants-page-grid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 30px;">
                        <% 
                        int cardDelay = 0;
                        for (Dish d : favoriteDishes) { 
                            cardDelay += 60;
                            int restId = favoriteDAO.getRestaurantIdByName(d.getRestaurantName());
                        %>
                            <div class="rest-card" style="animation-delay: <%= cardDelay %>ms; position: relative;">
                                <div class="rest-image-wrap">
                                    <img src="<%= d.getImagePath() %>" alt="<%= d.getName() %>" class="rest-img" onclick="window.location.href='menu?id=<%= restId %>'" style="cursor:pointer; width: 100%; height: 200px; object-fit: cover;">
                                    <span class="rest-badge-top" style="background: <%= d.isVeg() ? "#10B981" : "#EF4444" %>;">
                                        <i class="fa-solid fa-circle" style="font-size: 8px;"></i> <%= d.isVeg() ? "Veg" : "Non-Veg" %>
                                    </span>
                                    <button class="dish-wishlist-btn active" data-dish-id="<%= d.getDishId() %>" aria-label="Remove from wishlist" title="Remove from wishlist">
                                        <i class="fa-solid fa-heart" style="color: #EF4444;"></i>
                                    </button>
                                </div>
                                <div class="rest-card-body" onclick="window.location.href='menu?id=<%= restId %>'" style="cursor:pointer;">
                                    <div class="rest-card-row1">
                                        <h3 class="rest-card-name"><%= d.getName() %></h3>
                                        <div class="rest-rating-chip" style="background: rgba(245, 158, 11, 0.1); color: #F59E0B;">
                                            <i class="fa-solid fa-star"></i>
                                            <span><%= d.getRating() %></span>
                                        </div>
                                    </div>
                                    <p class="rest-cuisine" style="font-size: 0.85rem; color: #10B981; font-weight: 600;"><i class="fa-solid fa-store"></i> <%= d.getRestaurantName() %></p>
                                    <p class="rest-cuisine" style="font-size: 0.85rem; margin-top: 5px; height: 36px; overflow: hidden; text-overflow: ellipsis; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical;"><%= d.getDescription() != null ? d.getDescription() : "" %></p>
                                    <div class="premium-divider" style="margin: 12px 0;"></div>
                                    <div class="rest-card-row3" style="display: flex; justify-content: space-between; align-items: center;">
                                        <span class="rest-cost" style="font-size: 1.2rem; font-weight: 700; color: #FFF;">₹<%= d.getPrice() %></span>
                                        <span class="rest-delivery-time" style="background: rgba(59, 130, 246, 0.1); color: #3B82F6; padding: 4px 10px; border-radius: 12px; font-size: 0.8rem; font-weight: 600;">View Menu</span>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } %>
            </div>
        </div>
    </main>

    <!-- =========================================================
         SCRIPTS
         ========================================================= -->
    <script>
        // Tab switching
        function switchTab(tabId) {
            document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
            document.querySelectorAll('.fav-section').forEach(sec => sec.classList.remove('active'));
            
            const activeBtn = document.querySelector(`[data-tab="${tabId}"]`);
            if (activeBtn) activeBtn.classList.add('active');
            
            const activeSec = document.getElementById(tabId);
            if (activeSec) activeSec.classList.add('active');
        }

        // Profile dropdown toggle
        const profileTrigger = document.getElementById('profileTrigger');
        const profileDropdown = document.getElementById('profileDropdown');
        if (profileTrigger && profileDropdown) {
            profileTrigger.addEventListener('click', function(e) {
                e.stopPropagation();
                profileDropdown.classList.toggle('active');
            });
            document.addEventListener('click', function() {
                profileDropdown.classList.remove('active');
            });
        }

        // Mobile drawer toggle
        const hamburgerBtn = document.getElementById('hamburgerBtn');
        const mobileDrawer = document.getElementById('mobileDrawer');
        const drawerOverlay = document.getElementById('drawerOverlay');
        const closeDrawerBtn = document.getElementById('closeDrawerBtn');

        if (hamburgerBtn && mobileDrawer && drawerOverlay) {
            hamburgerBtn.addEventListener('click', function() {
                mobileDrawer.classList.add('active');
                drawerOverlay.classList.add('active');
            });
            
            const closeMenu = function() {
                mobileDrawer.classList.remove('active');
                drawerOverlay.classList.remove('active');
            };
            
            if (closeDrawerBtn) closeDrawerBtn.addEventListener('click', closeMenu);
            drawerOverlay.addEventListener('click', closeMenu);
        }

        // Favorites AJAX toggle with animation
        async function toggleFavorite(type, id, btnElement) {
            try {
                const res = await fetch('favorites', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: 'type=' + type + '&id=' + id
                });
                if (res.ok) {
                    const data = await res.json();
                    if (data.status === 'success') {
                        // Update badges
                        document.querySelectorAll('.fav-badge-count').forEach(badge => {
                            badge.textContent = data.favoriteCount;
                            if (data.favoriteCount > 0) {
                                badge.style.display = '';
                            } else {
                                badge.style.display = 'none';
                            }
                        });
                        
                        // Animate and remove card
                        const card = btnElement.closest('.rest-card');
                        if (card) {
                            card.style.transition = 'all 0.5s ease';
                            card.style.transform = 'scale(0.8)';
                            card.style.opacity = '0';
                            setTimeout(() => {
                                card.remove();
                                // If section is now empty, reload page to show empty state
                                const section = btnElement.closest('.fav-section');
                                if (section && section.querySelectorAll('.rest-card').length === 0) {
                                    window.location.reload();
                                }
                            }, 500);
                        }
                    }
                }
            } catch (err) {
                console.error('Error toggling favorite:', err);
            }
        }

        document.querySelectorAll('.rest-fav-btn').forEach(btn => {
            btn.addEventListener('click', function(e) {
                e.stopPropagation();
                const restId = btn.getAttribute('data-restaurant-id');
                toggleFavorite('restaurant', restId, btn);
            });
        });

        document.querySelectorAll('.dish-wishlist-btn').forEach(btn => {
            btn.addEventListener('click', function(e) {
                e.stopPropagation();
                const dishId = btn.getAttribute('data-dish-id');
                toggleFavorite('dish', dishId, btn);
            });
        });
    </script>
</body>
</html>
