function validateLogin(e){
  e.preventDefault();
  const email=document.getElementById('email').value.trim();
  const password=document.getElementById('password').value.trim();
  if(!email||!password){alert('Email and password required');return false;}
  fetch('/api/auth/login',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({email,password})})
    .then(r=>r.json()).then(d=>{localStorage.setItem('token',d.token);window.location='/dashboard';})
    .catch(()=>alert('Login failed'));
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
  fetch('/api/auth/register',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({name,email,password,role,location})})
    .then(r=>r.json()).then(d=>{localStorage.setItem('token',d.token);window.location='/dashboard';})
    .catch(()=>alert('Registration failed'));
  return false;
}


