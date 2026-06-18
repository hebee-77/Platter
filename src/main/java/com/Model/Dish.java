package com.Model;

public class Dish {
	private int dishId;
	private String name;
	private String restaurantName;
	private int price;
	private double rating;
	private String imagePath;
	private String description;
	private String calories;
	private boolean isVeg;
	private String orderCount;
	private String deliveryTime;
	private Double distance;
	private String tag;
	private String section;

	public Dish() {}

	public Dish(int dishId, String name, String restaurantName, int price, double rating, String imagePath,
			String description, String calories, boolean isVeg, String orderCount, String deliveryTime,
			Double distance, String tag, String section) {
		this.dishId = dishId;
		this.name = name;
		this.restaurantName = restaurantName;
		this.price = price;
		this.rating = rating;
		this.imagePath = imagePath;
		this.description = description;
		this.calories = calories;
		this.isVeg = isVeg;
		this.orderCount = orderCount;
		this.deliveryTime = deliveryTime;
		this.distance = distance;
		this.tag = tag;
		this.section = section;
	}

	public int getDishId() {
		return dishId;
	}

	public void setDishId(int dishId) {
		this.dishId = dishId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getRestaurantName() {
		return restaurantName;
	}

	public void setRestaurantName(String restaurantName) {
		this.restaurantName = restaurantName;
	}

	public int getPrice() {
		return price;
	}

	public void setPrice(int price) {
		this.price = price;
	}

	public double getRating() {
		return rating;
	}

	public void setRating(double rating) {
		this.rating = rating;
	}

	public String getImagePath() {
		return imagePath;
	}

	public void setImagePath(String imagePath) {
		this.imagePath = imagePath;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getCalories() {
		return calories;
	}

	public void setCalories(String calories) {
		this.calories = calories;
	}

	public boolean isVeg() {
		return isVeg;
	}

	public void setVeg(boolean isVeg) {
		this.isVeg = isVeg;
	}

	public String getOrderCount() {
		return orderCount;
	}

	public void setOrderCount(String orderCount) {
		this.orderCount = orderCount;
	}

	public String getDeliveryTime() {
		return deliveryTime;
	}

	public void setDeliveryTime(String deliveryTime) {
		this.deliveryTime = deliveryTime;
	}

	public Double getDistance() {
		return distance;
	}

	public void setDistance(Double distance) {
		this.distance = distance;
	}

	public String getTag() {
		return tag;
	}

	public void setTag(String tag) {
		this.tag = tag;
	}

	public String getSection() {
		return section;
	}

	public void setSection(String section) {
		this.section = section;
	}
}
