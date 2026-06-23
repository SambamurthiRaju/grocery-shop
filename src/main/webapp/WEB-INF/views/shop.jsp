<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GreenCart — Shop</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=DM+Serif+Display&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root {
            --green: #2d6a4f; --green-light: #40916c; --green-pale: #d8f3dc;
            --cream: #fefae0; --dark: #1b1b1b; --muted: #6b7280;
            --border: #e5e7eb; --white: #ffffff;
        }
        body { font-family: 'DM Sans', sans-serif; background: #f8f9f4; color: var(--dark); }

        /* NAV */
        nav {
            background: var(--green);
            padding: 0 32px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            height: 60px;
            position: sticky; top: 0; z-index: 100;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
        }
        .nav-brand { font-family: 'DM Serif Display', serif; font-size: 1.5rem; color: white; text-decoration: none; }
        .nav-right { display: flex; align-items: center; gap: 16px; }
        .nav-user { color: rgba(255,255,255,0.85); font-size: 0.88rem; }
        .nav-cart {
            background: white; color: var(--green);
            border: none; border-radius: 8px;
            padding: 7px 16px; font-weight: 700;
            font-family: 'DM Sans', sans-serif;
            cursor: pointer; font-size: 0.9rem;
            text-decoration: none; display: flex; align-items: center; gap: 6px;
            transition: transform 0.15s;
        }
        .nav-cart:hover { transform: scale(1.04); }
        .nav-logout { color: rgba(255,255,255,0.7); font-size: 0.85rem; text-decoration: none; }
        .nav-logout:hover { color: white; }

        /* SEARCH + FILTER BAR */
        .top-bar {
            background: white;
            padding: 16px 32px;
            display: flex;
            align-items: center;
            gap: 12px;
            border-bottom: 1px solid var(--border);
            flex-wrap: wrap;
        }
        .search-wrap { flex: 1; min-width: 200px; position: relative; }
        .search-wrap input {
            width: 100%; padding: 9px 14px 9px 38px;
            border: 1.5px solid var(--border); border-radius: 8px;
            font-family: 'DM Sans', sans-serif; font-size: 0.9rem; outline: none;
            transition: border-color 0.2s;
        }
        .search-wrap input:focus { border-color: var(--green-light); }
        .search-wrap::before { content: '🔍'; position: absolute; left: 11px; top: 50%; transform: translateY(-50%); font-size: 0.85rem; }
        .search-wrap button {
            position: absolute; right: 6px; top: 50%; transform: translateY(-50%);
            background: var(--green); color: white; border: none; border-radius: 6px;
            padding: 5px 12px; cursor: pointer; font-size: 0.82rem; font-family: 'DM Sans', sans-serif;
        }
        .categories { display: flex; gap: 8px; flex-wrap: wrap; }
        .cat-btn {
            padding: 6px 14px; border-radius: 20px; border: 1.5px solid var(--border);
            background: white; cursor: pointer; font-size: 0.82rem;
            font-family: 'DM Sans', sans-serif; color: var(--muted);
            text-decoration: none; transition: all 0.15s; white-space: nowrap;
        }
        .cat-btn:hover, .cat-btn.active {
            background: var(--green); color: white; border-color: var(--green);
        }

        /* MAIN LAYOUT */
        .main { padding: 28px 32px; }
        .section-title {
            font-family: 'DM Serif Display', serif;
            font-size: 1.4rem; color: var(--dark);
            margin-bottom: 20px;
        }
        .section-title span { font-size: 0.9rem; color: var(--muted); font-family: 'DM Sans', sans-serif; font-weight: 400; margin-left: 8px; }

        /* PRODUCT GRID */
        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 18px;
        }
        .card {
            background: white;
            border-radius: 14px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            transition: transform 0.2s, box-shadow 0.2s;
            display: flex; flex-direction: column;
        }
        .card:hover { transform: translateY(-3px); box-shadow: 0 8px 24px rgba(0,0,0,0.1); }
        .card-img {
            height: 160px;
            overflow: hidden;
            background: #f3f4f0;
            position: relative;
        }
        .card-img img {
            width: 100%; height: 100%;
            object-fit: cover;
            transition: transform 0.3s;
        }
        .card:hover .card-img img { transform: scale(1.06); }
        .card-badge {
            position: absolute; top: 8px; left: 8px;
            background: var(--green-pale); color: var(--green);
            font-size: 0.7rem; font-weight: 700;
            padding: 2px 8px; border-radius: 20px;
            text-transform: uppercase; letter-spacing: 0.04em;
        }
        .card-body { padding: 14px; flex: 1; display: flex; flex-direction: column; }
        .card-name { font-weight: 600; font-size: 0.95rem; margin-bottom: 2px; }
        .card-desc { font-size: 0.78rem; color: var(--muted); margin-bottom: 10px; flex: 1; }
        .card-footer { display: flex; align-items: center; justify-content: space-between; margin-top: auto; }
        .card-price { font-weight: 700; font-size: 1.05rem; color: var(--green); }
        .card-unit { font-size: 0.72rem; color: var(--muted); margin-top: 1px; }
        .add-btn {
            background: var(--green); color: white;
            border: none; border-radius: 8px;
            padding: 7px 14px; font-size: 0.85rem;
            font-weight: 600; font-family: 'DM Sans', sans-serif;
            cursor: pointer; transition: background 0.15s;
        }
        .add-btn:hover { background: var(--green-light); }
        .add-btn:active { transform: scale(0.96); }

        /* TOAST */
        #toast {
            position: fixed; bottom: 28px; left: 50%; transform: translateX(-50%) translateY(80px);
            background: var(--dark); color: white;
            padding: 12px 24px; border-radius: 10px;
            font-size: 0.9rem; font-weight: 500;
            opacity: 0; transition: all 0.3s; z-index: 999;
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
        }
        #toast.show { opacity: 1; transform: translateX(-50%) translateY(0); }

        .empty { text-align: center; padding: 60px 20px; color: var(--muted); font-size: 1rem; }
        .empty div { font-size: 3rem; margin-bottom: 12px; }

        @media(max-width: 600px) { .main { padding: 20px 16px; } nav { padding: 0 16px; } .top-bar { padding: 12px 16px; } }
    </style>
