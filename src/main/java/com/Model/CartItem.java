package com.Model;

public class CartItem {
	private int cartItemId;
	private int userId;
	private int dishId;
	private int quantity;

	private Dish dish;

	public CartItem() {}

	public CartItem(int cartItemId, int userId, int dishId, int quantity) {
		this.cartItemId = cartItemId;
		this.userId     = userId;
		this.dishId     = dishId;
		this.quantity   = quantity;
	}

	public CartItem(int cartItemId, int userId, int dishId, int quantity, Dish dish) {
		this.cartItemId = cartItemId;
		this.userId     = userId;
		this.dishId     = dishId;
		this.quantity   = quantity;
		this.dish       = dish;
	}

	public int getCartItemId() {
		return cartItemId;
	}

	public void setCartItemId(int cartItemId) {
		this.cartItemId = cartItemId;
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public int getDishId() {
		return dishId;
	}

	public void setDishId(int dishId) {
		this.dishId = dishId;
	}

	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

	public Dish getDish() {
		return dish;
	}

	public void setDish(Dish dish) {
		this.dish = dish;
	}
}

