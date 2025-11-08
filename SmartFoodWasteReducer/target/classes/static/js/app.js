function authHeader(){const t=localStorage.getItem('token');return t?{'Authorization':'Bearer '+t}:{}}

// Check authentication and redirect to login if not authenticated
function checkAuth() {
  const token = localStorage.getItem('token');
  if (!token) {
    window.location = '/login';
    return false;
  }
  return true;
}

// Get current user info
async function getCurrentUser() {
  try {
    const response = await fetch('/api/auth/me', {headers: authHeader()});
    if (!response.ok) {
      localStorage.removeItem('token');
      window.location = '/login';
      return null;
    }
    return await response.json();
  } catch (error) {
    console.error('Error fetching user:', error);
    localStorage.removeItem('token');
    window.location = '/login';
    return null;
  }
}

document.addEventListener('DOMContentLoaded', async () => {
  // Check auth for protected pages
  if (window.location.pathname.includes('/dashboard') || 
      window.location.pathname.includes('/postFood') || 
      window.location.pathname.includes('/analytics')) {
    if (!checkAuth()) return;
  }

  // Dashboard: Load user's donations with receiver details
  const donationsEl = document.getElementById('donations');
  if (donationsEl && window.location.pathname.includes('/dashboard')) {
    try {
      const user = await getCurrentUser();
      if (!user) return;

      const response = await fetch('/api/food/my-donations', {headers: authHeader()});
      if (!response.ok) throw new Error('Failed to fetch donations');
      
      const foods = await response.json();
      
      if (foods.length === 0) {
        donationsEl.innerHTML = '<p style="color: var(--text-secondary); text-align: center; padding: 2rem;">No donations posted yet.</p>';
        return;
      }

      // Fetch receiver details for each food
      const foodWithRequests = await Promise.all(foods.map(async (food) => {
        const reqResponse = await fetch(`/api/requests/food/${food.id}`, {headers: authHeader()});
        const requests = reqResponse.ok ? await reqResponse.json() : [];
        return { ...food, requests };
      }));

      donationsEl.innerHTML = foodWithRequests.map(f => {
        const statusBadge = `<span style="padding: 0.25rem 0.75rem; border-radius: 0.5rem; font-size: 0.85rem; background: ${getStatusColor(f.status)}; color: white;">${f.status}</span>`;
        const expiryDate = new Date(f.expiryTime).toLocaleString();
        
        let receiversHtml = '';
        if (f.requests && f.requests.length > 0) {
          receiversHtml = '<div style="margin-top: 1rem; padding-top: 1rem; border-top: 1px solid var(--border-color);"><strong style="color: var(--accent-gold);">Receivers:</strong><ul style="margin-top: 0.5rem; padding-left: 1.5rem;">';
          f.requests.forEach(req => {
            const receiverStatus = `<span style="padding: 0.15rem 0.5rem; border-radius: 0.25rem; font-size: 0.75rem; background: ${getRequestStatusColor(req.status)}; color: white; margin-left: 0.5rem;">${req.status}</span>`;
            receiversHtml += `<li style="margin: 0.5rem 0; color: var(--text-secondary);">${req.receiver.name || req.receiver.email} ${receiverStatus}</li>`;
          });
          receiversHtml += '</ul></div>';
        } else {
          receiversHtml = '<p style="margin-top: 1rem; color: var(--text-secondary); font-size: 0.9rem;">No requests yet.</p>';
        }

        return `<div class="panel" style="margin-bottom: 1rem;">
          <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 0.5rem;">
            <h3 style="margin: 0; color: var(--text-primary);">${f.foodName}</h3>
            ${statusBadge}
          </div>
          <p style="margin: 0.5rem 0; color: var(--text-secondary);"><i class="fas fa-utensils"></i> Quantity: ${f.quantity} meals</p>
          <p style="margin: 0.5rem 0; color: var(--text-secondary);"><i class="fas fa-map-marker-alt"></i> Location: ${f.location}</p>
          <p style="margin: 0.5rem 0; color: var(--text-secondary);"><i class="fas fa-clock"></i> Expiry: ${expiryDate}</p>
          ${receiversHtml}
        </div>`;
      }).join('');
    } catch (error) {
      console.error('Error loading donations:', error);
      donationsEl.innerHTML = '<p style="color: var(--danger-red); text-align: center; padding: 2rem;">Error loading donations. Please try again.</p>';
    }
  }

  // Post Food Form
  const postForm = document.getElementById('postFoodForm');
  if (postForm) {
    postForm.addEventListener('submit', async e => {
      e.preventDefault();
      
      const user = await getCurrentUser();
      if (!user) return;

      const foodName = document.getElementById('foodName').value.trim();
      const quantity = document.getElementById('quantity').value;
      const expiry = document.getElementById('expiry').value;
      const imageUrl = document.getElementById('imageUrl').value.trim();
      const location = document.getElementById('location').value.trim();
      
      const body = new URLSearchParams();
      body.set('foodName', foodName);
      body.set('quantity', quantity);
      body.set('expiryTime', new Date(expiry).toISOString());
      if (imageUrl) body.set('imageUrl', imageUrl);
      body.set('location', location);
      
      try {
        const response = await fetch('/api/food/post', {
          method: 'POST',
          headers: Object.assign({'Content-Type': 'application/x-www-form-urlencoded'}, authHeader()),
          body
        });
        
        if (!response.ok) throw new Error('Failed to post food');
        
        alert('Food posted successfully!');
        window.location = '/dashboard';
      } catch (error) {
        console.error('Error posting food:', error);
        alert('Failed to post food. Please try again.');
      }
    });
  }

  // Analytics: Load monthly/yearly charts
  const analyticsEl = document.getElementById('analytics');
  if (analyticsEl || window.location.pathname.includes('/analytics')) {
    loadAnalytics();
  }
});

