package com.DAOImpl;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.DAO.RestaurantDAO;
import com.Model.Restaurant;
import com.Utility.DBConnection;

public class RestaurantDAOImpl implements RestaurantDAO {

    private final Connection con;

    public RestaurantDAOImpl() {
        con = DBConnection.getConnection();
    }

    @Override
    public void addRestaurant(Restaurant r) {
        String sql = "INSERT INTO Restaurant " +
                     "(name,cuisine,imagePath,rating,deliveryTime,distance,costForOne,freeDelivery,isOpen,isTopRated,address,phone) " +
                     "VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, r.getName());
            ps.setString(2, r.getCuisine());
            ps.setString(3, r.getImagePath());
            ps.setDouble(4, r.getRating());
            ps.setString(5, r.getDeliveryTime());
            ps.setDouble(6, r.getDistance());
            ps.setInt(7, r.getCostForOne());
            ps.setBoolean(8, r.isFreeDelivery());
            ps.setBoolean(9, r.isOpen());
            ps.setBoolean(10, r.isTopRated());
            ps.setString(11, r.getAddress());
            ps.setString(12, r.getPhone());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Restaurant getRestaurant(int id) {
        String sql = "SELECT * FROM Restaurant WHERE restaurantId=?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractRestaurant(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<Restaurant> getAllRestaurants() {
        String sql = "SELECT * FROM Restaurant";
        List<Restaurant> list = new ArrayList<>();
        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(extractRestaurant(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public void updateRestaurant(Restaurant r) {
        String sql = "UPDATE Restaurant SET " +
                     "name=?,cuisine=?,imagePath=?,rating=?,deliveryTime=?,distance=?,costForOne=?,freeDelivery=?,isOpen=?,isTopRated=?,address=?,phone=? " +
                     "WHERE restaurantId=?";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, r.getName());
            ps.setString(2, r.getCuisine());
            ps.setString(3, r.getImagePath());
            ps.setDouble(4, r.getRating());
            ps.setString(5, r.getDeliveryTime());
            ps.setDouble(6, r.getDistance());
            ps.setInt(7, r.getCostForOne());
            ps.setBoolean(8, r.isFreeDelivery());
            ps.setBoolean(9, r.isOpen());
            ps.setBoolean(10, r.isTopRated());
            ps.setString(11, r.getAddress());
            ps.setString(12, r.getPhone());
            ps.setInt(13, r.getRestaurantId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteRestaurant(int id) {
        String sql = "DELETE FROM Restaurant WHERE restaurantId=?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
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
}