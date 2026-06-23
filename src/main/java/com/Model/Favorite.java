package com.Model;

public class Favorite {
    private int favoriteId;
    private int userId;
    private Integer dishId; // can be null
    private Integer restaurantId; // can be null

    public Favorite() {
        super();
    }

    public Favorite(int userId, Integer dishId, Integer restaurantId) {
        super();
        this.userId = userId;
        this.dishId = dishId;
        this.restaurantId = restaurantId;
    }

    public Favorite(int favoriteId, int userId, Integer dishId, Integer restaurantId) {
        super();
        this.favoriteId = favoriteId;
        this.userId = userId;
        this.dishId = dishId;
        this.restaurantId = restaurantId;
    }

    public int getFavoriteId() {
        return favoriteId;
    }

    public void setFavoriteId(int favoriteId) {
        this.favoriteId = favoriteId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Integer getDishId() {
        return dishId;
    }

    public void setDishId(Integer dishId) {
        this.dishId = dishId;
    }

    public Integer getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(Integer restaurantId) {
        this.restaurantId = restaurantId;
    }
}
