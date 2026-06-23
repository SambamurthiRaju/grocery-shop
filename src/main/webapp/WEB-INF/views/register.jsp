<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GreenCart — Register</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=DM+Serif+Display&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root { --green: #2d6a4f; --green-light: #40916c; --green-pale: #d8f3dc; --cream: #fefae0; --dark: #1b1b1b; --muted: #6b7280; --red: #dc2626; }
        body { font-family: 'DM Sans', sans-serif; background: var(--cream); min-height: 100vh; display: flex; align-items: center; justify-content: center; }
        .card { background: white; border-radius: 20px; box-shadow: 0 20px 60px rgba(0,0,0,0.1); padding: 48px 44px; width: 460px; max-width: 96vw; }
        .brand { font-family: 'DM Serif Display', serif; font-size: 1.6rem; color: var(--green); margin-bottom: 4px; }
        h2 { font-family: 'DM Serif Display', serif; font-size: 1.5rem; color: var(--dark); margin-bottom: 4px; }
        .subtitle { color: var(--muted); font-size: 0.88rem; margin-bottom: 26px; }
        .form-group { margin-bottom: 16px; }
        label { display: block; font-size: 0.82rem; font-weight: 600; color: var(--dark); margin-bottom: 5px; letter-spacing: 0.03em; text-transform: uppercase; }
        input { width: 100%; padding: 11px 14px; border: 1.5px solid #e5e7eb; border-radius: 8px; font-size: 0.95rem; font-family: 'DM Sans', sans-serif; outline: none; transition: border-color 0.2s; }
        input:focus { border-color: var(--green-light); }
        .btn { width: 100%; padding: 13px; background: var(--green); color: white; border: none; border-radius: 8px; font-size: 1rem; font-weight: 600; font-family: 'DM Sans', sans-serif; cursor: pointer; transition: background 0.2s; margin-top: 4px; }
        .btn:hover { background: var(--green-light); }
        .alert { padding: 10px 14px; border-radius: 8px; font-size: 0.88rem; margin-bottom: 16px; }
        .alert-error { background: #fee2e2; color: var(--red); }
        .footer-link { text-align: center; margin-top: 18px; font-size: 0.88rem; color: var(--muted); }
        .footer-link a { color: var(--green); font-weight: 600; text-decoration: none; }
    </style>
</head>
<body>
<div class="card">
    <div class="brand">🛒 GreenCart</div>
    <h2>Create account</h2>
    <p class="subtitle">Join us and start shopping fresh</p>

    <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-error">${error}</div>
    <% } %>

    <form method="post" action="${pageContext.request.contextPath}/register">
        <div class="form-group">
            <label>Full Name</label>
            <input type="text" name="fullName" placeholder="Jane Smith" required>
        </div>
        <div class="form-group">
            <label>Username</label>
            <input type="text" name="username" placeholder="janesmithz" required>
        </div>
        <div class="form-group">
            <label>Email</label>
            <input type="email" name="email" placeholder="jane@example.com" required>
        </div>
        <div class="form-group">
            <label>Password</label>
            <input type="password" name="password" placeholder="At least 6 characters" minlength="6" required>
        </div>
        <button class="btn" type="submit">Create Account</button>
    </form>

    <div class="footer-link">Already have an account? <a href="${pageContext.request.contextPath}/login">Sign in</a></div>
</div>
</body>
</html>
