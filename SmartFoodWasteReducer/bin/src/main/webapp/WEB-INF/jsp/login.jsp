<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Smart Food Waste Reducer</title>
    <link rel="stylesheet" href="/css/style.css"/>
    <script src="/js/validate.js" defer></script>
</head>
<body class="royal-bg">
<div class="card">
    <h1 class="title">Smart Food Waste Reducer</h1>
    <h2 class="subtitle">Login</h2>
    <form id="loginForm" onsubmit="return validateLogin(event)">
        <label>Email</label>
        <input type="email" id="email" placeholder="you@example.com" required/>
        <label>Password</label>
        <input type="password" id="password" placeholder="••••••••" required/>
        <button type="submit" class="btn-primary">Login</button>
    </form>
    <p class="muted">No account? <a href="/register">Register</a></p>
</div>
</body>
</html>


