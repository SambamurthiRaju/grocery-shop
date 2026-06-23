<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GreenCart — Cart</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=DM+Serif+Display&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root { --green: #2d6a4f; --green-light: #40916c; --green-pale: #d8f3dc; --cream: #fefae0; --dark: #1b1b1b; --muted: #6b7280; --border: #e5e7eb; --red: #dc2626; }
        body { font-family: 'DM Sans', sans-serif; background: #f8f9f4; color: var(--dark); }

        nav {
            background: var(--green); padding: 0 32px;
            display: flex; align-items: center; justify-content: space-between;
            height: 60px; position: sticky; top: 0; z-index: 100;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
        }
        .nav-brand { font-family: 'DM Serif Display', serif; font-size: 1.5rem; color: white; text-decoration: none; }
        .nav-right { display: flex; align-items: center; gap: 16px; }
        .back-btn { background: rgba(255,255,255,0.2); color: white; padding: 7px 16px; border-radius: 8px; border: none; font-family: 'DM Sans', sans-serif; font-size: 0.88rem; cursor: pointer; text-decoration: none; }
        .back-btn:hover { background: rgba(255,255,255,0.3); }
        .nav-logout { color: rgba(255,255,255,0.7); font-size: 0.85rem; text-decoration: none; }
        .nav-logout:hover { color: white; }

        .main { max-width: 960px; margin: 0 auto; padding: 32px 24px; }
        h1 { font-family: 'DM Serif Display', serif; font-size: 1.8rem; margin-bottom: 24px; }

        .layout { display: grid; grid-template-columns: 1fr 320px; gap: 24px; align-items: start; }

        /* CART ITEMS */
        .cart-items { background: white; border-radius: 14px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.06); }
        .cart-item {
            display: flex; align-items: center; gap: 16px;
            padding: 16px 20px;
            border-bottom: 1px solid var(--border);
        }
        .cart-item:last-child { border-bottom: none; }
        .item-img { width: 72px; height: 72px; border-radius: 10px; overflow: hidden; flex-shrink: 0; }
        .item-img img { width: 100%; height: 100%; object-fit: cover; }
        .item-info { flex: 1; }
        .item-name { font-weight: 600; font-size: 0.95rem; margin-bottom: 2px; }
        .item-price { font-size: 0.82rem; color: var(--muted); }
        .item-controls { display: flex; align-items: center; gap: 10px; }
        .qty-form { display: flex; align-items: center; gap: 6px; }
        .qty-btn {
            width: 28px; height: 28px; border-radius: 6px;
            border: 1.5px solid var(--border); background: white;
            font-size: 1rem; cursor: pointer; display: flex;
            align-items: center; justify-content: center;
            font-family: 'DM Sans', sans-serif; color: var(--dark);
            transition: all 0.15s;
        }
        .qty-btn:hover { border-color: var(--green); color: var(--green); }
        .qty-display { font-weight: 700; font-size: 0.95rem; min-width: 24px; text-align: center; }
        .item-subtotal { font-weight: 700; font-size: 0.95rem; color: var(--green); min-width: 60px; text-align: right; }
        .remove-btn {
            background: none; border: none; color: #ccc;
            cursor: pointer; font-size: 1.1rem; padding: 4px;
            transition: color 0.15s;
        }
        .remove-btn:hover { color: var(--red); }

        /* ORDER SUMMARY */
        .summary { background: white; border-radius: 14px; padding: 24px; box-shadow: 0 2px 8px rgba(0,0,0,0.06); }
        .summary h2 { font-family: 'DM Serif Display', serif; font-size: 1.2rem; margin-bottom: 18px; }
        .summary-row { display: flex; justify-content: space-between; margin-bottom: 10px; font-size: 0.9rem; }
        .summary-row.total { font-weight: 700; font-size: 1.05rem; border-top: 1px solid var(--border); padding-top: 12px; margin-top: 6px; }
        .summary-row span:last-child { color: var(--green); }
        .checkout-btn {
            width: 100%; padding: 14px;
            background: var(--green); color: white;
            border: none; border-radius: 10px;
            font-size: 1rem; font-weight: 700;
            font-family: 'DM Sans', sans-serif;
            cursor: pointer; margin-top: 18px;
            transition: background 0.2s;
        }
        .checkout-btn:hover { background: var(--green-light); }
        .clear-btn {
            width: 100%; padding: 10px;
            background: white; color: var(--muted);
            border: 1.5px solid var(--border); border-radius: 10px;
            font-size: 0.88rem; font-family: 'DM Sans', sans-serif;
            cursor: pointer; margin-top: 10px; transition: all 0.15s;
        }
        .clear-btn:hover { border-color: var(--red); color: var(--red); }

        /* EMPTY */
        .empty { text-align: center; padding: 60px 20px; color: var(--muted); }
        .empty div { font-size: 4rem; margin-bottom: 14px; }
        .empty p { font-size: 1rem; margin-bottom: 20px; }
        .shop-link {
            display: inline-block;
            background: var(--green); color: white;
            padding: 12px 28px; border-radius: 10px;
            text-decoration: none; font-weight: 600;
        }

        @media(max-width: 700px) {
            .layout { grid-template-columns: 1fr; }
            .item-controls { flex-direction: column; align-items: flex-end; gap: 6px; }
        }
    </style>
</head>
<body>

<nav>
    <a class="nav-brand" href="${pageContext.request.contextPath}/shop">🛒 GreenCart</a>
    <div class="nav-right">
        <a class="back-btn" href="${pageContext.request.contextPath}/shop">← Continue Shopping</a>
        <a class="nav-logout" href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
</nav>

<div class="main">
    <h1>Your Cart</h1>

    <c:set var="cart" value="${sessionScope.cart}" />

    <c:choose>
        <c:when test="${empty cart}">
            <div class="empty">
                <div>🛍️</div>
                <p>Your cart is empty</p>
                <a class="shop-link" href="${pageContext.request.contextPath}/shop">Start Shopping</a>
            </div>
        </c:when>
        <c:otherwise>
            <c:set var="total" value="0" />
            <c:forEach var="entry" items="${cart}">
                <c:set var="total" value="${total + entry.value.subtotal}" />
            </c:forEach>

            <div class="layout">
                <div class="cart-items">
                    <c:forEach var="entry" items="${cart}">
                        <c:set var="item" value="${entry.value}" />
                        <div class="cart-item">
                            <div class="item-img">
                                <img src="${item.product.imageUrl}" alt="${item.product.name}"
                                     onerror="this.src='https://images.unsplash.com/photo-1542838132-92c53300491e?w=200'">
                            </div>
                            <div class="item-info">
                                <div class="item-name">${item.product.name}</div>
                                <div class="item-price">$<fmt:formatNumber value="${item.product.price}" minFractionDigits="2" maxFractionDigits="2"/> / ${item.product.unit}</div>
                            </div>
                            <div class="item-controls">
                                <!-- Decrease -->
                                <form method="post" action="${pageContext.request.contextPath}/cart">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="productId" value="${item.product.id}">
                                    <input type="hidden" name="quantity" value="${item.quantity - 1}">
                                    <button class="qty-btn" type="submit">−</button>
                                </form>
                                <span class="qty-display">${item.quantity}</span>
                                <!-- Increase -->
                                <form method="post" action="${pageContext.request.contextPath}/cart">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="productId" value="${item.product.id}">
                                    <input type="hidden" name="quantity" value="${item.quantity + 1}">
                                    <button class="qty-btn" type="submit">+</button>
                                </form>
                            </div>
                            <div class="item-subtotal">$<fmt:formatNumber value="${item.subtotal}" minFractionDigits="2" maxFractionDigits="2"/></div>
                            <!-- Remove -->
                            <form method="post" action="${pageContext.request.contextPath}/cart">
                                <input type="hidden" name="action" value="remove">
                                <input type="hidden" name="productId" value="${item.product.id}">
                                <button class="remove-btn" type="submit" title="Remove">✕</button>
                            </form>
                        </div>
                    </c:forEach>
                </div>

                <div class="summary">
                    <h2>Order Summary</h2>
                    <div class="summary-row"><span>${cart.size()} item(s)</span><span>$<fmt:formatNumber value="${total}" minFractionDigits="2" maxFractionDigits="2"/></span></div>
                    <div class="summary-row"><span>Delivery</span><span>FREE</span></div>
                    <div class="summary-row total"><span>Total</span><span>$<fmt:formatNumber value="${total}" minFractionDigits="2" maxFractionDigits="2"/></span></div>

                    <form method="post" action="${pageContext.request.contextPath}/checkout">
                        <button class="checkout-btn" type="submit">✅ Place Order</button>
                    </form>
                    <form method="post" action="${pageContext.request.contextPath}/cart">
                        <input type="hidden" name="action" value="clear">
                        <button class="clear-btn" type="submit">🗑 Clear Cart</button>
                    </form>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>
