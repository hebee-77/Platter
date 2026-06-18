package com.DAO;

import java.util.List;

import com.Model.Restaurant;

public interface RestaurantDAO {

    void addRestaurant(Restaurant restaurant);

    Restaurant getRestaurant(int restaurantId);

    List<Restaurant> getAllRestaurants();

    void updateRestaurant(Restaurant restaurant);

    void deleteRestaurant(int restaurantId);

}
