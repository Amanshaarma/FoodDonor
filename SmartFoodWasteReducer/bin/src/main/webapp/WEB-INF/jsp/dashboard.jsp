<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard - Smart Food Waste Reducer</title>
    <link rel="stylesheet" href="/css/style.css"/>
    <script src="/js/app.js" defer></script>
</head>
<body class="royal-bg">
<header class="header">
    <h1>Dashboard</h1>
    <nav>
        <a href="/postFood">Post Food</a>
        <a href="/analytics">Analytics</a>
        <a href="/login" onclick="localStorage.removeItem('token')">Logout</a>
    </nav>
    </header>
<div class="container">
    <section class="panel">
        <h2>Nearby Donations</h2>
        <div id="donations"></div>
    </section>
</div>
</body>
</html>


