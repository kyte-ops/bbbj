import os
import json
from flask import Flask, render_template, request, jsonify, send_from_directory, redirect, url_for

app = Flask(__name__, static_folder='.')

# Check if Firebase environment variables are set
# If not set, the app will still run but authentication won't work
if not os.environ.get('FIREBASE_API_KEY'):
    print("Warning: Firebase API key not set. Authentication will not work correctly.")
    print("Please set the Firebase environment variables.")
    
# Setup authDomain based on PROJECT_ID if not explicitly set
if not os.environ.get('FIREBASE_AUTH_DOMAIN') and os.environ.get('FIREBASE_PROJECT_ID'):
    os.environ['FIREBASE_AUTH_DOMAIN'] = f"{os.environ.get('FIREBASE_PROJECT_ID')}.firebaseapp.com"

# Set storageBucket based on PROJECT_ID if not explicitly set
if not os.environ.get('FIREBASE_STORAGE_BUCKET') and os.environ.get('FIREBASE_PROJECT_ID'):
    os.environ['FIREBASE_STORAGE_BUCKET'] = f"{os.environ.get('FIREBASE_PROJECT_ID')}.appspot.com"

@app.route('/')
def index():
    # We serve index.html as the entry point which will handle auth redirects
    # Authentication state will be handled client-side by Firebase
    return send_from_directory('.', 'index.html')

@app.route('/firebase-config')
def firebase_config():
    # Create Firebase config object with environment variables
    config = {
        'apiKey': os.environ.get('FIREBASE_API_KEY', ''),
        'authDomain': os.environ.get('FIREBASE_AUTH_DOMAIN', ''),
        'projectId': os.environ.get('FIREBASE_PROJECT_ID', ''),
        'storageBucket': os.environ.get('FIREBASE_STORAGE_BUCKET', ''),
        'messagingSenderId': os.environ.get('FIREBASE_MESSAGING_SENDER_ID', ''),
        'appId': os.environ.get('FIREBASE_APP_ID', '')
    }
    
    print(f"Serving Firebase config: {config}")
    return jsonify(config)

@app.route('/flutter_service_worker.js', methods=['GET'])
def flutter_service_worker():
    # Return an empty but successful response for Flutter service worker requests
    print(f"Handling flutter service worker request with query params: {request.args}")
    return "", 200

@app.route('/<path:path>')
def static_files(path):
    print(f"Serving path: {path}")
    return send_from_directory('.', path)

def run_server():
    # Change to the directory containing this script
    os.chdir(os.path.dirname(os.path.abspath(__file__)))
    
    print(f"Directory: {os.getcwd()}")
    print(f"Files: {os.listdir('.')}")
    print(f"Login page URL: http://0.0.0.0:5000/login.html")
    
    # Try to run the Flask app on port 5000, falling back to other ports if necessary
    port = 5000
    max_attempts = 3
    
    for attempt in range(max_attempts):
        try:
            # Run the Flask app
            app.run(host='0.0.0.0', port=port, debug=False)
            break  # If successful, exit the loop
        except OSError as e:
            if "Address already in use" in str(e) and attempt < max_attempts - 1:
                print(f"Port {port} is already in use. Trying port {port + 1}...")
                port += 1
            else:
                # If we've exhausted our attempts or got a different error, re-raise
                raise

if __name__ == '__main__':
    run_server()