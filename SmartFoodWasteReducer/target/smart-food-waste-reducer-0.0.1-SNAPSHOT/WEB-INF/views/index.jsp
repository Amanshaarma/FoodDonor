<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home - Smart Food Waste Reducer</title>
    <link rel="stylesheet" href="/css/style.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
</head>
<body class="royal-bg">
    <header class="header">
        <h1><i class="fas fa-leaf"></i> Smart Food Waste Reducer</h1>
        <nav>
            <a href="/"><i class="fas fa-home"></i> Home</a>
            <a href="/login"><i class="fas fa-sign-in-alt"></i> Login</a>
            <a href="/register"><i class="fas fa-user-plus"></i> Register</a>
            <a href="/about"><i class="fas fa-info-circle"></i> About</a>
            <a href="/contact-us"><i class="fas fa-envelope"></i> Contact Us</a>
        </nav>
    </header>

    <div class="container">
        <div class="card" style="max-width: 900px;">
            <div style="text-align: center; margin-bottom: 2rem;">
                <div style="width: 120px; height: 120px; margin: 0 auto 2rem; background: linear-gradient(135deg, var(--accent-gold), #f59e0b); border-radius: 50%; display: flex; align-items: center; justify-content: center; box-shadow: var(--shadow-lg);">
                    <i class="fas fa-leaf" style="font-size: 4rem; color: white;"></i>
                </div>
                <h1 class="title">Welcome to Smart Food Waste Reducer</h1>
                <h2 class="subtitle">Connecting food donors with receivers to reduce waste and help those in need</h2>
            </div>

            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 1.5rem; margin-top: 2rem;">
                <div class="panel">
                    <h2><i class="fas fa-users" style="color: var(--accent-gold); margin-right: 0.5rem;"></i>For Donors</h2>
                    <p style="color: var(--text-secondary); line-height: 1.8;">
                        Share your surplus food with those in need. Reduce waste while making a positive impact in your community.
                    </p>
                </div>
                <div class="panel">
                    <h2><i class="fas fa-hand-holding-heart" style="color: var(--accent-gold); margin-right: 0.5rem;"></i>For Receivers</h2>
                    <p style="color: var(--text-secondary); line-height: 1.8;">
                        Find fresh food donations in your area. Connect with donors and help feed those who need it most.
                    </p>
                </div>
                <div class="panel">
                    <h2><i class="fas fa-chart-line" style="color: var(--accent-gold); margin-right: 0.5rem;"></i>Track Impact</h2>
                    <p style="color: var(--text-secondary); line-height: 1.8;">
                        Monitor your contributions and see the positive impact you're making in reducing food waste.
                    </p>
                </div>
            </div>

            <div style="text-align: center; margin-top: 3rem;">
                <h2 style="color: var(--text-primary); margin-bottom: 1.5rem; font-family: 'Playfair Display', serif;">Get Started Today</h2>
                <div style="display: flex; gap: 1rem; justify-content: center; flex-wrap: wrap;">
                    <a href="/register" class="btn-primary" style="text-decoration: none; display: inline-block; width: auto; padding: 0.875rem 2rem;">
                        <i class="fas fa-user-plus"></i> Create Account
                    </a>
                    <a href="/login" class="btn-secondary" style="text-decoration: none; display: inline-block; width: auto; padding: 0.875rem 2rem;">
                        <i class="fas fa-sign-in-alt"></i> Login
                    </a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>

