<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Smart Food Waste Reducer</title>
    <link rel="stylesheet" href="/css/style.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <script src="/js/app.js" defer></script>
</head>
<body class="royal-bg">
<header class="header">
    <h1><i class="fas fa-leaf"></i> Smart Food Waste Reducer</h1>
    <nav>
        <a href="/dashboard"><i class="fas fa-home"></i> Dashboard</a>
        <a href="/postFood"><i class="fas fa-plus-circle"></i> Post Food</a>
        <a href="/analytics"><i class="fas fa-chart-bar"></i> Analytics</a>
        <a href="/login" onclick="localStorage.removeItem('token')"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </nav>
</header>
<div class="container">
    <section class="panel">
        <h2><i class="fas fa-utensils"></i> My Donations</h2>
        <p style="color: var(--text-secondary); margin-bottom: 1rem;">Food donated by your organization</p>
        <div id="donations" style="min-height: 200px; display: flex; flex-direction: column; gap: 1rem;">
            <p style="color: var(--text-secondary); text-align: center; padding: 2rem;">Loading your donations...</p>
        </div>
    </section>
</div>
</body>
</html>
