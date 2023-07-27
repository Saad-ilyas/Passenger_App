import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../global/global.dart';
import '../../widgets/mytext.dart';





class RequestScreen extends StatefulWidget {
  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  bool? isButtonVisible;
  String? status;
  @override
  void initState() {
    super.initState();
    isButtonVisible = true;
    status = ""; // Initialize status to an empty string
    // Retrieve the status from the database and update the 'status' variable
    // using setState or any other method you use to fetch data.
  }
  @override
  Widget build(BuildContext context) {
    var appSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);

            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        title: Text(
          "REQUESTS",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orderRequest').where("senderId",isEqualTo: fAuth.currentUser!.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No request available'));
          }


          final documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
             var documentData = documents[index];

var ds=documentData.id;

              return Container(
                margin: EdgeInsets.only(left: appSize.width*0.03,right:appSize.width*0.03,top: appSize.height*0.01 ),
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(12)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 5,),
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage(
                                  "images/driver.png"
                              ),
                            ),
                            SizedBox(width: 5,),
                            Text(documentData.get("passengerName")),
                          ],
                        ),

                      ],
                    ),
                    ListTile(

                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5,),
                          MyText(text:'My Email: ${documentData.get("email")}',textcolor: Colors.black,),
                          MyText(text:'My Number: ${documentData.get("passengerNumber")}',textcolor: Colors.black,),
                          MyText(text:'Seat Number: ${documentData.get("seatNumber")}',textcolor: Colors.black,),
                          MyText(text:'Starting Point:${documentData.get("startingPoint")}',textcolor: Colors.black,),
                          MyText(text:'Drop-off Location: ${documentData.get("dropOff")}',textcolor: Colors.black,),
                          MyText(text:'Fare: ${documentData.get("userFare")}',textcolor: Colors.black,),
                          MyText(text:'Longitude: ${documentData.get("longitude")}',textcolor: Colors.black,),
                          MyText(text:'Latitude: ${documentData.get("latitude")}',textcolor: Colors.black,),
                          SizedBox(height: appSize.height*0.02,),
                          MyText(text:'Ride has been ${documentData.get("status")}',textcolor: Colors.black,),








                        ],
                      ),

                    ),




                  ],
                ),
              );
            },
          );
        },
      ),

    );
  }
}