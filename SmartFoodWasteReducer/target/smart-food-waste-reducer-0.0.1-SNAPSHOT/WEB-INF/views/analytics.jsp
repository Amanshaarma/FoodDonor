<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Analytics - Smart Food Waste Reducer</title>
    <link rel="stylesheet" href="/css/style.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
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
        <h2><i class="fas fa-heart"></i> Monthly Summary</h2>
        <div id="mealsSaved" class="metric" style="display: flex; align-items: center; gap: 1rem; margin-top: 1rem;">
            <i class="fas fa-utensils" style="font-size: 2rem; color: var(--accent-gold);"></i>
            <span>Loading...</span>
        </div>
        <p style="color: var(--text-secondary); margin-top: 1rem;">Every meal saved helps reduce food waste and feed those in need.</p>
    </section>
    
    <section class="panel">
        <h2><i class="fas fa-chart-line"></i> Yearly Analytics</h2>
        <p style="color: var(--text-secondary); margin-bottom: 1rem;">Meals saved per month this year</p>
        <div id="yearlyChart" style="margin-top: 1.5rem; min-height: 300px;">
            <p style="color: var(--text-secondary); text-align: center; padding: 2rem;">Loading yearly analytics...</p>
        </div>
    </section>

    <section class="panel">
        <h2><i class="fas fa-calendar-alt"></i> Filter by Month/Year</h2>
        <div style="display: flex; gap: 1rem; margin-top: 1rem; flex-wrap: wrap;">
            <div>
                <label for="yearFilter" style="display: block; margin-bottom: 0.5rem; color: var(--text-secondary);">Year:</label>
                <input type="number" id="yearFilter" min="2020" max="2030" value="<%= new java.util.Date().getYear() + 1900 %>" style="padding: 0.5rem; border-radius: 0.5rem; border: 2px solid var(--border-color); background: var(--bg-dark); color: var(--text-primary);">
            </div>
            <div>
                <label for="monthFilter" style="display: block; margin-bottom: 0.5rem; color: var(--text-secondary);">Month:</label>
                <select id="monthFilter" style="padding: 0.5rem; border-radius: 0.5rem; border: 2px solid var(--border-color); background: var(--bg-dark); color: var(--text-primary);">
                    <option value="">All Months</option>
                    <option value="1">January</option>
                    <option value="2">February</option>
                    <option value="3">March</option>
                    <option value="4">April</option>
                    <option value="5">May</option>
                    <option value="6">June</option>
                    <option value="7">July</option>
                    <option value="8">August</option>
                    <option value="9">September</option>
                    <option value="10">October</option>
                    <option value="11">November</option>
                    <option value="12">December</option>
                </select>
            </div>
            <div style="display: flex; align-items: end;">
                <button onclick="filterAnalytics()" class="btn-primary" style="margin-top: 0; width: auto; padding: 0.5rem 1.5rem;">
                    <i class="fas fa-filter"></i> Filter
                </button>
            </div>
        </div>
    </section>
</div>

<script>
function filterAnalytics() {
    const year = document.getElementById('yearFilter').value;
    const month = document.getElementById('monthFilter').value;
    
    const token = localStorage.getItem('token');
    if (!token) {
        window.location = '/login';
        return;
    }
    
    const headers = {'Authorization': 'Bearer ' + token};
    const params = new URLSearchParams();
    if (year) params.append('year', year);
    if (month) params.append('month', month);
    
    fetch(`/api/analytics/monthly?${params}`, {headers})
        .then(r => r.json())
        .then(data => {
            const monthNames = ['January', 'February', 'March', 'April', 'May', 'June', 
                              'July', 'August', 'September', 'October', 'November', 'December'];
            const monthName = month ? monthNames[parseInt(month) - 1] : 'All Months';
            const mealsSavedEl = document.getElementById('mealsSaved');
            if (mealsSavedEl) {
                mealsSavedEl.innerHTML = `<i class="fas fa-utensils" style="font-size: 2rem; color: var(--accent-gold);"></i><span>${data.mealsSaved || 0} meals saved in ${monthName} ${year || new Date().getFullYear()}</span>`;
            }
        })
        .catch(err => console.error('Error filtering analytics:', err));
    
    if (!month) {
        fetch(`/api/analytics/yearly?year=${year || new Date().getFullYear()}`, {headers})
            .then(r => r.json())
            .then(data => updateYearlyChart(data))
            .catch(err => console.error('Error loading yearly analytics:', err));
    }
}

function updateYearlyChart(yearlyData) {
    const yearlyChartEl = document.getElementById('yearlyChart');
    if (!yearlyChartEl || !yearlyData || !yearlyData.monthlyData) return;
    
    const monthNames = ['January', 'February', 'March', 'April', 'May', 'June', 
                      'July', 'August', 'September', 'October', 'November', 'December'];
    
    yearlyChartEl.innerHTML = '<canvas id="analyticsChart"></canvas>';
    const ctx = document.getElementById('analyticsChart');
    
    if (typeof Chart !== 'undefined') {
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: monthNames,
                datasets: [{
                    label: 'Meals Saved',
                    data: monthNames.map((_, i) => yearlyData.monthlyData[i + 1] || 0),
                    backgroundColor: 'rgba(251, 191, 36, 0.8)',
                    borderColor: 'var(--accent-gold)',
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            color: 'var(--text-secondary)'
                        },
                        grid: {
                            color: 'var(--border-color)'
                        }
                    },
                    x: {
                        ticks: {
                            color: 'var(--text-secondary)'
                        },
                        grid: {
                            color: 'var(--border-color)'
                        }
                    }
                },
                plugins: {
                    legend: {
                        labels: {
                            color: 'var(--text-primary)'
                        }
                    }
                }
            }
        });
    }
}
</script>
</body>
</html>
