from flask import Flask, request, jsonify
from flask_cors import CORS
import subprocess
import os

app = Flask(__name__)
CORS(app)  # Enable Cross-Origin Resource Sharing (CORS) to allow requests from different origins

# Define common path variables
projectPath = r"C:\Users\sakib.ahmad\OneDrive\Office Docs\My Projects"
Caller = r"A:\RunSetup\BatchCaller"

# Mapping dictionary: Maps job names to their corresponding file paths.
# The file paths include both batch files (.bat) and Python files (.py).
JOB_FILES = {
    "CI_AppServer": f"{Caller}\\CI_AppServer.bat",
    "CC_Appserver": f"{Caller}\\CC_Appserver.bat",
    "CI_TnpNad": f"{Caller}\\CI_TnpNad.bat",
    "AuthMSMQ": f"{Caller}\\AuthMSMQ.bat",
    "CIOutGoingEmbossing": f"{Caller}\\CIOutGoingEmbossing.bat",
    "Core Auth Aging Workflow": f"{Caller}\\Core Auth Aging Workflow.bat",
    "CoreAuthAppserver": f"{Caller}\\CoreAuthAppserver.bat",
    "CreateCase": f"{Caller}\\CreateCase.bat",
    "CreateCHJobWF": f"{Caller}\\CreateCHJobWF.bat",
    "ProductTransfer": f"{Caller}\\ProductTransfer.bat",
    "DeployerServer": f"{projectPath}\\Report Delpoyer\\Run_Server.bat", 
    "RestoreServer": f"{projectPath}\\AMEX_Label_Restore\\Run_Server.bat", 
    "Kill": f"{projectPath}\\Batch Scripts\\Terminate.bat",
    "Tview": f"{projectPath}\\HTML Flask Projects\\WorkFlows\\Tview.bat"	
}

# ✅ Endpoint to Start batch and py
@app.route('/run-batch', methods=['POST'])
def run_batch():
    try:
        # Retrieve the job name from the query parameter
        batch_name = request.args.get('name')
        # Get the file path corresponding to the provided job name
        file_path = JOB_FILES.get(batch_name)

        # If the provided job name is invalid, return an error response
        if not file_path:
            return jsonify({"error": "Invalid job name"}), 400

        # Check if the file exists at the specified path
        if not os.path.exists(file_path):
            return jsonify({"error": f"File not found: {file_path}"}), 404

        # Determine the file type based on its extension
        if file_path.lower().endswith('.py'):
            # If the file is a Python script, execute it using the Python interpreter
            # Execute Python file in a new command prompt window
            cmd = f'cmd.exe /c start cmd.exe /k python "{file_path}"'
            subprocess.Popen(cmd, shell=True, creationflags=subprocess.CREATE_NEW_CONSOLE)
        else:
            # Otherwise, assume it's a batch file and execute it using the command prompt
            subprocess.Popen(['cmd', '/c', file_path], shell=True)

        # Return a JSON response indicating successful execution
        return jsonify({"message": f"{batch_name} executed!"})
    except Exception as e:
        # In case of an error, return an error response with the exception message
        return jsonify({"error": str(e)}), 500

# ✅ New Endpoint to Start Windows Service
@app.route('/start-service', methods=['POST'])
def start_service():
    try:
        data = request.get_json()
        service_name = data.get("service")

        if not service_name:
            return jsonify({"error": "Service name is required"}), 400

        # Command to start Windows service
        cmd = f'sc start {service_name}'
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True)

        if result.returncode == 0:
            return jsonify({"message": f"Service '{service_name}' started successfully!"})
        else:
            return jsonify({"error": f"Failed to start service: {result.stderr}"}), 500

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    # Start the Flask application on port 5010
    app.run(port=5010)
