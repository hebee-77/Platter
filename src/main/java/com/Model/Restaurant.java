package com.Model;

public class Restaurant {

    private int restaurantId;

    private String name;

    private String cuisine;

    private String imagePath;

    private double rating;

    private String deliveryTime;

    private double distance;

    private int costForOne;

    private boolean freeDelivery;

    private boolean open;

    private boolean topRated;

    private String address;

    private String phone;

    public Restaurant() {

    }

    public Restaurant(

            int restaurantId,

            String name,

            String cuisine,

            String imagePath,

            double rating,

            String deliveryTime,

            double distance,

            int costForOne,

            boolean freeDelivery,

            boolean open,

            boolean topRated,

            String address,

            String phone

    ) {

        this.restaurantId = restaurantId;

        this.name = name;

        this.cuisine = cuisine;

        this.imagePath = imagePath;

        this.rating = rating;

        this.deliveryTime = deliveryTime;

        this.distance = distance;

        this.costForOne = costForOne;

        this.freeDelivery = freeDelivery;

        this.open = open;

        this.topRated = topRated;

        this.address = address;

        this.phone = phone;
    }

    public int getRestaurantId() {

        return restaurantId;

    }

    public void setRestaurantId(int restaurantId) {

        this.restaurantId = restaurantId;

    }

    public String getName() {

        return name;

    }

    public void setName(String name) {

        this.name = name;

    }

    public String getCuisine() {

        return cuisine;

    }

    public void setCuisine(String cuisine) {

        this.cuisine = cuisine;

    }

    public String getImagePath() {

        return imagePath;

    }

    public void setImagePath(String imagePath) {

        this.imagePath = imagePath;

    }

    public double getRating() {

        return rating;

    }

    public void setRating(double rating) {

        this.rating = rating;

    }

    public String getDeliveryTime() {

        return deliveryTime;

    }

    public void setDeliveryTime(String deliveryTime) {

        this.deliveryTime = deliveryTime;

    }

    public double getDistance() {

        return distance;

    }

    public void setDistance(double distance) {

        this.distance = distance;

    }

    public int getCostForOne() {

        return costForOne;

    }

    public void setCostForOne(int costForOne) {

        this.costForOne = costForOne;

    }

    public boolean isFreeDelivery() {

        return freeDelivery;

    }

    public void setFreeDelivery(boolean freeDelivery) {

        this.freeDelivery = freeDelivery;

    }

    public boolean isOpen() {

        return open;

    }

    public void setOpen(boolean open) {

        this.open = open;

    }

    public boolean isTopRated() {

        return topRated;

    }

    public void setTopRated(boolean topRated) {

        this.topRated = topRated;

    }

    public String getAddress() {

        return address;

    }

    public void setAddress(String address) {

        this.address = address;

    }

    public String getPhone() {

        return phone;

    }

    public void setPhone(String phone) {

        this.phone = phone;

    }

}