package com.grocery.servlet;

import com.grocery.dao.ProductDAO;
import com.grocery.model.CartItem;
import com.grocery.model.Product;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (req.getSession(false) == null || req.getSession(false).getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        req.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (req.getSession(false) == null || req.getSession(false).getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        HttpSession session = req.getSession();

        @SuppressWarnings("unchecked")
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new LinkedHashMap<>();
            session.setAttribute("cart", cart);
        }

        try {
            if ("add".equals(action)) {
                int productId = Integer.parseInt(req.getParameter("productId"));
                int qty = Integer.parseInt(req.getParameter("quantity") != null ? req.getParameter("quantity") : "1");
                Product product = productDAO.getProductById(productId);
                if (product != null) {
                    if (cart.containsKey(productId)) {
                        cart.get(productId).setQuantity(cart.get(productId).getQuantity() + qty);
                    } else {
                        cart.put(productId, new CartItem(product, qty));
                    }
                }
                resp.sendRedirect(req.getContextPath() + "/shop");

            } else if ("remove".equals(action)) {
                int productId = Integer.parseInt(req.getParameter("productId"));
                cart.remove(productId);
                resp.sendRedirect(req.getContextPath() + "/cart");

            } else if ("update".equals(action)) {
                int productId = Integer.parseInt(req.getParameter("productId"));
                int qty = Integer.parseInt(req.getParameter("quantity"));
                if (qty <= 0) {
                    cart.remove(productId);
                } else if (cart.containsKey(productId)) {
                    cart.get(productId).setQuantity(qty);
                }
                resp.sendRedirect(req.getContextPath() + "/cart");

            } else if ("clear".equals(action)) {
                cart.clear();
                resp.sendRedirect(req.getContextPath() + "/cart");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
