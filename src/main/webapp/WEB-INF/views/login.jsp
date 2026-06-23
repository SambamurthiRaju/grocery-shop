<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GreenCart — Login</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=DM+Serif+Display&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root {
            --green: #2d6a4f;
            --green-light: #40916c;
            --green-pale: #d8f3dc;
            --cream: #fefae0;
            --dark: #1b1b1b;
            --muted: #6b7280;
            --red: #dc2626;
        }
        body {
            font-family: 'DM Sans', sans-serif;
            background: var(--cream);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .page-wrap {
            display: flex;
            width: 900px;
            max-width: 100%;
            min-height: 520px;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 20px 60px rgba(0,0,0,0.12);
        }
        .left-panel {
            flex: 1;
            background: var(--green);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 48px;
            color: white;
        }
        .left-panel .logo { font-family: 'DM Serif Display', serif; font-size: 2.4rem; margin-bottom: 12px; }
        .left-panel p { font-size: 1rem; opacity: 0.8; text-align: center; line-height: 1.6; }
        .left-panel .emoji { font-size: 4rem; margin-bottom: 20px; }
        .right-panel {
            flex: 1;
            background: white;
            padding: 48px 44px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        h2 { font-family: 'DM Serif Display', serif; font-size: 1.8rem; color: var(--dark); margin-bottom: 6px; }
        .subtitle { color: var(--muted); font-size: 0.9rem; margin-bottom: 28px; }
        .form-group { margin-bottom: 18px; }
        label { display: block; font-size: 0.82rem; font-weight: 600; color: var(--dark); margin-bottom: 6px; letter-spacing: 0.03em; text-transform: uppercase; }
        input {
            width: 100%; padding: 11px 14px;
            border: 1.5px solid #e5e7eb;
            border-radius: 8px;
            font-size: 0.95rem;
            font-family: 'DM Sans', sans-serif;
            color: var(--dark);
            transition: border-color 0.2s;
            outline: none;
        }
        input:focus { border-color: var(--green-light); }
        .btn {
            width: 100%; padding: 13px;
            background: var(--green);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            font-family: 'DM Sans', sans-serif;
            cursor: pointer;
            transition: background 0.2s;
            margin-top: 6px;
        }
        .btn:hover { background: var(--green-light); }
        .alert { padding: 10px 14px; border-radius: 8px; font-size: 0.88rem; margin-bottom: 18px; }
        .alert-error { background: #fee2e2; color: var(--red); }
        .alert-success { background: var(--green-pale); color: var(--green); }
        .footer-link { text-align: center; margin-top: 20px; font-size: 0.88rem; color: var(--muted); }
        .footer-link a { color: var(--green); font-weight: 600; text-decoration: none; }
        .demo-hint { background: var(--green-pale); border-radius: 8px; padding: 10px 14px; font-size: 0.82rem; color: var(--green); margin-bottom: 20px; }
        @media(max-width: 640px) { .left-panel { display: none; } .right-panel { padding: 36px 24px; } }
    </style>
</head>
<body>
<div class="page-wrap">
    <div class="left-panel">
        <div class="emoji">🛒</div>
        <div class="logo">GreenCart</div>
        <p>Fresh groceries delivered to your door. Quality produce, everyday essentials.</p>
    </div>
    <div class="right-panel">
        <h2>Welcome back</h2>
        <p class="subtitle">Sign in to your account to continue shopping</p>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error">${error}</div>
        <% } %>
        <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success">${success}</div>
        <% } %>

        <div class="demo-hint">🔑 Demo login — username: <strong>demo</strong> &nbsp;|&nbsp; password: <strong>demo123</strong></div>

        <form method="post" action="${pageContext.request.contextPath}/login">
            <div class="form-group">
                <label>Username</label>
                <input type="text" name="username" placeholder="Enter username" required autofocus>
            </div>
            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" placeholder="Enter password" required>
            </div>
            <button class="btn" type="submit">Sign In</button>
        </form>

        <div class="footer-link">
            New here? <a href="${pageContext.request.contextPath}/register">Create an account</a>
        </div>
    </div>
</div>
</body>
</html>
