from flask import Flask, request, jsonify
from flask_cors import CORS
import subprocess
import os

app = Flask(__name__)
CORS(app)  # Enable Cross-Origin Resource Sharing

# Path to your batch file
BATCH_FILE_PATH = r"BatchScript\Restore_Caller.bat"

@app.route('/run-batch', methods=['POST'])
def run_batch():
    try:
        # Retrieve JSON payload from the request
        data = request.get_json()
        labelOption = data.get('labelOption')
        version = data.get('version')
        date = data.get('date')
        database = data.get('database')
        dbLocation = data.get('dbLocation')
        
        # Validate that all required parameters are provided
        if not version or not date or not database:
            return jsonify({"error": "version, date, and database are required."}), 400
        
        # Check if the batch file exists
        if not os.path.exists(BATCH_FILE_PATH):
            return jsonify({"error": f"Batch file not found: {BATCH_FILE_PATH}"}), 404
        
        # Construct the command to execute the batch file in its own window.
        # The command passes the three parameters: version, date, and option.
        # Inside your batch file, you can handle the option by using conditional logic.
        command = f'start "" "{BATCH_FILE_PATH}" {labelOption} {version} {date} {database} {dbLocation}'
        
        # Execute the command asynchronously using subprocess.
        subprocess.Popen(command, shell=True)
        
        return jsonify({"message": f"Batch file executed with parameters: labelOption={labelOption}, Version={version}, date={date}, database={database}, dbLocation={dbLocation}"})
    except Exception as e:                                                                                            
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(port=5011)