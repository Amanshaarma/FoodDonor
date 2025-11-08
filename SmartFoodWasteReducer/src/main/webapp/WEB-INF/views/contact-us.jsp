<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us - Smart Food Waste Reducer</title>
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
                <h1 class="title">Contact Us</h1>
                <h2 class="subtitle">We'd love to hear from you</h2>
            </div>

            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 1.5rem; margin-bottom: 2rem;">
                <div class="panel" style="text-align: center;">
                    <i class="fas fa-envelope" style="font-size: 2.5rem; color: var(--accent-gold); margin-bottom: 1rem;"></i>
                    <h2>Email</h2>
                    <p style="color: var(--text-secondary); margin-top: 0.5rem;">
                        info@smartfoodwastereducer.com
                    </p>
                </div>
                <div class="panel" style="text-align: center;">
                    <i class="fas fa-phone" style="font-size: 2.5rem; color: var(--accent-gold); margin-bottom: 1rem;"></i>
                    <h2>Phone</h2>
                    <p style="color: var(--text-secondary); margin-top: 0.5rem;">
                        +1 (555) 123-4567
                    </p>
                </div>
                <div class="panel" style="text-align: center;">
                    <i class="fas fa-map-marker-alt" style="font-size: 2.5rem; color: var(--accent-gold); margin-bottom: 1rem;"></i>
                    <h2>Address</h2>
                    <p style="color: var(--text-secondary); margin-top: 0.5rem;">
                        123 Food Waste St<br>
                        Community City, CC 12345
                    </p>
                </div>
            </div>

            <div class="panel">
                <h2><i class="fas fa-paper-plane" style="color: var(--accent-gold); margin-right: 0.5rem;"></i>Send us a Message</h2>
                <form id="contactForm" style="margin-top: 1.5rem;">
                    <label for="name"><i class="fas fa-user"></i> Your Name</label>
                    <input type="text" id="name" name="name" placeholder="Enter your name" required/>

                    <label for="email"><i class="fas fa-envelope"></i> Your Email</label>
                    <input type="email" id="email" name="email" placeholder="Enter your email" required/>

                    <label for="subject"><i class="fas fa-tag"></i> Subject</label>
                    <input type="text" id="subject" name="subject" placeholder="Enter subject" required/>

                    <label for="message"><i class="fas fa-comment"></i> Message</label>
                    <textarea id="message" name="message" rows="5" placeholder="Enter your message" required style="width: 100%; padding: 0.875rem 1rem; border-radius: 0.625rem; border: 2px solid var(--border-color); background: var(--bg-dark); color: var(--text-primary); font-family: 'Poppins', sans-serif; font-size: 0.95rem; transition: all 0.3s ease; resize: vertical;"></textarea>

                    <button type="submit" class="btn-primary">
                        <i class="fas fa-paper-plane"></i> Send Message
                    </button>
                </form>
            </div>

            <div class="panel" style="margin-top: 1.5rem; text-align: center;">
                <h2><i class="fas fa-clock" style="color: var(--accent-gold); margin-right: 0.5rem;"></i>Office Hours</h2>
                <p style="color: var(--text-secondary); margin-top: 1rem; line-height: 1.8;">
                    Monday - Friday: 9:00 AM - 6:00 PM<br>
                    Saturday: 10:00 AM - 4:00 PM<br>
                    Sunday: Closed
                </p>
            </div>
        </div>
    </div>

    <script>
        document.getElementById('contactForm').addEventListener('submit', function(e) {
            e.preventDefault();
            alert('Thank you for your message! We will get back to you soon.');
            this.reset();
        });
    </script>
</body>
</html>




