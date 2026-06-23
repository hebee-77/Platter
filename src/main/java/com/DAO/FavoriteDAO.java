package com.DAO;

import java.util.List;
import com.Model.Dish;
import com.Model.Restaurant;

public interface FavoriteDAO {
    boolean toggleRestaurantFavorite(int userId, int restaurantId);
    boolean toggleDishFavorite(int userId, int dishId);
    boolean isRestaurantFavorite(int userId, int restaurantId);
    boolean isDishFavorite(int userId, int dishId);
    List<Restaurant> getFavoriteRestaurants(int userId);
    List<Dish> getFavoriteDishes(int userId);
    int getFavoritesCount(int userId);
    int getRestaurantIdByName(String name);
}
