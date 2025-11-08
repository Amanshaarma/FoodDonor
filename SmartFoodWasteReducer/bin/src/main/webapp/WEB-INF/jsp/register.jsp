<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register - Smart Food Waste Reducer</title>
    <link rel="stylesheet" href="/css/style.css"/>
    <script src="/js/validate.js" defer></script>
</head>
<body class="royal-bg">
<div class="card">
    <h1 class="title">Create Account</h1>
    <form id="registerForm" onsubmit="return validateRegister(event)">
        <label>Name</label>
        <input type="text" id="name" required/>
        <label>Email</label>
        <input type="email" id="email" required/>
        <label>Password</label>
        <input type="password" id="password" minlength="6" required/>
        <label>Role</label>
        <select id="role" required>
            <option value="DONOR">Donor</option>
            <option value="RECEIVER">Receiver</option>
            <option value="VOLUNTEER">Volunteer</option>
        </select>
        <label>City / Location</label>
        <input type="text" id="location" required/>
        <button type="submit" class="btn-primary">Register</button>
    </form>
    <p class="muted">Have an account? <a href="/login">Login</a></p>
    </div>
</body>
</html>


