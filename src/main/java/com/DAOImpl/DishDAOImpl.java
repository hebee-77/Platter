package com.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.DAO.DishDAO;
import com.Model.Dish;
import com.Utility.DBConnection;

public class DishDAOImpl implements DishDAO {

	private static final String SELECT_BY_SECTION_QUERY =
			"SELECT dishId, name, restaurantName, price, rating, imagePath, description, calories, isVeg, orderCount, deliveryTime, distance, tag, section FROM Platter.Dish WHERE section = ?";

	@Override
	public List<Dish> getDishesBySection(String section) {
		List<Dish> dishes = new ArrayList<>();

		try (Connection con = DBConnection.getConnection();
				PreparedStatement ps = con.prepareStatement(SELECT_BY_SECTION_QUERY)) {

			ps.setString(1, section);

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					Dish d = new Dish();
					d.setDishId(rs.getInt("dishId"));
					d.setName(rs.getString("name"));
					d.setRestaurantName(rs.getString("restaurantName"));
					d.setPrice(rs.getInt("price"));
					d.setRating(rs.getDouble("rating"));
					d.setImagePath(rs.getString("imagePath"));
					d.setDescription(rs.getString("description"));
					d.setCalories(rs.getString("calories"));
					d.setVeg(rs.getBoolean("isVeg"));
					d.setOrderCount(rs.getString("orderCount"));
					d.setDeliveryTime(rs.getString("deliveryTime"));
					
					double dist = rs.getDouble("distance");
					if (rs.wasNull()) {
						d.setDistance(null);
					} else {
						d.setDistance(dist);
					}
					
					d.setTag(rs.getString("tag"));
					d.setSection(rs.getString("section"));

					dishes.add(d);
				}
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return dishes;
	}
}
