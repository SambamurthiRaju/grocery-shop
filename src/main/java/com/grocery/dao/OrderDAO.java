package com.grocery.dao;

import com.grocery.model.CartItem;
import com.grocery.util.DBUtil;

import java.sql.*;
import java.util.List;

public class OrderDAO {

    public int placeOrder(int userId, List<CartItem> cartItems, double total) throws SQLException {
        String orderSql = "INSERT INTO orders (user_id, total, status) VALUES (?,?,?)";
        String itemSql = "INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?,?,?,?)";

        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);
            try {
                int orderId;
                try (PreparedStatement ps = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setInt(1, userId);
                    ps.setDouble(2, total);
                    ps.setString(3, "PLACED");
                    ps.executeUpdate();
                    ResultSet rs = ps.getGeneratedKeys();
                    rs.next();
                    orderId = rs.getInt(1);
                }

                try (PreparedStatement ps = conn.prepareStatement(itemSql)) {
                    for (CartItem item : cartItems) {
                        ps.setInt(1, orderId);
                        ps.setInt(2, item.getProduct().getId());
                        ps.setInt(3, item.getQuantity());
                        ps.setDouble(4, item.getProduct().getPrice());
                        ps.addBatch();
                    }
                    ps.executeBatch();
                }

                conn.commit();
                return orderId;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        }
    }
}
