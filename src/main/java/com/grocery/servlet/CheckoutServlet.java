package com.grocery.servlet;

import com.grocery.dao.OrderDAO;
import com.grocery.model.CartItem;
import com.grocery.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Map;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        @SuppressWarnings("unchecked")
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        User user = (User) session.getAttribute("user");
        double total = cart.values().stream().mapToDouble(CartItem::getSubtotal).sum();

        try {
            int orderId = orderDAO.placeOrder(user.getId(), new java.util.ArrayList<>(cart.values()), total);
            cart.clear();
            session.setAttribute("lastOrderId", orderId);
            session.setAttribute("lastOrderTotal", total);
            resp.sendRedirect(req.getContextPath() + "/order-success");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
