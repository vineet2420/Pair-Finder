import 'package:flutter/material.dart';
import 'package:ipair/Model/activity_model.dart';
import 'package:ipair/View/common_ui_elements.dart';

class ActivityController{

  displayNewActivity(BuildContext context){
    int c = 0;
    print("called");
      ActivityModel().socket.on(
          'message', (data) {
            CommonUiElements().showMessage("Title", data, "Okay", context);
            print(data.toString() + " c: $c");
            c++;
          }
      );
    }

    disconnectSocket() => ActivityModel().socket.disconnect();

}