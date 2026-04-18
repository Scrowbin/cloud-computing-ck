import json
import os
import time

import requests
from flask import Flask, jsonify, request
from jose import jwt

app = Flask(__name__)

ISSUER = os.getenv("OIDC_ISSUER", "http://authentication-identity-server:8080/realms/master")
AUDIENCE = os.getenv("OIDC_AUDIENCE", "myapp")
JWKS_URL = f"{ISSUER}/protocol/openid-connect/certs"
_JWKS = None
_TS = 0


def get_jwks():
    global _JWKS, _TS
    now = time.time()
    if not _JWKS or now - _TS > 600:
        _JWKS = requests.get(JWKS_URL, timeout=5).json()
        _TS = now
    return _JWKS

@app.route("/hello")
def hello():
    return jsonify(message="Hello from backend")


@app.route("/secure")
def secure():
    auth = request.headers.get("Authorization", "")
    if not auth.startswith("Bearer "):
        return jsonify(error="Missing Bearer token"), 401

    token = auth.split(" ", 1)[1]
    try:
        payload = jwt.decode(
            token,
            get_jwks(),
            algorithms=["RS256"],
            audience=AUDIENCE,
            issuer=ISSUER,
        )
        return jsonify(
            message="Secure resource OK",
            preferred_username=payload.get("preferred_username"),
        )
    except Exception as exc:
        return jsonify(error=str(exc)), 401

@app.route("/student")
def student():
    with open("students.json") as f:
        data = json.load(f)
    return jsonify(data)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8081)
