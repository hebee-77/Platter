package com.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.DAO.CartDAO;
import com.Model.CartItem;
import com.Utility.DBConnection;

public class CartDAOImpl implements CartDAO {

	private static final String SELECT_BY_USER =
			"SELECT cartItemId, userId, dishId, quantity FROM Platter.CartItem WHERE userId = ?";

	private static final String ADD_OR_INCREMENT =
			"INSERT INTO Platter.CartItem (userId, dishId, quantity) VALUES (?, ?, 1) " +
			"ON DUPLICATE KEY UPDATE quantity = quantity + 1";

	private static final String DECREMENT =
			"UPDATE Platter.CartItem SET quantity = quantity - 1 WHERE userId = ? AND dishId = ? AND quantity > 0";

	private static final String DELETE_IF_ZERO =
			"DELETE FROM Platter.CartItem WHERE userId = ? AND dishId = ? AND quantity <= 0";

	private static final String REMOVE_ITEM =
			"DELETE FROM Platter.CartItem WHERE userId = ? AND dishId = ?";

	private static final String COUNT_ITEMS =
			"SELECT COALESCE(SUM(quantity), 0) FROM Platter.CartItem WHERE userId = ?";

	private static final String TOTAL_PRICE =
			"SELECT COALESCE(SUM(ci.quantity * d.price), 0) " +
			"FROM Platter.CartItem ci JOIN Platter.Dish d ON ci.dishId = d.dishId " +
			"WHERE ci.userId = ?";

	@Override
	public List<CartItem> getCartItemsByUser(int userId) {
		List<CartItem> items = new ArrayList<>();
		try (Connection con = DBConnection.getConnection();
				PreparedStatement ps = con.prepareStatement(SELECT_BY_USER)) {
			ps.setInt(1, userId);
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					CartItem item = new CartItem();
					item.setCartItemId(rs.getInt("cartItemId"));
					item.setUserId(rs.getInt("userId"));
					item.setDishId(rs.getInt("dishId"));
					item.setQuantity(rs.getInt("quantity"));
					items.add(item);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return items;
	}

	@Override
	public void addOrIncrement(int userId, int dishId) {
		try (Connection con = DBConnection.getConnection();
				PreparedStatement ps = con.prepareStatement(ADD_OR_INCREMENT)) {
			ps.setInt(1, userId);
			ps.setInt(2, dishId);
			ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void decrement(int userId, int dishId) {
		try (Connection con = DBConnection.getConnection()) {
			try (PreparedStatement ps = con.prepareStatement(DECREMENT)) {
				ps.setInt(1, userId);
				ps.setInt(2, dishId);
				ps.executeUpdate();
			}
			// Remove the row if quantity has dropped to zero
			try (PreparedStatement ps = con.prepareStatement(DELETE_IF_ZERO)) {
				ps.setInt(1, userId);
				ps.setInt(2, dishId);
				ps.executeUpdate();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void removeItem(int userId, int dishId) {
		try (Connection con = DBConnection.getConnection();
				PreparedStatement ps = con.prepareStatement(REMOVE_ITEM)) {
			ps.setInt(1, userId);
			ps.setInt(2, dishId);
			ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public int getCartItemCount(int userId) {
		try (Connection con = DBConnection.getConnection();
				PreparedStatement ps = con.prepareStatement(COUNT_ITEMS)) {
			ps.setInt(1, userId);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) return rs.getInt(1);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return 0;
	}

	@Override
	public int getCartTotal(int userId) {
		try (Connection con = DBConnection.getConnection();
				PreparedStatement ps = con.prepareStatement(TOTAL_PRICE)) {
			ps.setInt(1, userId);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) return rs.getInt(1);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return 0;
	}
}
