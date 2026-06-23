package com.grocery.servlet;

import com.grocery.dao.ProductDAO;
import com.grocery.model.Product;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/shop")
public class ShopServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (req.getSession(false) == null || req.getSession(false).getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String category = req.getParameter("category");
        String search = req.getParameter("search");

        try {
            List<Product> products;
            List<String> categories = productDAO.getCategories();

            if (search != null && !search.trim().isEmpty()) {
                products = productDAO.searchProducts(search.trim());
                req.setAttribute("search", search);
            } else if (category != null && !category.isEmpty()) {
                products = productDAO.getProductsByCategory(category);
                req.setAttribute("activeCategory", category);
            } else {
                products = productDAO.getAllProducts();
            }

            req.setAttribute("products", products);
            req.setAttribute("categories", categories);
            req.getRequestDispatcher("/WEB-INF/views/shop.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
