// Toggle password visibility
function togglePassword(inputId, iconId) {
  const input = document.getElementById(inputId);
  const icon = document.getElementById(iconId);
  
  if (input.type === 'password') {
    input.type = 'text';
    icon.classList.remove('fa-eye');
    icon.classList.add('fa-eye-slash');
  } else {
    input.type = 'password';
    icon.classList.remove('fa-eye-slash');
    icon.classList.add('fa-eye');
  }
}

// Validate login form and enable/disable submit button
function validateLoginForm() {
  const email = document.getElementById('email').value.trim();
  const password = document.getElementById('password').value.trim();
  const role = document.getElementById('role').value;
  const submitBtn = document.getElementById('loginSubmit');
  
  if (email && password && password.length > 0 && role) {
    submitBtn.disabled = false;
  } else {
    submitBtn.disabled = true;
  }
}

// Validate register form and enable/disable submit button
function validateRegisterForm() {
  const name = document.getElementById('name').value.trim();
  const email = document.getElementById('email').value.trim();
  const password = document.getElementById('password').value.trim();
  const role = document.getElementById('role').value;
  const location = document.getElementById('location').value.trim();
  const submitBtn = document.getElementById('registerSubmit');
  
  if (name && email && password && password.length >= 6 && role && location) {
    submitBtn.disabled = false;
  } else {
    submitBtn.disabled = true;
  }
}

// Initialize form validation on page load
document.addEventListener('DOMContentLoaded', function() {
  // Login form validation
  const loginForm = document.getElementById('loginForm');
  if (loginForm) {
    const emailInput = document.getElementById('email');
    const passwordInput = document.getElementById('password');
    const roleSelect = document.getElementById('role');
    
    if (emailInput && passwordInput && roleSelect) {
      emailInput.addEventListener('input', validateLoginForm);
      emailInput.addEventListener('blur', validateLoginForm);
      passwordInput.addEventListener('input', validateLoginForm);
      passwordInput.addEventListener('blur', validateLoginForm);
      roleSelect.addEventListener('change', validateLoginForm);
      validateLoginForm(); // Initial check
    }
  }
  
  // Register form validation
  const registerForm = document.getElementById('registerForm');
  if (registerForm) {
    const nameInput = document.getElementById('name');
    const emailInput = document.getElementById('email');
    const passwordInput = document.getElementById('password');
    const roleSelect = document.getElementById('role');
    const locationInput = document.getElementById('location');
    
    if (nameInput && emailInput && passwordInput && roleSelect && locationInput) {
      nameInput.addEventListener('input', validateRegisterForm);
      nameInput.addEventListener('blur', validateRegisterForm);
      emailInput.addEventListener('input', validateRegisterForm);
      emailInput.addEventListener('blur', validateRegisterForm);
      passwordInput.addEventListener('input', validateRegisterForm);
      passwordInput.addEventListener('blur', validateRegisterForm);
      roleSelect.addEventListener('change', validateRegisterForm);
      locationInput.addEventListener('input', validateRegisterForm);
      locationInput.addEventListener('blur', validateRegisterForm);
      validateRegisterForm(); // Initial check
    }
  }
});

function validateLogin(e){
  e.preventDefault();
  const email=document.getElementById('email').value.trim();
  const password=document.getElementById('password').value.trim();
  const role=document.getElementById('role').value;
  
  console.log('Login attempt:', {email, role: role, passwordLength: password.length});
  
  if(!email||!password||!role){
    alert('Email, password, and role are required');
    return false;
  }
  
  const loginData = {email, password, role};
  console.log('Sending login request:', {...loginData, password: '***'});
  
  fetch('/api/auth/login',{
    method:'POST',
    headers:{'Content-Type':'application/json'},
    body:JSON.stringify(loginData)
  })
    .then(async r => {
      console.log('Response status:', r.status, r.statusText);
      const contentType = r.headers.get('content-type');
      console.log('Response content-type:', contentType);
      
      if (!r.ok) {
        if (contentType && contentType.includes('application/json')) {
          const err = await r.json();
          console.error('Error response:', err);
          throw new Error(err.message || 'Login failed');
        } else {
          const text = await r.text();
          console.error('Non-JSON error response:', text);
          throw new Error(text || 'Login failed - Invalid credentials or role');
        }
      }
      return r.json();
    })
    .then(d => {
      console.log('Login successful, response:', {...d, token: d.token ? '***' : 'missing'});
      if(d.token) {
        localStorage.setItem('token',d.token);
        console.log('Token stored, redirecting based on role:', role);
        
        // Role-based redirect: DONOR -> dashboard, RECEIVER -> all-food
        if(role === 'DONOR') {
          window.location='/dashboard';
        } else if(role === 'RECEIVER') {
          window.location='/all-food';
        } else {
          // Fallback to dashboard for any other role
          window.location='/dashboard';
        }
      } else {
        console.error('No token in response:', d);
        alert('Login failed - No token received');
      }
    })
    .catch(err => {
      console.error('Login error:', err);
      console.error('Error details:', err.message, err.stack);
      alert(err.message || 'Login failed - Invalid credentials or role');
    });
  return false;
}

function validateRegister(e){
  e.preventDefault();
  const name=document.getElementById('name').value.trim();
  const email=document.getElementById('email').value.trim();
  const password=document.getElementById('password').value.trim();
  const role=document.getElementById('role').value;
  const location=document.getElementById('location').value.trim();
  if(password.length<6){alert('Password must be at least 6 characters');return false;}
  if(!name||!email||!password||!role||!location){alert('All fields are required');return false;}
  fetch('/api/auth/register',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({name,email,password,role,location})})
    .then(r=>r.json()).then(d=>{
      localStorage.setItem('token',d.token);
      
      // Role-based redirect after registration: DONOR -> dashboard, RECEIVER -> all-food
      if(role === 'DONOR') {
        window.location='/dashboard';
      } else if(role === 'RECEIVER') {
        window.location='/all-food';
      } else {
        // Fallback to dashboard for any other role
        window.location='/dashboard';
      }
    })
    .catch(()=>alert('Registration failed'));
  return false;
}