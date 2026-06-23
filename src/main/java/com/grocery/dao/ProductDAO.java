package com.grocery.dao;

import com.grocery.model.Product;
import com.grocery.util.DBUtil;

import java.sql.*;
import java.util.*;

public class ProductDAO {

    public List<Product> getAllProducts() throws SQLException {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products ORDER BY category, name";
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) list.add(mapProduct(rs));
        }
        return list;
    }

    public List<Product> getProductsByCategory(String category) throws SQLException {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE category = ? ORDER BY name";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, category);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapProduct(rs));
        }
        return list;
    }

    public List<String> getCategories() throws SQLException {
        List<String> cats = new ArrayList<>();
        String sql = "SELECT DISTINCT category FROM products ORDER BY category";
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) cats.add(rs.getString("category"));
        }
        return cats;
    }

    public Product getProductById(int id) throws SQLException {
        String sql = "SELECT * FROM products WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapProduct(rs);
        }
        return null;
    }

    public List<Product> searchProducts(String query) throws SQLException {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE LOWER(name) LIKE ? OR LOWER(category) LIKE ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String q = "%" + query.toLowerCase() + "%";
            ps.setString(1, q);
            ps.setString(2, q);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapProduct(rs));
        }
        return list;
    }

    private Product mapProduct(ResultSet rs) throws SQLException {
        return new Product(
                rs.getInt("id"),
                rs.getString("name"),
                rs.getString("category"),
                rs.getDouble("price"),
                rs.getInt("stock"),
                rs.getString("image_url"),
                rs.getString("description"),
                rs.getString("unit")
        );
    }
}
