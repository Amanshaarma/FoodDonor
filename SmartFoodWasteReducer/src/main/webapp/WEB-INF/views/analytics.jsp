<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Calendar" %>
<%
    int currentYear = Calendar.getInstance().get(Calendar.YEAR);
%>
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


</div>

<script>
function updateYearlyChart(yearlyData) {
    var yearlyChartEl = document.getElementById('yearlyChart');
    if (!yearlyChartEl || !yearlyData || !yearlyData.monthlyData) return;
    
    var monthNames = ['January', 'February', 'March', 'April', 'May', 'June', 
                      'July', 'August', 'September', 'October', 'November', 'December'];
    
    yearlyChartEl.innerHTML = '<canvas id="analyticsChart"></canvas>';
    var ctx = document.getElementById('analyticsChart');
    
    if (typeof Chart !== 'undefined') {
        var monthlyDataArray = [];
        for (var i = 0; i < monthNames.length; i++) {
            var monthValue = yearlyData.monthlyData[i + 1];
            monthlyDataArray.push(monthValue ? monthValue : 0);
        }
        
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: monthNames,
                datasets: [{
                    label: 'Meals Saved',
                    data: monthlyDataArray,
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