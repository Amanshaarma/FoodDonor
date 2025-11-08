<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Analytics - Smart Food Waste Reducer</title>
    <link rel="stylesheet" href="/css/style.css"/>
    <script src="/js/app.js" defer></script>
</head>
<body class="royal-bg">
<header class="header">
    <h1>Analytics</h1>
    <nav>
        <a href="/dashboard">Dashboard</a>
        <a href="/postFood">Post Food</a>
    </nav>
    </header>
<div class="container">
    <section class="panel">
        <h2>Total Meals Saved</h2>
        <div id="mealsSaved" class="metric"></div>
    </section>
    <section class="panel">
        <h2>Top Donors</h2>
        <div id="topDonors"></div>
    </section>
</div>
</body>
</html>


