import 'package:flutter/material.dart';
import 'package:ipair/View/common_ui_elements.dart';

class HomeContent {
  Widget setupHomeContent() {
    return Column(
      children: <Widget>[
        SizedBox(height:20),
      Container(
        //color: Colors.red,
        height: 150,
      width:double.infinity,
      child:
        GridView.count(
            scrollDirection: Axis.horizontal,
            crossAxisCount: 2,
            children: <Widget>[
              // TODO After midterm - refactor this into its own object with more info about destination
              Center(child:Text("🍽", style: TextStyle(fontSize: 30))),
              Center(child:Text("🍿", style: TextStyle(fontSize: 30))),
              Center(child:Text("🚵‍♀️", style: TextStyle(fontSize: 30))),
              Center(child:Text("📚", style: TextStyle(fontSize: 30))),
              Center(child:Text("🗺", style: TextStyle(fontSize: 30))),
              Center(child:Text("🧑‍🍳", style: TextStyle(fontSize: 30))),
              Center(child:Text("👩‍🌾", style: TextStyle(fontSize: 30))),
              Center(child:Text("🎨", style: TextStyle(fontSize: 30))),
              Center(child:Text("🎭", style: TextStyle(fontSize: 30))),
              Center(child:Text("🎤", style: TextStyle(fontSize: 30))),
              Center(child:Text("🧑‍💻", style: TextStyle(fontSize: 30))),
              Center(child:Text("🕺", style: TextStyle(fontSize: 30))),
              Center(child:Text("🎮", style: TextStyle(fontSize: 30))),
              Center(child:Text("♛", style: TextStyle(fontSize: 30))),
              Center(child:Text("🛍", style: TextStyle(fontSize: 30))),
              Center(child:Text("🚙", style: TextStyle(fontSize: 30))),
              Center(child:Text("🍻", style: TextStyle(fontSize: 30))),
              Center(child:Text("🛥", style: TextStyle(fontSize: 30))),
            ]
        )
      ),
        SizedBox(height:20),
        sectionRow("🍴", "Dining"),
        sectionRow("🗺", "Explore"),
        sectionRow("❓", "Random"),
        SizedBox(height: 30),
        CommonUiElements().sectionHeader('Nearby Activities: ')
      ],
    );
  }

  Widget sectionRow(String emoji, String title) {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      height: 100,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(emoji, style: TextStyle(fontSize: 50)),
              Text(title, style: TextStyle(fontSize: 20)),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: Colors.indigo,
                  ))
            ],
          ),
        ),
        color: Colors.blueGrey.withOpacity(.4),
      ),
      // color: Constants().themeColor.withOpacity(.5),
    );
  }
}
