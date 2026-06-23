package com.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.DAO.FavoriteDAO;
import com.Model.Dish;
import com.Model.Restaurant;
import com.Utility.DBConnection;

public class FavoriteDAOImpl implements FavoriteDAO {

    @Override
    public boolean toggleRestaurantFavorite(int userId, int restaurantId) {
        boolean isFav = isRestaurantFavorite(userId, restaurantId);
        if (isFav) {
            String sql = "DELETE FROM Platter.Favorites WHERE userId = ? AND restaurantId = ?";
            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.setInt(2, restaurantId);
                ps.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            return false;
        } else {
            String sql = "INSERT INTO Platter.Favorites (userId, restaurantId) VALUES (?, ?)";
            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.setInt(2, restaurantId);
                ps.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            return true;
        }
    }

    @Override
    public boolean toggleDishFavorite(int userId, int dishId) {
        boolean isFav = isDishFavorite(userId, dishId);
        if (isFav) {
            String sql = "DELETE FROM Platter.Favorites WHERE userId = ? AND dishId = ?";
            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.setInt(2, dishId);
                ps.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            return false;
        } else {
            String sql = "INSERT INTO Platter.Favorites (userId, dishId) VALUES (?, ?)";
            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.setInt(2, dishId);
                ps.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            return true;
        }
    }

    @Override
    public boolean isRestaurantFavorite(int userId, int restaurantId) {
        String sql = "SELECT favoriteId FROM Platter.Favorites WHERE userId = ? AND restaurantId = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, restaurantId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean isDishFavorite(int userId, int dishId) {
        String sql = "SELECT favoriteId FROM Platter.Favorites WHERE userId = ? AND dishId = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, dishId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public List<Restaurant> getFavoriteRestaurants(int userId) {
        String sql = "SELECT r.* FROM Platter.Restaurant r " +
                     "JOIN Platter.Favorites f ON r.restaurantId = f.restaurantId " +
                     "WHERE f.userId = ?";
        List<Restaurant> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractRestaurant(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Dish> getFavoriteDishes(int userId) {
        String sql = "SELECT d.* FROM Platter.Dish d " +
                     "JOIN Platter.Favorites f ON d.dishId = f.dishId " +
                     "WHERE f.userId = ?";
        List<Dish> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public int getFavoritesCount(int userId) {
        String sql = "SELECT COUNT(*) FROM Platter.Favorites WHERE userId = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int getRestaurantIdByName(String name) {
        String sql = "SELECT restaurantId FROM Platter.Restaurant WHERE name = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, name);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("restaurantId");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    private Restaurant extractRestaurant(ResultSet rs) throws SQLException {
        return new Restaurant(
                rs.getInt("restaurantId"),
                rs.getString("name"),
                rs.getString("cuisine"),
                rs.getString("imagePath"),
                rs.getDouble("rating"),
                rs.getString("deliveryTime"),
                rs.getDouble("distance"),
                rs.getInt("costForOne"),
                rs.getBoolean("freeDelivery"),
                rs.getBoolean("isOpen"),
                rs.getBoolean("isTopRated"),
                rs.getString("address"),
                rs.getString("phone")
        );
    }

    private Dish mapRow(ResultSet rs) throws SQLException {
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
        d.setDistance(rs.getDouble("distance"));
        d.setTag(rs.getString("tag"));
        d.setSection(rs.getString("section"));
        return d;
    }
}
