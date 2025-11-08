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

<script>
document.addEventListener('DOMContentLoaded', async function() {
    var donationsEl = document.getElementById('donations');
    
    if (!donationsEl || !window.location.pathname.includes('/dashboard')) {
        return;
    }
    
    if (!checkAuth()) return;
    
    var user = await getCurrentUser();
    if (!user) return;

    loadDonations();

    async function loadDonations() {
        try {
            var response = await fetch('/api/food/my-donations', {headers: authHeader()});
            if (!response.ok) throw new Error('Failed to fetch donations');
            
            var foods = await response.json();
            
            if (foods.length === 0) {
                donationsEl.innerHTML = '<p style="color: var(--text-secondary); text-align: center; padding: 2rem;">No donations posted yet.</p>';
                return;
            }

            var foodWithRequests = await Promise.all(foods.map(async function(food) {
                var reqResponse = await fetch('/api/requests/food/' + food.id, {headers: authHeader()});
                var requests = reqResponse.ok ? await reqResponse.json() : [];
                return { food: food, requests: requests };
            }));

            donationsEl.innerHTML = foodWithRequests.map(function(item) {
                var f = item.food;
                var requests = item.requests;
                
                var statusBadge = '<span style="padding: 0.25rem 0.75rem; border-radius: 0.5rem; font-size: 0.85rem; background: ' + getStatusColor(f.status) + '; color: white;">' + f.status + '</span>';
                var expiryDate = new Date(f.expiryTime).toLocaleString();
                
                var receiversHtml = '';
                if (requests && requests.length > 0) {
                    receiversHtml = '<div style="margin-top: 1rem; padding-top: 1rem; border-top: 1px solid var(--border-color);"><strong style="color: var(--accent-gold);">Requests:</strong><div style="margin-top: 0.75rem; display: flex; flex-direction: column; gap: 0.75rem;">';
                    
                    requests.forEach(function(req) {
                        var receiverName = req.receiver && req.receiver.name ? req.receiver.name : (req.receiver && req.receiver.email ? req.receiver.email : 'Unknown');
                        var receiverEmail = req.receiver && req.receiver.email ? req.receiver.email : '';
                        var receiverLocation = req.receiver && req.receiver.location ? req.receiver.location : '';
                        
                        var requestStatusBadge = '<span style="padding: 0.15rem 0.5rem; border-radius: 0.25rem; font-size: 0.75rem; background: ' + getRequestStatusColor(req.status) + '; color: white;">' + req.status + '</span>';
                        
                        // 🔹 Dropdown for status change
						// 🔹 Dropdown for status change
						// 🔹 Dropdown for status change
						// 🔹 Two separate buttons (Approve / Decline)
						var actionButtons = `
						    <div class="receiver-buttons">
						        <button class="btn-approve" onclick="updateRequestStatus(${req.id}, 'APPROVED')">
						            <i class="fas fa-check"></i> Approve
						        </button>
						        <button class="btn-decline" onclick="updateRequestStatus(${req.id}, 'REJECTED')">
						            <i class="fas fa-times"></i> Decline
						        </button>
						    </div>
						`;

                    });
                    
                    receiversHtml += '</div></div>';
                } else {
                    receiversHtml = '<p style="margin-top: 1rem; padding-top: 1rem; border-top: 1px solid var(--border-color); color: var(--text-secondary); font-size: 0.9rem;">No requests yet.</p>';
                }

                return `
                <div class="panel" style="margin-bottom:1rem;">
                    <div style="display:flex;justify-content:space-between;align-items:start;margin-bottom:0.5rem;">
                        <h3 style="margin:0;color:var(--text-primary);">${f.foodName}</h3>
                        ${statusBadge}
                    </div>
                    <p style="margin:0.5rem 0;color:var(--text-secondary);"><i class="fas fa-utensils"></i> Quantity: ${f.quantity} meals</p>
                    <p style="margin:0.5rem 0;color:var(--text-secondary);"><i class="fas fa-map-marker-alt"></i> Location: ${f.location}</p>
                    <p style="margin:0.5rem 0;color:var(--text-secondary);"><i class="fas fa-clock"></i> Expiry: ${expiryDate}</p>
                    ${receiversHtml}
                </div>`;
            }).join('');
        } catch (error) {
            console.error('Error loading donations:', error);
            donationsEl.innerHTML = '<p style="color: var(--danger-red); text-align: center; padding: 2rem;">Error loading donations. Please try again.</p>';
        }
    }

    // 🔹 Handle dropdown selection (status update)
    window.updateRequestStatus = async function(requestId, newStatus) {
        if (!newStatus) return;
        var confirmAction = confirm('Are you sure you want to mark this request as ' + newStatus + '?');
        if (!confirmAction) return;

        try {
            var response = await fetch('/api/requests/' + requestId + '/status?status=' + newStatus, {
                method: 'PUT',
                headers: authHeader()
            });

            if (!response.ok) throw new Error('Failed to update request status');

            alert('Request ' + newStatus.toLowerCase() + ' successfully!');
            loadDonations();
        } catch (error) {
            console.error('Error updating request:', error);
            alert('Failed to update request. Please try again.');
        }
    };
});

function getStatusColor(status) {
    var colors = {
        'PENDING': 'var(--accent-gold)',
        'APPROVED': 'var(--primary-blue)',
        'PICKED': '#9333ea',
        'DELIVERED': 'var(--success-green)'
    };
    return colors[status] ? colors[status] : 'var(--text-secondary)';
}

function getRequestStatusColor(status) {
    var colors = {
        'REQUESTED': 'var(--accent-gold)',
        'APPROVED': 'var(--success-green)',
        'REJECTED': 'var(--danger-red)',
        'PICKED': '#9333ea',
        'DELIVERED': 'var(--success-green)'
    };
    return colors[status] ? colors[status] : 'var(--text-secondary)';
}
</script>
</body>
</html>