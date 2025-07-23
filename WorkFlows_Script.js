function runBatch(batchName) {
  const button = event.currentTarget;
  button.disabled = true;
  //button.innerHTML = 'Processing...';

  fetch(`http://localhost:5010/run-batch?name=${batchName}`, { 
    method: 'POST'
  })
  .then(response => response.text())
  .then(data => {
    showAlert(`Batch ${batchName} executed: ${data}`, 'success');
    button.disabled = false;
    button.innerHTML = `${batchName.replace(/_/g, ' ')} is Running..`;
  })
  .catch(error => {
    showAlert(`Error executing ${batchName}: ${error}`, 'danger');
    button.disabled = false;
    //button.innerHTML = `${batchName.replace(/_/g, ' ')}`;
  });
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
