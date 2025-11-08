<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Post Food - Smart Food Waste Reducer</title>
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
    <div class="card" style="max-width: 600px;">
        <div style="text-align: center; margin-bottom: 2rem;">
            <div style="width: 80px; height: 80px; margin: 0 auto 1rem; background: linear-gradient(135deg, var(--success-green), #059669); border-radius: 50%; display: flex; align-items: center; justify-content: center; box-shadow: var(--shadow-lg);">
                <i class="fas fa-utensils" style="font-size: 2.5rem; color: white;"></i>
            </div>
        </div>
        <h1 class="title">Post Food Donation</h1>
        <h2 class="subtitle">Share your surplus food and help reduce waste</h2>
        <form id="postFoodForm">
            <label for="foodName"><i class="fas fa-hamburger"></i> Food Name</label>
            <input type="text" id="foodName" name="foodName" placeholder="e.g., Fresh vegetables, Cooked meals" required/>
            <label for="quantity"><i class="fas fa-users"></i> Quantity (Number of Meals)</label>
            <input type="number" id="quantity" name="quantity" min="1" placeholder="Enter number of meals" required/>
            <label for="expiry"><i class="fas fa-clock"></i> Expiry Time</label>
            <input type="datetime-local" id="expiry" name="expiry" required/>
            <label for="imageUrl"><i class="fas fa-image"></i> Image URL (Optional)</label>
            <input type="url" id="imageUrl" name="imageUrl" placeholder="https://example.com/image.jpg"/>
            <label for="location"><i class="fas fa-map-marker-alt"></i> Location</label>
            <input type="text" id="location" name="location" placeholder="Enter pickup location" required/>
            <button type="submit" class="btn-primary">
                <i class="fas fa-paper-plane"></i> Post Donation
            </button>
        </form>
    </div>
</div>
</body>
</html>
