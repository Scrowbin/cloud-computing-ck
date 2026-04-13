import json
from flask import Flask, jsonify
app = Flask(__name__)

@app.route("/hello")
def hello():
    return jsonify(message="Hello from App Server!")

@app.route("/student")
def student():
    with open("students.json") as f:
        data = json.load(f)
    return jsonify(data)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8081)
