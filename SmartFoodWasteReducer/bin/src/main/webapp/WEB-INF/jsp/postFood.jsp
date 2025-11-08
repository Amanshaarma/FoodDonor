<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Post Food - Smart Food Waste Reducer</title>
    <link rel="stylesheet" href="/css/style.css"/>
    <script src="/js/app.js" defer></script>
</head>
<body class="royal-bg">
<div class="card">
    <h1 class="title">Post Food</h1>
    <form id="postFoodForm">
        <label>Food Name</label>
        <input type="text" id="foodName" required/>
        <label>Quantity</label>
        <input type="number" id="quantity" min="1" required/>
        <label>Expiry Time</label>
        <input type="datetime-local" id="expiry" required/>
        <label>Image URL (optional)</label>
        <input type="url" id="imageUrl"/>
        <label>Location</label>
        <input type="text" id="location" required/>
        <button type="submit" class="btn-primary">Post</button>
    </form>
</div>
</body>
</html>


