function authHeader(){const t=localStorage.getItem('token');return t?{'Authorization':'Bearer '+t}:{}}

document.addEventListener('DOMContentLoaded',()=>{
  const donationsEl=document.getElementById('donations');
  if(donationsEl){
    const city=prompt('Enter your city/prefix for nearby matches','');
    if(city){
      fetch('/api/food/nearby?locationPrefix='+encodeURIComponent(city),{headers:authHeader()})
        .then(r=>r.json()).then(items=>{
          donationsEl.innerHTML = items.map(f=>`<div class="panel"><strong>${f.foodName}</strong> · Qty ${f.quantity} · ${f.location}
            <div><button onclick="requestFood(${f.id})" class='btn-primary'>Request</button></div></div>`).join('');
        });
    }
  }

  const postForm=document.getElementById('postFoodForm');
  if(postForm){
    postForm.addEventListener('submit',e=>{
      e.preventDefault();
      const donorId=prompt('Enter your userId');
      const foodName=document.getElementById('foodName').value.trim();
      const quantity=document.getElementById('quantity').value;
      const expiry=document.getElementById('expiry').value;
      const imageUrl=document.getElementById('imageUrl').value.trim();
      const location=document.getElementById('location').value.trim();
      const body=new URLSearchParams();
      body.set('donorId', donorId);
      body.set('foodName', foodName);
      body.set('quantity', quantity);
      body.set('expiryTime', new Date(expiry).toISOString());
      if(imageUrl) body.set('imageUrl', imageUrl);
      body.set('location', location);
      fetch('/api/food/post',{method:'POST',headers:Object.assign({'Content-Type':'application/x-www-form-urlencoded'},authHeader()),body})
        .then(r=>r.json()).then(()=>{alert('Posted!');window.location='/dashboard';})
        .catch(()=>alert('Post failed'));
    });
  }
});

function requestFood(id){
  const receiverId=prompt('Enter your userId');
  fetch('/api/requests/create?foodId='+id+'&receiverId='+receiverId,{method:'POST',headers:authHeader()})
    .then(r=>r.json()).then(()=>alert('Requested!'));
}


