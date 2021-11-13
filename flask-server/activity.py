from flask_socketio import SocketIO, emit, send
from app import socket

@socket.on('connected')
def handle_id(data):
    print(data)

@socket.on('message')
def handle_message(data):
    print('received user: ' + data)
    send("All Received From Server", broadcast=True, namespace="")
