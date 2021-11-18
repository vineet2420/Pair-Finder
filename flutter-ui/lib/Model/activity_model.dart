import 'package:flutter/material.dart';
import 'package:ipair/ActivityFlow/activity.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;

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
// 'http://127.0.0.1:8000'
  // http://ec2-52-201-232-123.compute-1.amazonaws.com:5000
  IO.Socket socket = IO.io('http://127.0.0.1:8000',
      <String, dynamic>{
    'transports': ['websocket']
  });

  final String newActivityRoute = "http://localhost:8000/activity/create?";
      //"http://ec2-52-201-232-123.compute-1.amazonaws.com:5000/activity/create?";
  Future<List> fetchActivityCreationStatus(Activity activity) async{
    final response;

    try {
      response = await http.get(
          Uri.parse(newActivityRoute + 'owner=' + activity.owner + "&actname=" + activity.activityName
          + "&actdesc=" + activity.activityDescription + "&actlat=" + activity.activityLatitude.toString() +
              "&actlong=" + activity.activityLongitude.toString() + "&creationtime=" + activity.activityTimestamp.toString()));

      print("Activity Created Status: ${response.body}");
      return [response.statusCode, response.body];
    } on Exception catch (e) {
      print("Activity Created Status Sever Error: $e");
      return [500, "-1"];
    }

  }






  void connectAndListen() async {
    if (!socket.connected){
      socket.onConnect((data)=>print("Connected"));
    }
    // print("Attempting socket connection");
    //
    // socket.onConnectError((data) => print(data));

    // socket.emit('message', 'test1');
    //activitySocketStream.socketStream.listen((latestEvent) {
      //print(latestEvent.toString());
    //});

    // socket.on(
    //     'message',
    //         (data) {
    //         activitySocketStream.socketStreamSink.add(data.toString());
    //     });

   // socket.disconnect();
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

