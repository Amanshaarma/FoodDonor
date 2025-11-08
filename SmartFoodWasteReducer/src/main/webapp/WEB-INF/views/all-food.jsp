<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Available Food - Smart Food Waste Reducer</title>
    <link rel="stylesheet" href="/css/style.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <script src="/js/app.js" defer></script>
</head>
<body class="royal-bg">
<header class="header">
    <h1><i class="fas fa-leaf"></i> Smart Food Waste Reducer</h1>
    <nav>
        <a href="/all-food"><i class="fas fa-home"></i> Available Food</a>
        <a href="/login" onclick="localStorage.removeItem('token')"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </nav>
</header>

<div class="container">
    <section class="panel">
        <h2><i class="fas fa-utensils"></i> Available Food Donations</h2>
        <p style="color: var(--text-secondary); margin-bottom: 1rem;">Browse and request food donations from donors in your area</p>
        
        <!-- Search Bar -->
        <div style="margin-bottom: 1.5rem;">
            <input type="text" id="searchBox" placeholder="🔍 Search by food name or location..." 
                   style="width: 100%; padding: 0.875rem 1rem; border-radius: 0.625rem; border: 2px solid var(--border-color); background: var(--bg-dark); color: var(--text-primary); font-family: 'Poppins', sans-serif; font-size: 0.95rem;">
        </div>

        <!-- Food List -->
        <div id="foodList" style="display: grid; gap: 1rem; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); min-height: 200px;">
            <p style="color: var(--text-secondary); text-align: center; padding: 2rem; grid-column: 1/-1;">Loading available food donations...</p>
        </div>
    </section>
</div>

<script>
document.addEventListener('DOMContentLoaded', async function() {
    const list = document.getElementById('foodList');
    const searchBox = document.getElementById('searchBox');
    
    // Check authentication
    if (!checkAuth()) return;
    
    const user = await getCurrentUser();
    if (!user) return;

    // Redirect donors to dashboard
    if (user.role === 'DONOR') {
        alert('Access denied: Donors cannot access this page. Redirecting to dashboard...');
        window.location = '/dashboard';
        return;
    }

    let foods = [];

    async function loadFoods() {
        try {
            const res = await fetch('/api/food/all', { headers: authHeader() });
            if (!res.ok) throw new Error('Failed to load food posts');
            const data = await res.json();

            // Filter out user's own posts (if any) and only show PENDING status
            foods = data.filter(function(f) { 
                return f.donorId !== user.id && f.status === 'PENDING'; 
				
            });
            renderFoods(foods);
        } catch (e) {
            console.error(e);
            list.innerHTML = '<p style="color: var(--danger-red); text-align: center; padding: 2rem; grid-column: 1/-1;">Error loading food posts. Please try again.</p>';
        }
    }

    function renderFoods(data) {
        if (data.length === 0) {
            list.innerHTML = '<p style="text-align: center; color: var(--text-secondary); padding: 2rem; grid-column: 1/-1;">No available food donations found.</p>';
            return;
        }

        list.innerHTML = data.map(function(f) {
            const expiryDate = new Date(f.expiryTime);
            const now = new Date();
            const hoursUntilExpiry = Math.floor((expiryDate - now) / (1000 * 60 * 60));
            const isExpiringSoon = hoursUntilExpiry < 24 && hoursUntilExpiry > 0;
            const isExpired = expiryDate < now;
            let expiryBadge = '';
            if (isExpired) {
                expiryBadge = '<span style="padding: 0.25rem 0.75rem; border-radius: 0.5rem; font-size: 0.85rem; background: var(--danger-red); color: white; margin-left: 0.5rem;">Expired</span>';
            } else if (isExpiringSoon) {
                expiryBadge = '<span style="padding: 0.25rem 0.75rem; border-radius: 0.5rem; font-size: 0.85rem; background: var(--accent-gold); color: white; margin-left: 0.5rem;">Expiring Soon</span>';
            }

            let imageHtml = '';
            if (f.imageUrl) {
                imageHtml = '<div style="width: 100%; height: 180px; background: url(\'' + f.imageUrl + '\') center/cover no-repeat; border-radius: 0.5rem; margin-bottom: 1rem;"></div>';
            } else {
                imageHtml = '<div style="width: 100%; height: 180px; background: linear-gradient(135deg, var(--accent-gold), #f59e0b); border-radius: 0.5rem; margin-bottom: 1rem; display: flex; align-items: center; justify-content: center;"><i class="fas fa-utensils" style="font-size: 3rem; color: white; opacity: 0.5;"></i></div>';
            }

            let buttonHtml = '';
            if (!isExpired) {
                buttonHtml = '<button onclick="confirmRequest(' + f.id + ')" class="btn-primary" style="margin-top: 1rem; width: 100%; padding: 0.75rem 1rem;"><i class="fas fa-hand-holding-heart"></i> Request Food</button>';
            } else {
                buttonHtml = '<button disabled class="btn-primary" style="margin-top: 1rem; width: 100%; padding: 0.75rem 1rem; opacity: 0.5; cursor: not-allowed;"><i class="fas fa-times-circle"></i> Expired</button>';
            }

            const panelOpacity = isExpired ? 'opacity: 0.6;' : '';

            return '<div class="panel" style="padding: 1.5rem; transition: all 0.3s ease; ' + panelOpacity + '">' +
                imageHtml +
                '<div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 0.75rem;">' +
                    '<h3 style="margin: 0; color: var(--text-primary); font-size: 1.25rem;">' + f.foodName + '</h3>' +
                    expiryBadge +
                '</div>' +
                '<div style="margin: 0.5rem 0; color: var(--text-secondary);">' +
                    '<p style="margin: 0.5rem 0;"><i class="fas fa-users" style="color: var(--accent-gold); margin-right: 0.5rem;"></i><strong>Quantity:</strong> ' + f.quantity + ' meals</p>' +
                    '<p style="margin: 0.5rem 0;"><i class="fas fa-map-marker-alt" style="color: var(--accent-gold); margin-right: 0.5rem;"></i><strong>Location:</strong> ' + f.location + '</p>' +
                    '<p style="margin: 0.5rem 0;"><i class="fas fa-clock" style="color: var(--accent-gold); margin-right: 0.5rem;"></i><strong>Expiry:</strong> ' + expiryDate.toLocaleString() + '</p>' +
                '</div>' +
                buttonHtml +
            '</div>';
        }).join('');
    }

    // Search Filter
    searchBox.addEventListener('input', function(e) {
        const term = e.target.value.toLowerCase();
        const filtered = foods.filter(function(f) {
            return f.foodName.toLowerCase().includes(term) || 
                   f.location.toLowerCase().includes(term);
        });
        renderFoods(filtered);
    });

    // Confirm before requesting food
    window.confirmRequest = async function(foodId) {
        if (confirm('Are you sure you want to request this food donation?')) {
            try {
                const res = await fetch('/api/requests/create?foodId=' + foodId + '&receiverId=' + user.id, {
                    method: 'POST',
                    headers: authHeader()
                });

                if (!res.ok) {
                    const error = await res.text();
                    throw new Error(error || 'Failed to request food');
                }

                alert('Food request submitted successfully! The donor will review your request.');
                loadFoods(); // Reload the list
            } catch (error) {
                console.error('Error requesting food:', error);
                alert('Failed to request food: ' + error.message);
            }
        }
    }

    loadFoods();
});
</script>
</body>
</html>