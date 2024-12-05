# Base image
FROM debian:bookworm-slim AS base

# Install dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    flask \
    shred \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Create the Flask application directly in the Dockerfile
RUN echo "from flask import Flask, render_template, request, redirect, url_for, flash, jsonify" > app.py && \
    echo "import os" >> app.py && \
    echo "import subprocess" >> app.py && \
    echo "" >> app.py && \
    echo "app = Flask(__name__)" >> app.py && \
    echo "app.secret_key = 'supersecretkey'" >> app.py && \
    echo "" >> app.py && \
    echo "@app.route('/')" >> app.py && \
    echo "def index():" >> app.py && \
    echo "    return render_template('index.html')" >> app.py && \
    echo "" >> app.py && \
    echo "@app.route('/wipe', methods=['POST'])" >> app.py && \
    echo "def wipe():" >> app.py && \
    echo "    file_path = request.form['file_path']" >> app.py && \
    echo "    if os.path.exists(file_path):" >> app.py && \
    echo "        subprocess.run(['shred', '-u', file_path])" >> app.py && \
    echo "        return jsonify({'message': f'Successfully wiped {file_path}'})" >> app.py && \
    echo "    else:" >> app.py && \
    echo "        return jsonify({'error': 'File does not exist'}), 404" >> app.py && \
    echo "" >> app.py && \
    echo "if __name__ == '__main__':" >> app.py && \
    echo "    app.run(host='0.0.0.0', port=5000)" >> app.py && \
    echo "" >> app.py && \
    echo "with open('templates/index.html', 'w') as f:" >> app.py && \
    echo "    f.write('''<!DOCTYPE html>'')" >> app.py && \
    echo "    f.write('<html lang=\"en\">')" >> app.py && \
    echo "    f.write('<head><meta charset=\"UTF-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"><title>File Wiper</title></head>')" >> app.py && \
    echo "    f.write('<body><h1>Wipe a File</h1><form action=\"/wipe\" method=\"post\"><label for=\"file_path\">File Path:</label><input type=\"text\" id=\"file_path\" name=\"file_path\" required><button type=\"submit\">Wipe File</button></form></body></html>')" >> app.py

# Expose the port for the Flask app
EXPOSE 5000

# Command to run the Flask application
CMD ["python3", "app.py"]
