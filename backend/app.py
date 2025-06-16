from flask import Flask, request, jsonify
from flask_cors import CORS
from flask_jwt_extended import JWTManager, create_access_token, jwt_required, get_jwt_identity
from pymongo import MongoClient
import os
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)
CORS(app)
app.config["JWT_SECRET_KEY"] = os.getenv("JWT_SECRET_KEY", "secret")
jwt = JWTManager(app)

client = MongoClient(os.getenv("MONGO_URI"))
db = client.cloudtaskpro
users = db.users
tasks = db.tasks

@app.route("/", methods=["GET"])
def health_check():
    return jsonify({"status": "healthy", "service": "CloudTaskPro Backend"}), 200

@app.route("/register", methods=["POST"])
def register():
    data = request.json
    if users.find_one({"email": data["email"]}):
        return jsonify({"msg": "User already exists"}), 409
    users.insert_one(data)
    return jsonify({"msg": "User registered"}), 201

@app.route("/login", methods=["POST"])
def login():
    data = request.json
    user = users.find_one({"email": data["email"], "password": data["password"]})
    if not user:
        return jsonify({"msg": "Invalid credentials"}), 401
    token = create_access_token(identity=data["email"])
    return jsonify({"token": token}), 200

@app.route("/tasks", methods=["GET"])
@jwt_required()
def get_tasks():
    email = get_jwt_identity()
    user_tasks = list(tasks.find({"user": email}, {"_id": 0}))
    return jsonify(user_tasks)

@app.route("/tasks", methods=["POST"])
@jwt_required()
def create_task():
    data = request.json
    data["user"] = get_jwt_identity()
    tasks.insert_one(data)
    return jsonify({"msg": "Task created"}), 201

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
