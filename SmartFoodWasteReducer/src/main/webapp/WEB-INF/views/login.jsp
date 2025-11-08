<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Smart Food Waste Reducer</title>
    <link rel="stylesheet" href="/css/style.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <script src="/js/validate.js" defer></script>
</head>
<body class="royal-bg">
    <header class="header">
        <h1><i class="fas fa-leaf"></i> Smart Food Waste Reducer</h1>
        <nav>
            <a href="/"><i class="fas fa-home"></i> Home</a>
            <a href="/login"><i class="fas fa-sign-in-alt"></i> Login</a>
            <a href="/register"><i class="fas fa-user-plus"></i> Register</a>
            <a href="/about"><i class="fas fa-info-circle"></i> About</a>
            <a href="/contact-us"><i class="fas fa-envelope"></i> Contact Us</a>
        </nav>
    </header>
<div class="card">
    <div style="text-align: center; margin-bottom: 2rem;">
        <div style="width: 80px; height: 80px; margin: 0 auto 1rem; background: linear-gradient(135deg, var(--accent-gold), #f59e0b); border-radius: 50%; display: flex; align-items: center; justify-content: center; box-shadow: var(--shadow-lg);">
            <i class="fas fa-leaf" style="font-size: 2.5rem; color: white;"></i>
        </div>
    </div>
    <h1 class="title">Smart Food Waste Reducer</h1>
    <h2 class="subtitle">Welcome back! Please login to continue</h2>
    <form id="loginForm" onsubmit="return validateLogin(event)">
        <label for="email"><i class="fas fa-envelope"></i> Email Address</label>
        <input type="email" id="email" name="email" placeholder="Enter your email" required/>
        <label for="password"><i class="fas fa-lock"></i> Password</label>
        <div class="password-input-wrapper">
        <input type="password" id="password" name="password" placeholder="Enter your password" required/>
            <i class="fas fa-eye password-toggle" id="passwordToggle" onclick="togglePassword('password', 'passwordToggle')"></i>
        </div>
        <label for="role"><i class="fas fa-user-tag"></i> Role</label>
        <select id="role" name="role" required>
            <option value="">Select your role</option>
            <option value="DONOR">Donor - Share surplus food</option>
            <option value="RECEIVER">Receiver - Collect food donations</option>
        </select>
        <button type="submit" id="loginSubmit" class="btn-primary" disabled>
            <i class="fas fa-sign-in-alt"></i> Login
        </button>
    </form>
    <p class="muted">Don't have an account? <a href="/register">Create one here</a></p>
</div>
</body>
</html>