</head>
<body>

<nav>
    <a class="nav-brand" href="${pageContext.request.contextPath}/shop">🛒 GreenCart</a>
    <div class="nav-right">
        <span class="nav-user">👤 ${sessionScope.user.fullName}</span>
        <a class="nav-cart" href="${pageContext.request.contextPath}/cart">
            🛍
            <span id="cart-count">
                <c:choose>
                    <c:when test="${sessionScope.cart != null}">${sessionScope.cart.size()}</c:when>
                    <c:otherwise>0</c:otherwise>
                </c:choose>
            </span> items
        </a>
        <a class="nav-logout" href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
</nav>

<div class="top-bar">
    <form method="get" action="${pageContext.request.contextPath}/shop" class="search-wrap" style="display:flex;align-items:center;">
        <input type="text" name="search" value="${search}" placeholder="Search groceries...">
        <button type="submit">Go</button>
    </form>
    <div class="categories">
        <a class="cat-btn ${activeCategory == null && search == null ? 'active' : ''}"
           href="${pageContext.request.contextPath}/shop">All</a>
        <c:forEach var="cat" items="${categories}">
            <a class="cat-btn ${activeCategory == cat ? 'active' : ''}"
               href="${pageContext.request.contextPath}/shop?category=${cat}">${cat}</a>
        </c:forEach>
    </div>
</div>

<div class="main">
    <div class="section-title">
        <c:choose>
            <c:when test="${search != null}">Search: "${search}" <span>${products.size()} results</span></c:when>
            <c:when test="${activeCategory != null}">${activeCategory} <span>${products.size()} items</span></c:when>
            <c:otherwise>All Products <span>${products.size()} items</span></c:otherwise>
        </c:choose>
    </div>

    <c:choose>
        <c:when test="${empty products}">
            <div class="empty"><div>🥦</div>No products found. <a href="${pageContext.request.contextPath}/shop" style="color:var(--green);">Browse all</a></div>
        </c:when>
        <c:otherwise>
            <div class="grid">
                <c:forEach var="p" items="${products}">
                    <div class="card">
                        <div class="card-img">
                            <img src="${p.imageUrl}" alt="${p.name}" loading="lazy"
                                 onerror="this.src='https://images.unsplash.com/photo-1542838132-92c53300491e?w=400'">
                            <div class="card-badge">${p.category}</div>
                        </div>
                        <div class="card-body">
                            <div class="card-name">${p.name}</div>
                            <div class="card-desc">${p.description}</div>
                            <div class="card-footer">
                                <div>
                                    <div class="card-price">$<fmt:formatNumber value="${p.price}" minFractionDigits="2" maxFractionDigits="2"/></div>
                                    <div class="card-unit">${p.unit}</div>
                                </div>
                                <form method="post" action="${pageContext.request.contextPath}/cart" style="margin:0;">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="productId" value="${p.id}">
                                    <input type="hidden" name="quantity" value="1">
                                    <button class="add-btn" type="submit" onclick="showToast('${p.name} added to cart!')">+ Add</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<div id="toast"></div>

<script>
function showToast(msg) {
    const t = document.getElementById('toast');
    t.textContent = '✅ ' + msg;
    t.classList.add('show');
    setTimeout(() => t.classList.remove('show'), 2200);
}
</script>
</body>
</html>
