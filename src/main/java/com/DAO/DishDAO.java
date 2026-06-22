package com.DAO;

import java.util.List;
import com.Model.Dish;

public interface DishDAO {
	List<Dish> getDishesBySection(String section);
	List<Dish> getDishesByRestaurantName(String restaurantName);
}
