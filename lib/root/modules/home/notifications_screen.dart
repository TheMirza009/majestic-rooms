import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, ), onPressed: () {
          Navigator.pop(context);
        },), 
        title: Text("Notifications"), 
        centerTitle: true,
        surfaceTintColor: Colors.white,
        ),  
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_outlined, size: 70, color: Colors.grey,), 
          SizedBox(height: 8,),
          Text("No Notifications", style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),),
        ],
      )));
  }
}