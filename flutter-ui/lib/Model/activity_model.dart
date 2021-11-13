import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class StreamSocket {
  final socketStreamController = BehaviorSubject<String>();

  Sink<String> get socketStreamSink => socketStreamController.sink;

  Stream<String> get socketStream => socketStreamController.stream;

  void dispose() {
    socketStreamController.close();
  }
}

class ActivityModel {
  StreamSocket activitySocketStream = StreamSocket();
// 'http://localhost:5000/'
  IO.Socket socket = IO.io('http://ec2-54-164-43-68.compute-1.amazonaws.com:5000/',
      <String, dynamic>{
    'transports': ['websocket']
  });

  void connectAndListen() async {
    if (!socket.connected){
      socket.onConnect((data)=>print("Connected"));
    }
    print("Attempting socket connection");

    //socket.onConnectError((data) => print(data));

    // socket.emit('message', 'test1');
    //activitySocketStream.socketStream.listen((latestEvent) {
      //print(latestEvent.toString());
    //});

    // socket.on(
    //     'message',
    //         (data) {
    //         activitySocketStream.socketStreamSink.add(data.toString());
    //     });

   //socket.disconnect();
  }

  Future<Widget> socketOutput(BuildContext context) async {
    return StreamBuilder(
      stream: activitySocketStream.socketStream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return Text(snapshot.data == null ? "null" : snapshot.data!);
      },
    );
  }
}