function getStatusColor(status) {
  const colors = {
    'PENDING': 'var(--accent-gold)',
    'APPROVED': 'var(--primary-blue)',
    'PICKED': '#9333ea',
    'DELIVERED': 'var(--success-green)'
  };
  return colors[status] || 'var(--text-secondary)';
}

function getRequestStatusColor(status) {
  const colors = {
    'REQUESTED': 'var(--accent-gold)',
    'APPROVED': 'var(--primary-blue)',
    'REJECTED': 'var(--danger-red)',
    'PICKED': '#9333ea',
    'DELIVERED': 'var(--success-green)'
  };
  return colors[status] || 'var(--text-secondary)';
}

async function loadAnalytics() {
  const currentYear = new Date().getFullYear();
  const currentMonth = new Date().getMonth() + 1;

  try {
    // Load monthly analytics
    const monthlyRes = await fetch(`/api/analytics/monthly?year=${currentYear}&month=${currentMonth}`, {headers: authHeader()});
    const monthlyData = monthlyRes.ok ? await monthlyRes.json() : null;

    // Load yearly analytics
    const yearlyRes = await fetch(`/api/analytics/yearly?year=${currentYear}`, {headers: authHeader()});
    const yearlyData = yearlyRes.ok ? await yearlyRes.json() : null;

    // Update UI
    updateAnalyticsUI(monthlyData, yearlyData, currentYear, currentMonth);
  } catch (error) {
    console.error('Error loading analytics:', error);
  }
}

function updateAnalyticsUI(monthlyData, yearlyData, year, month) {
  const monthNames = ['January', 'February', 'March', 'April', 'May', 'June', 
                      'July', 'August', 'September', 'October', 'November', 'December'];
  
  // Update monthly section
  const mealsSavedEl = document.getElementById('mealsSaved');
  if (mealsSavedEl && monthlyData) {
    mealsSavedEl.innerHTML = `<i class="fas fa-utensils" style="font-size: 2rem; color: var(--accent-gold);"></i><span>${monthlyData.mealsSaved || 0} meals saved in ${monthNames[month - 1]} ${year}</span>`;
  }

  // Update yearly chart section
  const yearlyChartEl = document.getElementById('yearlyChart');
  if (yearlyChartEl && yearlyData && yearlyData.monthlyData) {
    const ctx = document.createElement('canvas');
    ctx.id = 'analyticsChart';
    yearlyChartEl.innerHTML = '';
    yearlyChartEl.appendChild(ctx);

    // Load Chart.js if available
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
    } else {
      // Fallback if Chart.js not loaded - show data in table
      const table = document.createElement('table');
      table.style.width = '100%';
      table.style.marginTop = '1rem';
      table.style.color = 'var(--text-primary)';
      table.innerHTML = '<thead><tr><th>Month</th><th>Meals Saved</th></tr></thead><tbody>' +
        monthNames.map((name, i) => 
          `<tr><td>${name}</td><td>${yearlyData.monthlyData[i + 1] || 0}</td></tr>`
        ).join('') + '</tbody>';
      yearlyChartEl.appendChild(table);
    }
  }
}

// Legacy function for requesting food (kept for compatibility)
function requestFood(id) {
  const receiverId = prompt('Enter your userId');
  fetch('/api/requests/create?foodId=' + id + '&receiverId=' + receiverId, {
    method: 'POST',
    headers: authHeader()
  })
    .then(r => r.json())
    .then(() => alert('Requested!'))
    .catch(() => alert('Request failed'));
}
