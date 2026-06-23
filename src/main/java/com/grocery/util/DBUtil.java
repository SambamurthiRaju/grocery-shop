package com.grocery.util;

import java.sql.*;

public class DBUtil {
    private static final String DB_URL = "jdbc:h2:mem:grocerydb;DB_CLOSE_DELAY=-1;DB_CLOSE_ON_EXIT=FALSE";
    private static final String DB_USER = "sa";
    private static final String DB_PASS = "";
    private static boolean initialized = false;

    static {
        try {
            Class.forName("org.h2.Driver");
            initializeDatabase();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
    }

    private static void initializeDatabase() throws SQLException {
        try (Connection conn = getConnection(); Statement stmt = conn.createStatement()) {

            // Create Users table
            stmt.execute("""
                CREATE TABLE IF NOT EXISTS users (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    username VARCHAR(50) UNIQUE NOT NULL,
                    email VARCHAR(100) UNIQUE NOT NULL,
                    password VARCHAR(255) NOT NULL,
                    full_name VARCHAR(100) NOT NULL,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                )
            """);

            // Create Products table
            stmt.execute("""
                CREATE TABLE IF NOT EXISTS products (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    name VARCHAR(100) NOT NULL,
                    category VARCHAR(50) NOT NULL,
                    price DECIMAL(10,2) NOT NULL,
                    stock INT DEFAULT 100,
                    image_url VARCHAR(500),
                    description VARCHAR(255),
                    unit VARCHAR(20) DEFAULT 'each'
                )
            """);

            // Create Orders table
            stmt.execute("""
                CREATE TABLE IF NOT EXISTS orders (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    user_id INT NOT NULL,
                    total DECIMAL(10,2) NOT NULL,
                    status VARCHAR(20) DEFAULT 'PLACED',
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    FOREIGN KEY (user_id) REFERENCES users(id)
                )
            """);

            // Create Order Items table
            stmt.execute("""
                CREATE TABLE IF NOT EXISTS order_items (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    order_id INT NOT NULL,
                    product_id INT NOT NULL,
                    quantity INT NOT NULL,
                    price DECIMAL(10,2) NOT NULL,
                    FOREIGN KEY (order_id) REFERENCES orders(id),
                    FOREIGN KEY (product_id) REFERENCES products(id)
                )
            """);

            // Seed a demo user (password: demo123)
            ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM users");
            rs.next();
            if (rs.getInt(1) == 0) {
                String hashedPwd = org.mindrot.jbcrypt.BCrypt.hashpw("demo123", org.mindrot.jbcrypt.BCrypt.gensalt());
                stmt.execute("INSERT INTO users (username, email, password, full_name) VALUES " +
                        "('demo', 'demo@grocery.com', '" + hashedPwd + "', 'Demo User')");
            }

            // Seed grocery products using Unsplash open-source food images
            rs = stmt.executeQuery("SELECT COUNT(*) FROM products");
            rs.next();
            if (rs.getInt(1) == 0) {
                seedProducts(conn);
            }
        }
    }

    private static void seedProducts(Connection conn) throws SQLException {
        String sql = "INSERT INTO products (name, category, price, stock, image_url, description, unit) VALUES (?,?,?,?,?,?,?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            Object[][] products = {
                    // Fruits
                    {"Apple", "Fruits", 1.99, 150, "https://images.unsplash.com/photo-1567306226416-28f0efdc88ce?w=400", "Fresh red apples", "per lb"},
                    {"Banana", "Fruits", 0.79, 200, "https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=400", "Ripe yellow bananas", "bunch"},
                    {"Orange", "Fruits", 2.49, 120, "https://images.unsplash.com/photo-1547514701-42782101795e?w=400", "Juicy navel oranges", "per lb"},
                    {"Strawberry", "Fruits", 3.99, 80, "https://images.unsplash.com/photo-1464965911861-746a04b4bca6?w=400", "Fresh strawberries", "pint"},
                    {"Mango", "Fruits", 1.49, 100, "https://images.unsplash.com/photo-1553279768-865429fa0078?w=400", "Sweet ripe mangoes", "each"},
                    // Vegetables
                    {"Broccoli", "Vegetables", 1.79, 100, "https://images.unsplash.com/photo-1459411621453-7b03977f4bfc?w=400", "Fresh broccoli crown", "each"},
                    {"Carrot", "Vegetables", 1.29, 150, "https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?w=400", "Organic baby carrots", "per lb"},
                    {"Tomato", "Vegetables", 2.19, 120, "https://images.unsplash.com/photo-1546470427-e26264be0b0d?w=400", "Vine-ripened tomatoes", "per lb"},
                    {"Spinach", "Vegetables", 2.99, 90, "https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=400", "Baby spinach leaves", "bag"},
                    {"Onion", "Vegetables", 0.99, 200, "https://images.unsplash.com/photo-1508747703725-719777637510?w=400", "Yellow cooking onions", "per lb"},
                    // Dairy
                    {"Whole Milk", "Dairy", 3.49, 60, "https://images.unsplash.com/photo-1563636619-e9143da7973b?w=400", "Fresh whole milk", "gallon"},
                    {"Cheddar Cheese", "Dairy", 4.99, 50, "https://images.unsplash.com/photo-1552767059-ce182ead6c1b?w=400", "Sharp cheddar block", "8 oz"},
                    {"Greek Yogurt", "Dairy", 1.79, 70, "https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400", "Plain greek yogurt", "6 oz"},
                    {"Butter", "Dairy", 3.99, 55, "https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=400", "Unsalted butter", "1 lb"},
                    // Bakery
                    {"Sourdough Bread", "Bakery", 4.49, 40, "https://images.unsplash.com/photo-1586444248902-2f64eddc13df?w=400", "Artisan sourdough loaf", "loaf"},
                    {"Croissant", "Bakery", 2.29, 30, "https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=400", "Butter croissant", "each"},
                    // Pantry
                    {"Olive Oil", "Pantry", 7.99, 45, "https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=400", "Extra virgin olive oil", "500ml"},
                    {"Pasta", "Pantry", 1.99, 100, "https://images.unsplash.com/photo-1551462147-37885acc36f1?w=400", "Spaghetti pasta", "1 lb"},
                    {"Rice", "Pantry", 3.49, 80, "https://images.unsplash.com/photo-1536304929831-ee1ca9d44906?w=400", "Long grain white rice", "2 lb"},
                    {"Coffee", "Pantry", 10.99, 60, "https://images.unsplash.com/photo-1447933601403-0c6688de566e?w=400", "Medium roast ground coffee", "12 oz"},
            };
            for (Object[] p : products) {
                ps.setString(1, (String) p[0]);
                ps.setString(2, (String) p[1]);
                ps.setDouble(3, (Double) p[2]);
                ps.setInt(4, (Integer) p[3]);
                ps.setString(5, (String) p[4]);
                ps.setString(6, (String) p[5]);
                ps.setString(7, (String) p[6]);
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }
}
