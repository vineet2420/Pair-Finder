
class Activity{

  String _activity_name = "null";
  String _activity_description = "null";

  double _latitude = 0.0;
  double _longitude = 0.0;

  DateTime _timestamp = DateTime.now().toUtc();
  String _pairID = "null";

  Activity(this._activity_name, this._activity_description, this._latitude, this._longitude);

  Activity.getActivity(String data){

  }
}