<!-- <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %> -->

<%@ page import="com.Model.User, com.Model.Restaurant, com.Model.Dish, java.util.List"%>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Platter | Premium Food Delivery Home</title>

<!-- Google Fonts Inter -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap"
	rel="stylesheet">

<!-- FontAwesome Icons -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">

<!-- Custom CSS -->
<link rel="stylesheet" href="css/home.css?v=1.0.5">
</head>

<body>
<%
	User loggedInUser = (User) session.getAttribute("loggedInUser");
	int favCount = 0;
	int cartCount = 0;
	if (loggedInUser != null) {
		favCount = new com.DAOImpl.FavoriteDAOImpl().getFavoritesCount(loggedInUser.getUserId());
		cartCount = new com.DAOImpl.CartDAOImpl().getCartItemCount(loggedInUser.getUserId());
	}
%>

	<!-- Background Decorative Blobs -->
	<div class="blur blob-1"></div>
	<div class="blur blob-2"></div>
	<div class="blur blob-3"></div>

	<!-- PREMIUM NAVBAR -->
	<header class="navbar" id="mainNavbar">
		<div class="navbar-container">
			<!-- Brand Logo -->
			<div class="logo" onclick="window.location.reload();"
				style="cursor: pointer;">
				<span>P</span>latter
			</div>

			<!-- Navbar Search (Center) -->
			<div class="nav-search-bar">
				<i class="fa-solid fa-magnifying-glass search-icon"></i> <input
					type="text" placeholder="Search dishes, restaurants or cuisines..."
					id="navSearchInput">
				<div class="search-shortcut">⌘K</div>
			</div>

			<!-- Navbar Actions (Right) -->
			<div class="nav-actions">
				<!-- Location Display -->
				<div class="location-selector" id="locationTrigger">
					<i class="fa-solid fa-location-dot location-icon"></i>
					<div class="location-details">
						<span class="location-label">Deliver to</span> <strong
							class="location-value" id="currentLocationText">Whitefield,
							Bangalore</strong>
					</div>
					<i class="fa-solid fa-chevron-down arrow-icon"></i>

					<!-- Location Dropdown Menu -->
					<div class="location-dropdown" id="locationDropdown">
						<div class="dropdown-header">Select Address</div>
						
						<!-- Searchable Input Field -->
						<div class="location-search-box">
							<i class="fa-solid fa-magnifying-glass"></i>
							<input type="text" id="locationSearchInput" placeholder="Search delivery location..." autocomplete="off">
						</div>

						<div class="dropdown-divider"></div>
						
						<!-- List container for locations -->
						<div class="location-list" id="locationList">
							<div class="dropdown-item active" data-location="Whitefield, Bangalore">
								<i class="fa-solid fa-house"></i>
								<div class="item-text">
									<strong>Home</strong> <span>Whitefield, Bangalore</span>
								</div>
							</div>
							<div class="dropdown-item" data-location="Indiranagar, Bangalore">
								<i class="fa-solid fa-briefcase"></i>
								<div class="item-text">
									<strong>Office</strong> <span>Indiranagar, Bangalore</span>
								</div>
							</div>
						</div>
						
						<div class="dropdown-divider"></div>
						<button class="locate-me-btn" id="locateMeBtn">
							<i class="fa-solid fa-location-crosshairs"></i> Locate Me
						</button>
					</div>
				</div>

				<!-- Mobile Search Icon Button (visible only on mobile) -->
				<button class="mobile-search-btn" id="mobileSearchBtn"
					aria-label="Search">
					<i class="fa-solid fa-magnifying-glass"></i>
				</button>

				<!-- Favorites Icon Button -->
				<a href="favorites" class="nav-btn-icon" aria-label="Favorites"
					title="Favorites"> <i class="fa-regular fa-heart"></i>
					<span class="badge badge-primary fav-badge-count" <%= favCount == 0 ? "style=\"display: none;\"" : "" %>><%= favCount %></span>
				</a>

				<!-- Cart Icon Button -->
				<a href="#" class="nav-btn-icon" aria-label="Cart"
					title="Shopping Cart"> <i class="fa-solid fa-bag-shopping"></i>
					<span class="badge badge-secondary cart-badge-count" <%= cartCount == 0 ? "style=\"display: none;\"" : "" %>><%= cartCount %></span>
				</a>

				<!-- Profile Button -->
				<%
				// loggedInUser is already declared at the top of the body
				%>
				<div class="profile-container" id="profileTrigger">
					<button class="profile-avatar-btn" aria-label="User profile">
						<div class="avatar-initials"><%=loggedInUser.getName().toUpperCase().charAt(0)%></div>
					</button>
					<!-- Profile Dropdown -->
					<div class="profile-dropdown" id="profileDropdown">
						<div class="profile-dropdown-header">
							<strong><%=loggedInUser.getName()%></strong> <span><%=loggedInUser.getEmail()%></span>
						</div>
						<div class="dropdown-divider"></div>
						<a href="#" class="profile-item"><i class="fa-regular fa-user"></i>
							My Profile</a> <a href="#" class="profile-item"><i
							class="fa-solid fa-clock-rotate-left"></i> Order History</a> <a
							href="#" class="profile-item"><i class="fa-solid fa-wallet"></i>
							Platter Wallet</a> <a href="#" class="profile-item"><i
							class="fa-solid fa-gear"></i> Settings</a>
						<div class="dropdown-divider"></div>
						<a href="logout" class="profile-item logout-link"><i
							class="fa-solid fa-arrow-right-from-bracket"></i> Logout</a>
					</div>
				</div>

				<!-- Mobile Hamburger Menu Button -->
				<button class="hamburger-btn" id="hamburgerBtn"
					aria-label="Open menu">
					<i class="fa-solid fa-bars-staggered"></i>
				</button>
			</div>

			<!-- Mobile Expanding Search Bar (renders inside navbar-container) -->
			<div class="mobile-search-overlay" id="mobileSearchOverlay">
				<button class="mobile-search-close" id="mobileSearchClose"
					aria-label="Close search">
					<i class="fa-solid fa-arrow-left"></i>
				</button>
				<div class="mobile-search-input-wrap">
					<i class="fa-solid fa-magnifying-glass"></i> <input type="text"
						id="mobileSearchInput"
						placeholder="Search dishes, restaurants or cuisines..."
						autocomplete="off" autocorrect="off">
					<button class="mobile-search-clear" id="mobileSearchClear"
						aria-label="Clear search">
						<i class="fa-solid fa-xmark"></i>
					</button>
				</div>
			</div>

		</div>
	</header>

	<!-- MOBILE SIDE DRAWER MENU -->
	<div class="mobile-drawer" id="mobileDrawer">
		<div class="drawer-header">
			<div class="logo">
				<span>P</span>latter
			</div>
			<button class="close-drawer-btn" id="closeDrawerBtn"
				aria-label="Close menu">
				<i class="fa-solid fa-xmark"></i>
			</button>
		</div>
		<div class="drawer-body">
			<!-- Mobile Search -->
			<div class="drawer-search">
				<i class="fa-solid fa-magnifying-glass"></i> <input type="text"
					placeholder="Search Platter..." id="drawerSearchInput">
			</div>

			<!-- Mobile Location -->
			<div class="drawer-location" id="drawerLocationTrigger">
				<div class="loc-left">
					<i class="fa-solid fa-location-dot"></i> <span>Whitefield,
						Bangalore</span>
				</div>
				<i class="fa-solid fa-chevron-right"></i>
			</div>

			<!-- Mobile Links -->
			<nav class="drawer-nav">
				<a href="favorites" class="drawer-nav-item"><i
					class="fa-regular fa-heart"></i> Favorites
					<span class="nav-badge fav-badge-count" <%= favCount == 0 ? "style=\"display: none;\"" : "" %>><%= favCount %></span>
				</a>
				<a href="#" class="drawer-nav-item"><i
					class="fa-solid fa-bag-shopping"></i> My Cart
					<span class="nav-badge sec cart-badge-count" <%= cartCount == 0 ? "style=\"display: none;\"" : "" %>><%= cartCount %></span>
				</a> <a href="#" class="drawer-nav-item"><i
					class="fa-regular fa-user"></i> My Profile</a> <a href="#"
					class="drawer-nav-item"><i class="fa-solid fa-ticket"></i>
					Offers & Coupons</a> <a href="#" class="drawer-nav-item"><i
					class="fa-solid fa-wallet"></i> Platter Cash</a> <a href="#"
					class="drawer-nav-item"><i class="fa-solid fa-headset"></i>
					Help & Support</a>
			</nav>
		</div>
		<div class="drawer-footer">
			<button class="drawer-logout-btn" onclick="window.location.href='logout'">
				<i class="fa-solid fa-arrow-right-from-bracket"></i> Logout
			</button>
		</div>
	</div>
	<div class="drawer-overlay" id="drawerOverlay"></div>



	<!-- ==========================================
         SECTION 1: OFFERS SLIDER (PHASE 2)
         ========================================== -->
	<section class="offers-section">
		<div class="offers-slider-container">
			<div class="offers-track" id="offersTrack">

				<!-- Slide 1: 50% OFF -->
				<div class="offer-slide active" data-slide-index="0">
					<div class="offer-card-bg"
						style="background: linear-gradient(135deg, #FF9F1C, #FF4040);">
						<div class="offer-card-glow"></div>
						<div class="offer-card-content">
							<span class="offer-badge-pill"><i class="fa-solid fa-fire"></i>
								Special Welcome Offer</span>
							<h2 class="offer-title-main">50% OFF</h2>
							<p class="offer-subtitle-main">On Your First Order</p>
							<p class="offer-description-main">Dive into a premium
								culinary experience with 50% off up to ₹150. Valid on all
								premium restaurants.</p>
							<div class="offer-coupon-code">
								Use Code: <strong>PLATTER50</strong>
							</div>
							<button class="offer-action-btn">
								<span>Claim Now</span> <i class="fa-solid fa-arrow-right"></i>
							</button>
						</div>
						<div class="offer-card-graphic">
							<img src="images/hero/pizza.png"
								alt="Delicious Pizza Illustration"
								class="offer-graphic-img img-pizza">
						</div>
					</div>
				</div>

				<!-- Slide 2: Free Delivery -->
				<div class="offer-slide" data-slide-index="1">
					<div class="offer-card-bg"
						style="background: linear-gradient(135deg, #2EC4B6, #0077B6);">
						<div class="offer-card-glow"></div>
						<div class="offer-card-content">
							<span class="offer-badge-pill"><i
								class="fa-solid fa-truck-fast"></i> Daily Savings</span>
							<h2 class="offer-title-main">Free Delivery</h2>
							<p class="offer-subtitle-main">On Orders Above ₹299</p>
							<p class="offer-description-main">Forget delivery charges.
								Get your food delivered straight to your door, steaming hot,
								completely free.</p>
							<div class="offer-coupon-code">Automatically Applied at
								Checkout</div>
							<button class="offer-action-btn">
								<span>Order Now</span> <i class="fa-solid fa-arrow-right"></i>
							</button>
						</div>
						<div class="offer-card-graphic">
							<img src="images/hero/burger.png"
								alt="Gourmet Burger Illustration"
								class="offer-graphic-img img-burger">
						</div>
					</div>
				</div>

				<!-- Slide 3: BOGO Offer -->
				<div class="offer-slide" data-slide-index="2">
					<div class="offer-card-bg"
						style="background: linear-gradient(135deg, #E63946, #800f2f);">
						<div class="offer-card-glow"></div>
						<div class="offer-card-content">
							<span class="offer-badge-pill"><i class="fa-solid fa-gift"></i>
								Double Feast</span>
							<h2 class="offer-title-main">Buy 1 Get 1</h2>
							<p class="offer-subtitle-main">On Selected Restaurants</p>
							<p class="offer-description-main">Twice the flavor, half the
								cost! Treat yourself and a friend with a complimentary second
								dish.</p>
							<div class="offer-coupon-code">
								Use Code: <strong>DOUBLEFEAST</strong>
							</div>
							<button class="offer-action-btn">
								<span>Find Restaurants</span> <i class="fa-solid fa-arrow-right"></i>
							</button>
						</div>
						<div class="offer-card-graphic">
							<img src="images/hero/thali.png" alt="Indian Thali Illustration"
								class="offer-graphic-img img-thali">
						</div>
					</div>
				</div>

			</div>

			<!-- Slider Controls -->
			<button class="offer-nav-btn prev-btn" id="offerPrevBtn"
				aria-label="Previous Slide">
				<i class="fa-solid fa-chevron-left"></i>
			</button>
			<button class="offer-nav-btn next-btn" id="offerNextBtn"
				aria-label="Next Slide">
				<i class="fa-solid fa-chevron-right"></i>
			</button>

			<!-- Pagination Indicators -->
			<div class="offer-pagination-dots" id="offerPagination">
				<span class="offer-pag-dot active" data-index="0"></span> <span
					class="offer-pag-dot" data-index="1"></span> <span
					class="offer-pag-dot" data-index="2"></span>
			</div>
		</div>
	</section>

	<!-- ==========================================
         SECTION 2: FOOD CATEGORIES (PHASE 2)
         ========================================== -->
	<section class="categories-section scroll-reveal">
		<div class="categories-header">
			<div class="categories-titles">
				<h2 class="section-title-phase2">Browse By Category</h2>
				<p class="section-subtitle-phase2">Explore your favorite
					cuisines and dishes</p>
			</div>
			<div class="categories-nav-arrows">
				<button class="category-nav-arrow arrow-left-btn" id="catLeftBtn"
					aria-label="Scroll Categories Left">
					<i class="fa-solid fa-arrow-left"></i>
				</button>
				<button class="category-nav-arrow arrow-right-btn" id="catRightBtn"
					aria-label="Scroll Categories Right">
					<i class="fa-solid fa-arrow-right"></i>
				</button>
			</div>
		</div>

		<div class="categories-slider-outer">
			<!-- Fade Overlay Gradients -->
			<div class="category-fade-overlay fade-overlay-left"></div>
			<div class="category-fade-overlay fade-overlay-right"></div>

			<div class="categories-track" id="categoriesTrack">
				<!-- Pizza -->
				<div class="category-card-item" onclick="window.location.href='category?name=Pizza'">
					<div class="category-circle-wrapper">
						<img src="images/categories/pizza.png" alt="Pizza"
							class="category-circle-img">
						<div class="category-circle-glow"></div>
					</div>
					<span class="category-card-name">Pizza</span>
				</div>

				<!-- Burger -->
				<div class="category-card-item" onclick="window.location.href='category?name=Burger'">
					<div class="category-circle-wrapper">
						<img src="images/categories/burger.png" alt="Burger"
							class="category-circle-img">
						<div class="category-circle-glow"></div>
					</div>
					<span class="category-card-name">Burger</span>
				</div>

				<!-- Chinese -->
				<div class="category-card-item" onclick="window.location.href='category?name=Chinese'">
					<div class="category-circle-wrapper">
						<img src="images/categories/chinese.png" alt="Chinese"
							class="category-circle-img">
						<div class="category-circle-glow"></div>
					</div>
					<span class="category-card-name">Chinese</span>
				</div>

				<!-- Biryani -->
				<div class="category-card-item" onclick="window.location.href='category?name=Biryani'">
					<div class="category-circle-wrapper">
						<img src="images/categories/biryani.png" alt="Biryani"
							class="category-circle-img">
						<div class="category-circle-glow"></div>
					</div>
					<span class="category-card-name">Biryani</span>
				</div>

				<!-- Coffee -->
				<div class="category-card-item" onclick="window.location.href='category?name=Coffee'">
					<div class="category-circle-wrapper">
						<img src="images/categories/coffee.png" alt="Coffee"
							class="category-circle-img">
						<div class="category-circle-glow"></div>
					</div>
					<span class="category-card-name">Coffee</span>
				</div>

				<!-- Desserts -->
				<div class="category-card-item" onclick="window.location.href='category?name=Desserts'">
					<div class="category-circle-wrapper">
						<img src="images/categories/dessert.png" alt="Desserts"
							class="category-circle-img">
						<div class="category-circle-glow"></div>
					</div>
					<span class="category-card-name">Desserts</span>
				</div>

				<!-- Healthy -->
				<div class="category-card-item" onclick="window.location.href='category?name=Healthy'">
					<div class="category-circle-wrapper">
						<img src="images/categories/healthy.png" alt="Healthy"
							class="category-circle-img">
						<div class="category-circle-glow"></div>
					</div>
					<span class="category-card-name">Healthy</span>
				</div>

				<!-- Indian -->
				<div class="category-card-item" onclick="window.location.href='category?name=Indian'">
					<div class="category-circle-wrapper">
						<img src="images/categories/indian.png" alt="Indian"
							class="category-circle-img">
						<div class="category-circle-glow"></div>
					</div>
					<span class="category-card-name">Indian</span>
				</div>
			</div>
		</div>
	</section>

	<!-- ==========================================
             SECTION 3: POPULAR RESTAURANTS (PHASE 3)
             ========================================== -->
	<section class="restaurants-section scroll-reveal">
		<div class="restaurants-container">
			<div class="section-header-phase3">
				<h2 class="section-title-phase3">Popular Restaurants</h2>
				<p class="section-subtitle-phase3">Discover the highest-rated
					restaurants near you</p>
			</div>

			<div class="restaurants-grid">
				<%
				List<Restaurant> restaurantList = (List<Restaurant>) request.getAttribute("restaurantList");
				if (restaurantList != null && !restaurantList.isEmpty()) {
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

						<%
							boolean isFavRest = false;
							if (loggedInUser != null) {
								isFavRest = new com.DAOImpl.FavoriteDAOImpl().isRestaurantFavorite(loggedInUser.getUserId(), r.getRestaurantId());
							}
							String favRestClass = isFavRest ? "rest-fav-btn is-fav" : "rest-fav-btn";
							String favRestIcon = isFavRest ? "fa-solid fa-heart" : "fa-regular fa-heart";
							String favRestTitle = isFavRest ? "Remove from favourites" : "Add to favourites";
						%>
						<button class="<%= favRestClass %>" data-restaurant-id="<%= r.getRestaurantId() %>" aria-label="<%= favRestTitle %>" title="<%= favRestTitle %>">
							<i class="<%= favRestIcon %>"></i>
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

						<button class="rest-view-btn" onclick="window.location.href='menu?id=<%= r.getRestaurantId() %>'">
							<i class="fa-solid fa-utensils"></i>
							<span>View Menu</span>
						</button>

					</div>
				</div>
				<%
					}
				} else {
				%>
				<p>No restaurants available.</p>
				<%
				}
				%>
			</div>
		</div>
	</section>

	<!-- ==========================================
         SECTION 4: RECOMMENDED DISHES (PHASE 4)
         ========================================== -->
	<section class="dishes-section scroll-reveal">
		<div class="dishes-container">
			<div class="section-header-phase4">
				<h2 class="section-title-phase4">Recommended For You</h2>
				<p class="section-subtitle-phase4">Handpicked dishes based on
					what's trending and most loved by customers</p>
			</div>

			<div class="dishes-grid">
				<%
				List<Dish> recommendedDishes = (List<Dish>) request.getAttribute("recommendedDishes");
				if (recommendedDishes != null && !recommendedDishes.isEmpty()) {
					for (Dish d : recommendedDishes) {
				%>
				<div class="dish-card-item">
					<div class="dish-image-container">
						<img src="<%= d.getImagePath() %>" alt="<%= d.getName() %>"
							class="dish-cover-img"> 
						<% if (d.getTag() != null && !d.getTag().isEmpty()) { %>
							<span class="dish-badge badge-trending">
								<i class="fa-solid fa-fire"></i> <%= d.getTag() %>
							</span>
						<% } %>
						<div class="dish-indicator <%= d.isVeg() ? "veg" : "non-veg" %>" title="<%= d.isVeg() ? "Vegetarian" : "Non-Vegetarian" %>">
							<span class="dot"></span>
						</div>
						<%
							boolean isFavDish = false;
							if (loggedInUser != null) {
								isFavDish = new com.DAOImpl.FavoriteDAOImpl().isDishFavorite(loggedInUser.getUserId(), d.getDishId());
							}
							String favDishClass = isFavDish ? "dish-wishlist-btn active" : "dish-wishlist-btn";
							String favDishIcon = isFavDish ? "fa-solid fa-heart" : "fa-regular fa-heart";
							String favDishTitle = isFavDish ? "Remove from wishlist" : "Add to Wishlist";
						%>
						<button class="<%= favDishClass %>" data-dish-id="<%= d.getDishId() %>" aria-label="<%= favDishTitle %>" title="<%= favDishTitle %>">
							<i class="<%= favDishIcon %>"></i>
						</button>
					</div>
					<div class="dish-details-container">
						<div class="dish-first-row">
							<h3 class="dish-name-title"><%= d.getName() %></h3>
							<span class="dish-calories"><%= d.getCalories() %></span>
						</div>
						<p class="dish-restaurant-name"><%= d.getRestaurantName() %></p>
						<p class="dish-short-desc"><%= d.getDescription() %></p>
						<div class="dish-meta-row">
							<div class="dish-rating-badge">
								<i class="fa-solid fa-star"></i> <%= d.getRating() %>
							</div>
							<span class="dish-price-tag">₹<%= d.getPrice() %></span>
						</div>
						<div class="dish-action-row">
							<button class="quick-view-btn">Quick View</button>
							<div class="cart-action-wrapper">
								<button class="add-to-cart-btn">Add</button>
								<div class="qty-selector-wrapper">
									<button class="qty-btn qty-minus-btn"
										aria-label="Decrease quantity">
										<i class="fa-solid fa-minus"></i>
									</button>
									<span class="qty-number-display">1</span>
									<button class="qty-btn qty-plus-btn"
										aria-label="Increase quantity">
										<i class="fa-solid fa-plus"></i>
									</button>
								</div>
							</div>
						</div>
					</div>
				</div>
				<%
					}
				} else {
				%>
				<p>No recommended dishes available.</p>
				<%
				}
				%>
			</div>
		</div>
	</section>

	<!-- ==========================================
         SECTION 5: TRENDING NEAR YOU (PHASE 5)
         ========================================== -->
	<section class="trending-section scroll-reveal">
		<div class="trending-container">
			<div class="section-header-phase5">
				<div class="header-left">
					<h2 class="section-title-phase5">Trending Near You</h2>
					<p class="section-subtitle-phase5">Most ordered dishes and
						restaurants in your area right now</p>
				</div>
				<div class="header-right">
					<a href="#" class="view-all-trending-btn"> <span>View
							All Trending</span> <i class="fa-solid fa-arrow-right"></i>
					</a>
				</div>
			</div>

			<div class="trending-slider-wrapper">
				<!-- Navigation arrows -->
				<button class="trending-nav-btn prev-btn"
					aria-label="Previous slide" disabled>
					<i class="fa-solid fa-chevron-left"></i>
				</button>
				<button class="trending-nav-btn next-btn" aria-label="Next slide">
					<i class="fa-solid fa-chevron-right"></i>
				</button>

				<div class="trending-slider-track-container">
					<div class="trending-slider-track">
						<%
						List<Dish> trendingDishes = (List<Dish>) request.getAttribute("trendingDishes");
						if (trendingDishes != null && !trendingDishes.isEmpty()) {
							for (Dish d : trendingDishes) {
								String badgeClass = "badge-now";
								String iconClass = "fa-fire";
								if ("Most Loved".equalsIgnoreCase(d.getTag())) {
									badgeClass = "badge-loved";
									iconClass = "fa-heart";
								} else if ("Top Rated".equalsIgnoreCase(d.getTag())) {
									badgeClass = "badge-rated";
									iconClass = "fa-trophy";
								} else if ("Customer Favorite".equalsIgnoreCase(d.getTag())) {
									badgeClass = "badge-favorite";
									iconClass = "fa-thumbs-up";
								}
						%>
						<div class="trending-card-item">
							<div class="trending-image-container">
								<img src="<%= d.getImagePath() %>"
									alt="<%= d.getName() %>" class="trending-cover-img"> 
								<% if (d.getTag() != null && !d.getTag().isEmpty()) { %>
									<span class="trending-badge <%= badgeClass %>">
										<i class="fa-solid <%= iconClass %>"></i> <%= d.getTag() %>
									</span>
								<% } %>
							</div>
							<div class="trending-details-container">
								<div class="trending-restaurant-row">
									<span class="trending-restaurant-name"><i
										class="fa-solid fa-store"></i> <%= d.getRestaurantName() %></span> 
									<span class="trending-rating-badge">
										<i class="fa-solid fa-star"></i> <%= d.getRating() %>
									</span>
								</div>
								<h3 class="trending-dish-name"><%= d.getName() %></h3>

								<div class="trending-orders-row">
									<i class="fa-solid fa-arrow-trend-up"></i> 
									<span><%= d.getOrderCount() %></span>
								</div>

								<div class="trending-footer-row">
									<div class="trending-meta-details">
										<span><i class="fa-regular fa-clock"></i> <%= d.getDeliveryTime() %></span> 
										<span class="separator">•</span> 
										<span><i class="fa-solid fa-location-dot"></i> <%= d.getDistance() %> km</span>
									</div>
									<span class="trending-price-tag">₹<%= d.getPrice() %></span>
								</div>
							</div>
						</div>
						<%
							}
						} else {
						%>
						<p>No trending dishes available.</p>
						<%
						}
						%>
					</div>
				</div>
			</div>

			<!-- Dots Pagination Navigation -->
			<div class="trending-dots-container"></div>
		</div>
	</section>


	<!-- ==========================================
         SECTION 7: TRUST & SERVICE HIGHLIGHTS (PHASE 8)
         ========================================== -->
	<section class="highlights-section scroll-reveal">
		<div class="highlights-header">
			<h2 class="highlights-title">Why Customers Love Platter</h2>
			<p class="highlights-subtitle">Experience premium food delivery
				designed around your cravings and convenience</p>
		</div>
		<div class="highlights-grid">
			<!-- Card 1: Fast Delivery -->
			<div class="highlight-card">
				<div class="highlight-icon-wrapper">
					<i class="fa-solid fa-truck-fast"></i>
				</div>
				<h3 class="highlight-card-title">Fast Delivery</h3>
				<p class="highlight-card-desc">Fresh food delivered quickly.</p>
			</div>
			<!-- Card 2: Top Rated Restaurants -->
			<div class="highlight-card">
				<div class="highlight-icon-wrapper">
					<i class="fa-solid fa-star"></i>
				</div>
				<h3 class="highlight-card-title">Top Rated Restaurants</h3>
				<p class="highlight-card-desc">Carefully curated restaurant
					partners.</p>
			</div>
			<!-- Card 3: Secure Payments -->
			<div class="highlight-card">
				<div class="highlight-icon-wrapper">
					<i class="fa-solid fa-shield-halved"></i>
				</div>
				<h3 class="highlight-card-title">Secure Payments</h3>
				<p class="highlight-card-desc">Safe and secure checkout.</p>
			</div>
			<!-- Card 4: Exclusive Offers -->
			<div class="highlight-card">
				<div class="highlight-icon-wrapper">
					<i class="fa-solid fa-tags"></i>
				</div>
				<h3 class="highlight-card-title">Exclusive Offers</h3>
				<p class="highlight-card-desc">Special deals every day.</p>
			</div>
		</div>
	</section>


	<!-- ==========================================
         SECTION 8: PREMIUM FOOTER (PHASE 8)
         ========================================== -->
	<footer class="premium-footer scroll-reveal">
		<div class="footer-top-newsletter">
			<div class="newsletter-content">
				<div class="newsletter-text-wrapper">
					<span class="newsletter-badge"><i
						class="fa-solid fa-bell animate-swing"></i> Stay Updated</span>
					<h3 class="newsletter-heading">Get Exclusive Food Deals</h3>
					<p class="newsletter-subheading">Subscribe to our weekly
						newsletter for premium offers and handpicked culinary highlights.</p>
				</div>
				<form class="newsletter-form" id="footer-newsletter-form">
					<div class="newsletter-input-group">
						<i class="fa-regular fa-envelope input-icon"></i> <input
							type="email" class="newsletter-input" placeholder="Email Address"
							required autocomplete="off">
						<button type="submit" class="newsletter-btn">
							<span>Subscribe</span> <i class="fa-solid fa-arrow-right"></i>
						</button>
					</div>
					<div class="newsletter-status-message"></div>
				</form>
			</div>
		</div>

		<div class="footer-container">
			<!-- Brand & Socials Row -->
			<div class="footer-brand-row">
				<a href="home.html" class="footer-logo"><span>P</span>latter</a>
			</div>

			<!-- Links Grid -->
			<div class="footer-links-grid">
				<!-- Eternal Column -->
				<div class="footer-column">
					<h4 class="column-title">Eternal</h4>
					<ul class="column-links">
						<li><a href="index.html">Platter</a></li>
						<li><a href="home.html">Platter Express</a></li>
						<li><a href="#">District</a></li>
						<li><a href="#">Hyperpure</a></li>
						<li><a href="#">Feeding India</a></li>
						<li><a href="#">Investor Relations</a></li>
					</ul>
				</div>

				<!-- For Restaurants Column -->
				<div class="footer-column">
					<h4 class="column-title">For Restaurants</h4>
					<ul class="column-links">
						<li><a href="#">Partner With Us</a></li>
						<li><a href="#">Apps For You</a></li>
						<li><a href="#">Restaurant Consulting</a></li>
					</ul>
				</div>

				<!-- For Delivery Partners Column -->
				<div class="footer-column">
					<h4 class="column-title">For Delivery Partners</h4>
					<ul class="column-links">
						<li><a href="#">Partner With Us</a></li>
						<li><a href="#">Apps For You</a></li>
					</ul>
				</div>

				<!-- Learn More Column -->
				<div class="footer-column">
					<h4 class="column-title">Learn More</h4>
					<ul class="column-links">
						<li><a href="#">Privacy</a></li>
						<li><a href="#">Security</a></li>
						<li><a href="#">Terms of Service</a></li>
						<li><a href="#">Help & Support</a></li>
						<li><a href="#">Report a Fraud</a></li>
						<li><a href="#">Blog</a></li>
					</ul>
				</div>

				<!-- Social Links Column -->
				<div class="footer-column social-column">
					<h4 class="column-title">Social Links</h4>
					<div class="social-icons">
						<a href="#" aria-label="LinkedIn"><i
							class="fa-brands fa-linkedin-in"></i></a> <a href="#"
							aria-label="Instagram"><i class="fa-brands fa-instagram"></i></a>
						<a href="#" aria-label="YouTube"><i
							class="fa-brands fa-youtube"></i></a> <a href="#"
							aria-label="Facebook"><i class="fa-brands fa-facebook-f"></i></a>
						<a href="#" aria-label="Twitter"><i
							class="fa-brands fa-x-twitter"></i></a>
					</div>
					<div class="footer-store-buttons">
						<a href="#" class="footer-store-btn"> <i
							class="fa-brands fa-apple"></i>
							<div class="btn-text">
								<span class="sub">Download on the</span> <span class="main">App
									Store</span>
							</div>
						</a> <a href="#" class="footer-store-btn"> <i
							class="fa-brands fa-google-play"></i>
							<div class="btn-text">
								<span class="sub">GET IT ON</span> <span class="main">Google
									Play</span>
							</div>
						</a>
					</div>
				</div>
			</div>

			<hr class="footer-divider">

			<!-- Bottom Row -->
			<p class="footer-bottom-text">By continuing past this page, you
				agree to our Terms of Service, Cookie Policy, Privacy Policy and
				Content Policies. All trademarks are properties of their respective
				owners. 2008-2026 © Platter™ Ltd. All rights reserved.</p>
		</div>
	</footer>


	<!-- ==========================================
         SECTION 6: FLOATING CART & QUICK CHECKOUT (PHASE 6)
         ========================================== -->
	<!-- Floating Cart Card (Desktop/Tablet) -->
	<div class="floating-cart-card">
		<div class="floating-cart-header">
			<div class="floating-cart-title">
				<i class="fa-solid fa-cart-shopping"></i> <span>Cart</span>
			</div>
			<div class="floating-cart-header-actions"
				style="display: flex; align-items: center; gap: 10px;">
				<span class="floating-cart-badge">3</span>
				<button class="close-floating-cart-btn" aria-label="Close cart"
					title="Close cart">
					<i class="fa-solid fa-xmark"></i>
				</button>
			</div>
		</div>
		<div class="floating-cart-body">
			<p class="floating-cart-summary">3 Items Added</p>
			<ul class="floating-cart-items-preview">
				<li>Chicken Burger</li>
				<li>Cold Coffee</li>
				<li>Veg Biryani</li>
			</ul>
			<div class="floating-cart-subtotal-row">
				<span class="subtotal-label">Subtotal:</span> <span
					class="subtotal-val">₹637</span>
			</div>
		</div>
		<div class="floating-cart-actions">
			<button class="view-cart-btn-desktop">View Cart</button>
			<button class="checkout-btn-desktop">Checkout</button>
		</div>
	</div>

	<!-- Sticky Bottom Cart Bar (Mobile) -->
	<div class="mobile-sticky-cart-bar">
		<div class="mobile-cart-bar-left">
			<i class="fa-solid fa-cart-shopping mobile-cart-icon"></i>
			<div class="mobile-cart-text-info">
				<span class="mobile-cart-count">3 Items</span> <span
					class="mobile-cart-divider">|</span> <span
					class="mobile-cart-price">₹637</span>
			</div>
		</div>
		<button class="mobile-view-cart-btn">View Cart</button>
	</div>

	<!-- Side Checkout Drawer Overlay & Backdrop blur -->
	<div class="cart-drawer-overlay"></div>

	<!-- Side Checkout Drawer Panel Container -->
	<div class="cart-drawer-content">
		<div class="drawer-header">
			<div class="drawer-title-row">
				<i class="fa-solid fa-cart-shopping"></i>
				<h2>Your Order</h2>
			</div>
			<button class="drawer-close-btn" aria-label="Close cart drawer">
				<i class="fa-solid fa-xmark"></i>
			</button>
		</div>

		<div class="drawer-body">
			<!-- Items Container -->
			<div class="drawer-items-list-container">
				<div class="drawer-items-list">
					<!-- Loaded dynamically via JS -->
				</div>
			</div>

			<!-- Coupon application block -->
			<div class="coupon-section">
				<h3 class="section-title-drawer">Apply Coupon</h3>
				<div class="coupon-input-wrapper">
					<input type="text" id="coupon-code-input"
						placeholder="Enter coupon code" autocomplete="off">
					<button id="apply-coupon-btn">Apply</button>
				</div>
				<div class="coupon-chips-row">
					<button class="coupon-chip" data-code="PLATTER50">PLATTER50
						(50% OFF)</button>
					<button class="coupon-chip" data-code="SAVE100">SAVE100
						(₹100 Off)</button>
					<button class="coupon-chip" data-code="FREEDEL">FREEDEL
						(Free Del)</button>
				</div>
				<div class="coupon-status-message"></div>
			</div>

			<!-- Price Breakdown Summary -->
			<div class="price-summary-card">
				<h3 class="section-title-drawer">Bill Details</h3>
				<div class="summary-row">
					<span>Item Subtotal</span> <span id="summary-subtotal">₹637</span>
				</div>
				<div class="summary-row discount-row" style="display: none;">
					<span>Coupon Discount</span> <span id="summary-discount"
						class="discount-value">-₹0</span>
				</div>
				<div class="summary-row">
					<span>Delivery Partner Fee</span> <span id="summary-delivery">₹40</span>
				</div>
				<div class="summary-row savings-row">
					<span>Total Savings</span> <span id="summary-savings"
						class="accent-savings">₹0</span>
				</div>
				<hr class="summary-divider">
				<div class="summary-row total-row">
					<span>To Pay</span> <span id="summary-total">₹677</span>
				</div>
			</div>

			<!-- Empty State Container -->
			<div class="drawer-empty-state" style="display: none;">
				<div class="empty-icon-wrapper">
					<i class="fa-solid fa-basket-shopping"></i>
				</div>
				<h3>Your cart is empty</h3>
				<p>Browse delicious dishes and add them to satisfy your
					cravings.</p>
				<button class="browse-dishes-btn">Browse Delicious Dishes</button>
			</div>
		</div>

		<div class="drawer-footer">
			<button class="checkout-action-btn">Proceed to Checkout</button>
			<div class="trust-badge">
				<i class="fa-solid fa-shield-halved"></i> <span>100% Safe and
					Secure Transactions</span>
			</div>
		</div>

		<!-- Checkout success loader/confirmation overlay screen -->
		<div class="checkout-success-screen">
			<div class="success-icon-wrapper">
				<i class="fa-solid fa-circle-check animate-scale"></i>
			</div>
			<h2>Order Placed Successfully!</h2>
			<p>Your premium meal from Platter is on its way. Track your order
				status in real time.</p>
			<button class="success-close-btn">Done</button>
		</div>
	</div>



	<!-- Page JavaScript -->
	<script src="js/home.js"></script>
</body>

</html>