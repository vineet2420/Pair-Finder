import 'package:google_maps_flutter/google_maps_flutter.dart';

class Activity{
  String owner = "null";

  String _activity_name = "null";
  get activityName => _activity_name;

  String _activity_description = "null";
  get activityDescription => _activity_description;

  double _latitude = 0.0;
  get activityLatitude => _latitude;

  double _longitude = 0.0;
  get activityLongitude => _longitude;

  String _location = "null";
  get activityLocation => _location;

  int _timestamp = 0;
  get activityTimestamp => _timestamp;

  String _pairID = "null";
  set pairID(String pair) => _pairID = pair;

  // New activity
  Activity(this.owner, this._activity_name, this._activity_description, LatLng markerPosition, this._location){
    _latitude = markerPosition.latitude;
    _longitude = markerPosition.longitude;
    _timestamp = DateTime.now().millisecondsSinceEpoch;
    _pairID = "-1";
  }

  @override
  toString() {
    return "Name: $_activity_name, Desc: $_activity_description";
  }

  Activity.getActivity(String data){

  }



}