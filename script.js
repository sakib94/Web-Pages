// Listen for changes in the database select dropdown
document.getElementById('dbSelect').addEventListener('change', function() {
  const dbValue = this.value;
  const dbLocationInputDiv = document.getElementById('dbLocationInputDiv');
  
  // Show the DB location input if "Random" or "Users" is selected
  if (dbValue === 'Users' || dbValue === 'Random') {
    dbLocationInputDiv.style.display = 'block';
  } else {
    dbLocationInputDiv.style.display = 'none';
  }
});

// Listen for form submission
document.getElementById('batchForm').addEventListener('submit', async function(e) {
  e.preventDefault();
  
  const labelOptionValue = document.getElementById('labelOptionSelect').value;
  const versionValue = document.getElementById('versionInput').value;
  const dateValue = document.getElementById('dateInput').value;
  const dbValue = document.getElementById('dbSelect').value;
  const dbLocationValue = document.getElementById('dbLocationInput').value;
  const resultDiv = document.getElementById('result');
  const form = this;
  
  try {
    resultDiv.innerText = 'Processing...';
    const response = await fetch('http://localhost:5011/run-batch', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ 
        labelOption: labelOptionValue, 
        version: versionValue, 
        date: dateValue, 
        database: dbValue,
        dbLocation: dbLocationValue // Pass DB location if available
      })
    });
    const result = await response.json();
    resultDiv.innerText = result.message || result.error;
    resultDiv.className = result.error ? 'error' : '';
    
    // Reset form fields to default
    form.reset();
    document.getElementById('dbLocationInputDiv').style.display = 'none'; // Hide DB location input
  } catch (error) {
    resultDiv.innerText = 'Error: ' + error.message;
    resultDiv.className = 'error';
    
    // Reset form fields even on error
    form.reset();
    document.getElementById('dbLocationInputDiv').style.display = 'none';
  }
});