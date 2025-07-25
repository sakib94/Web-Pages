import json
import subprocess
import os
import logging
from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

LOG_DIR = os.path.join(os.path.dirname(__file__), 'logs')
LOG_FILE = os.path.join(LOG_DIR, 'automation.log')

@app.route('/run_automation', methods=['POST'])
def run_automation():
    try:
        data = request.get_json()
        password = data.get('password')
        ci_package = data.get('ciPackage')
        cc_package = data.get('ccPackage')
        deployment_type = data.get('deploymentType')

        if not password or not deployment_type:
            return jsonify({'message': 'Password and deployment type are required'}), 400

        if deployment_type in ['CI', 'BOTH'] and not ci_package:
            return jsonify({'message': 'CoreIssue package path is required for CI/BOTH'}), 400

        if deployment_type in ['CC', 'BOTH'] and not cc_package:
            return jsonify({'message': 'CoreCollect package path is required for CC/BOTH'}), 400

        # Save input
        with open('input.json', 'w') as f:
            json.dump(data, f)

        # Flush previous log
        if os.path.exists(LOG_FILE):
            open(LOG_FILE, 'w').close()

        # Run automation
        result = subprocess.run(['python', 'automation.py'], capture_output=True, text=True, timeout=600)

        # Read log for final message
        success_message = "Automation completed successfully!"
        if os.path.exists(LOG_FILE):
            with open(LOG_FILE, 'r') as log_file:
                lines = log_file.readlines()
                for line in reversed(lines):
                    if "Reports deployed successfully" in line:
                        success_message = line.strip()
                        break

        if result.returncode == 0:
            return jsonify({'message': success_message})
        else:
            return jsonify({'message': f"Error: Automation script failed - {result.stderr}"}), 500

    except Exception as e:
        return jsonify({'message': f"Server error: {str(e)}"}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5020)
