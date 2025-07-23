/* Run Batch: Executes batch file or opens URL in new tab based on action */
async function runBatch(batchName, url = null, action = 'fetch') {
  const button = event.currentTarget;
  button.disabled = true;
  //button.textContent = 'Processing...';

  try {
    if (action === 'redirect' && url) {
      // Open the provided URL in a new tab
      window.open(url, '_blank');
      // Reset button immediately since no fetch is happening
      button.disabled = false;
      //button.textContent = `Redirected- ${url.replace('batch', '')}`;
    } else {
      // Default to fetching from localhost if no URL or action is 'fetch'
      const fetchUrl = url || `http://localhost:5010/run-batch?name=${batchName}`;
      const response = await fetch(fetchUrl, {
        method: 'POST'
      });
      const data = await response.text();

      // Show success message with custom alert
      const alert = document.createElement('div');
      alert.className = 'alert alert-success alert-dismissible fade show';
      alert.style.cssText = 'position: fixed; top: 20px; left: 50%; transform: translateX(-50%); z-index: 2000;';
      alert.innerHTML = `
        Batch ${batchName} executed: ${data}
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
          <span aria-hidden="true">×</span>
        </button>
      `;
      document.body.prepend(alert);
      setTimeout(() => $(alert).alert('close'), 5000);

      // Reset button with animation
      button.disabled = false;
      //button.textContent = `${batchName.replace('batch', '')} Running..`;
      button.classList.add('btn-success');
      setTimeout(() => button.classList.remove('btn-success'), 2000);
    }
  } catch (error) {
    // Show error message with custom alert (only for fetch action)
    const alert = document.createElement('div');
    alert.className = 'alert alert-danger alert-dismissible fade show';
    alert.style.cssText = 'position: fixed; top: 20px; left: 50%; transform: translateX(-50%); z-index: 2000;';
    alert.innerHTML = `
      Error: ${error}
      <button type="button" class="close" data-dismiss="alert" aria-label="Close">
        <span aria-hidden="true">×</span>
      </button>
    `;
    document.body.appendChild(alert);
    setTimeout(() => $(alert).alert('close'), 5000);

    button.disabled = false;
    button.textContent = `Run Batch ${batchName.replace('batch', '')}`;
  }
}     

// Function to start a Windows service
async function startService(serviceName) {
  try {
    const response = await fetch('http://localhost:5010/start-service', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ service: serviceName })
    });
    const data = await response.json();
    showAlert(data.message || `Service ${serviceName} started successfully!`, 'success');
  } catch (error) {
    showAlert(`Error starting service: ${error}`, 'danger');
  }
}

function showAlert(message, type) {
  const alertDiv = document.createElement('div');
  alertDiv.className = `alert alert-${type} alert-dismissible fade show`;
  alertDiv.setAttribute('role', 'alert');
  alertDiv.innerHTML = `
    ${message}
    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
      <span aria-hidden="true">×</span>
    </button>
  `;
  document.body.prepend(alertDiv);
  setTimeout(() => $(alertDiv).alert('close'), 5000);
}

// Button ripple effect remains as is
document.querySelectorAll('.btn-custom').forEach(btn => {
  btn.addEventListener('click', function(e) {
    const ripple = document.createElement('span');
    ripple.classList.add('ripple');
    const rect = this.getBoundingClientRect();
    const size = Math.max(rect.width, rect.height);
    ripple.style.width = ripple.style.height = size + 'px';
    ripple.style.left = e.clientX - rect.left - size / 2 + 'px';
    ripple.style.top = e.clientY - rect.top - size / 2 + 'px';
    this.appendChild(ripple);
    setTimeout(() => ripple.remove(), 600);
  });
});