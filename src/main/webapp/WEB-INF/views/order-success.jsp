<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GreenCart — Order Placed!</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=DM+Serif+Display&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root { --green: #2d6a4f; --green-light: #40916c; --green-pale: #d8f3dc; --cream: #fefae0; --dark: #1b1b1b; --muted: #6b7280; }
        body { font-family: 'DM Sans', sans-serif; background: var(--cream); min-height: 100vh; display: flex; align-items: center; justify-content: center; }
        .card {
            background: white; border-radius: 20px;
            padding: 56px 48px; text-align: center;
            max-width: 480px; width: 100%;
            box-shadow: 0 20px 60px rgba(0,0,0,0.1);
            animation: popIn 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
        }
        @keyframes popIn { from { transform: scale(0.8); opacity: 0; } to { transform: scale(1); opacity: 1; } }
        .icon { font-size: 5rem; margin-bottom: 16px; animation: bounce 0.6s 0.3s ease both; }
        @keyframes bounce { 0%,100% { transform: translateY(0); } 50% { transform: translateY(-12px); } }
        h1 { font-family: 'DM Serif Display', serif; font-size: 2rem; color: var(--dark); margin-bottom: 8px; }
        p { color: var(--muted); font-size: 0.95rem; line-height: 1.6; margin-bottom: 6px; }
        .order-box {
            background: var(--green-pale); border-radius: 12px;
            padding: 18px 24px; margin: 24px 0;
        }
        .order-box .label { font-size: 0.8rem; color: var(--green); font-weight: 600; text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 4px; }
        .order-box .value { font-family: 'DM Serif Display', serif; font-size: 1.3rem; color: var(--dark); }
        .btn {
            display: inline-block;
            background: var(--green); color: white;
            padding: 13px 32px; border-radius: 10px;
            text-decoration: none; font-weight: 700;
            font-size: 0.95rem; margin-top: 8px;
            transition: background 0.2s;
        }
        .btn:hover { background: var(--green-light); }
    </style>
</head>
<body>
<div class="card">
    <div class="icon">🎉</div>
    <h1>Order Placed!</h1>
    <p>Thanks for shopping with GreenCart, <strong>${sessionScope.user.fullName}</strong>!</p>
    <p>Your fresh groceries are being prepared.</p>

    <div class="order-box">
        <div class="label">Order ID</div>
        <div class="value">#${sessionScope.lastOrderId}</div>
        <div style="margin-top:10px;">
            <div class="label">Total Charged</div>
            <div class="value">$<fmt:formatNumber value="${sessionScope.lastOrderTotal}" minFractionDigits="2" maxFractionDigits="2"/></div>
        </div>
    </div>

    <p style="font-size:0.82rem;">Estimated delivery: <strong>2–4 hours</strong></p>
    <br>
    <a class="btn" href="${pageContext.request.contextPath}/shop">🛒 Shop Again</a>
</div>
</body>
</html>
