package com.DAO;

import com.Model.CartItem;
import java.util.List;

public interface CartDAO {
	List<CartItem> getCartItemsByUser(int userId);
	void addOrIncrement(int userId, int dishId);   // insert qty=1, or qty=qty+1 if exists
	void decrement(int userId, int dishId);        // qty-1, delete row if qty hits 0
	void removeItem(int userId, int dishId);
	int getCartItemCount(int userId);              // sum of all quantities for the user
	int getCartTotal(int userId);                  // sum(quantity * price) via JOIN with Dish
}
