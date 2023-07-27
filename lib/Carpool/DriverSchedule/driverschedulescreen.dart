import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../global/global.dart';


class SeatSelectionScreen extends StatefulWidget {
  @override
  _SeatSelectionScreenState createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  Future<void> _launchUrl(Uri url) async {
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (_) {}
  }
  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  String? selectedSeatNumber;
  String? selectedPostId;
  String location = 'Press icon to get location';
  String Address = '';
  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    Address = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {});
  }
  var documentData2;
  var fare;
  var driverId;


  Future<void> updateFirestoreDocument(String documentId, List<Map<String, dynamic>> updatedSeatData) async {
    try {
      await FirebaseFirestore.instance.collection("driverPost").doc(documentId).update({
        "seats": updatedSeatData,
      });
      print("Firestore document updated successfully.");

      // Find the selected seat data
      Map<String, dynamic>? selectedSeat;

      for (final seat in updatedSeatData) {
        if (seat['isSelected'] == true) {
          selectedSeat = seat;
          break;
        }
      }

      // If a selected seat is found, add it to the order request data
      if (selectedSeat != null && selectedSeat['status'] == 'Reserved') {
        final seatNumber = selectedSeat['seatNumber'];
        final email = selectedSeat['email'];
        final latitude = selectedSeat['latitude'];
        final longitude = selectedSeat['longitude'];
        final startingPoint = documentData2['startingPoint'];
        final dropOffLocation = documentData2['dropOffLocation'];
        final date = documentData2['Date'];
        final time = documentData2['departureTime'];
        final fare2 = fare;
        final passengerNumber = selectedSeat['passengerNumber'];
        final passengerName = selectedSeat['passengerName'];

        // Upload the selected seat data to "orderRequest" collection
        await FirebaseFirestore.instance.collection("orderRequest").add({
          "seatNumber": seatNumber,
          "status": 'Reserved',
          "email": email,
          "latitude": latitude,
          "longitude": longitude,
          "senderId": userModelCurrentInfo!.id,
          "startingPoint": startingPoint,
          "dropOff": dropOffLocation,
          "date": date,
          "time": time,
          "status": "pending",
          "userFare": fare2,
          "passengerNumber": passengerNumber,
          "passengerName": passengerName,
          "driverId":driverId,
          "seatID":seatID
        });
      }

    } catch (error) {
      print("Error updating Firestore document: $error");
    }
  }


var seatID;



  @override
  Widget build(BuildContext context) {
    var appSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Seat Selection'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('driverPost')
            .where("status", isEqualTo: "pending")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available'));
          }

          final documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final documentData = documents[index];
              documentData2=documentData;
              final startingPoint = documentData['startingPoint'];
              final dropOffLocation = documentData['dropOffLocation'];

              final driverName = documentData['driverName'];
              final driverNumber = documentData['driverNumber'];
              driverId = documentData['driverId'];

              final carNumber = documentData['carNumber'];
              final carModel = documentData['carModel'];
              final carColor = documentData['carColor'];
              final date = documentData['Date'];
              final time = documentData['departureTime'];
              final totalFare = double.parse(documentData['totalFare']);
              fare = totalFare / 3;

              final seatData = List<Map<String, dynamic>>.from(documentData['seats']);

              return Container(
                margin: EdgeInsets.all(8.0),
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
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage("images/driver.png"),
                            ),
                            SizedBox(width: 8.0),
                            Text(driverName),
                          ],
                        ),
                        GestureDetector(
                         onTap: ()
                          {
                            if (driverPhone != null) {
                              final Uri uri = Uri(scheme: 'tel', path: driverPhone);
                              _launchUrl(uri);
                            }
                            else if(driverPhone == null )
                              {
                                Fluttertoast.showToast(msg: "Phone number is incorrect or empty.");
                              }
                          },
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.call,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ListTile(
                      subtitle: Column(
                        crossAxisAlignment:CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 2.0),
                          Row(
                            children: [

                              Text(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                'Starting Point:',style: TextStyle(color: Colors.blueGrey.shade900),),
                              Flexible(
                                child: Text(
                                  '$startingPoint',
                                  style: TextStyle(color: Colors.deepOrangeAccent),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.0),
                          Row(
                            children: [

                              Text('Drop-off Location:',style: TextStyle(color: Colors.blueGrey.shade900),),
                              SizedBox(width: 3,),
                              Text('$dropOffLocation',style: TextStyle(color: Colors.deepOrangeAccent),),
                            ],
                          ),
                          SizedBox(height: 2.0),
                          Row(
                            children: [

                              Text('Phone number:',style: TextStyle(color: Colors.blueGrey.shade900),),
                              SizedBox(width: 3,),
                              Text('$driverNumber',style: TextStyle(color: Colors.deepOrangeAccent),),
                            ],
                          ),
                          SizedBox(height: 2.0),
                          Row(
                            children: [

                              Text('Car Number:',style: TextStyle(color: Colors.blueGrey.shade900),),
                              SizedBox(width: 3,),
                              Text('$carNumber',style: TextStyle(color: Colors.deepOrangeAccent),),
                            ],
                          ),
                          SizedBox(height: 2.0),
                          Row(
                            children: [

                              Text('Car Model:',style: TextStyle(color: Colors.blueGrey.shade900),),
                              SizedBox(width: 3,),
                              Text('$carModel',style: TextStyle(color: Colors.deepOrangeAccent),),
                            ],
                          ),
                          SizedBox(height: 2.0),
                          Row(
                            children: [

                              Text('Car Color:',style: TextStyle(color: Colors.blueGrey.shade900),),
                              SizedBox(width: 3,),
                              Text('$carColor',style: TextStyle(color: Colors.deepOrangeAccent),),
                            ],
                          ),
                          SizedBox(height: 2.0),
                          Row(
                            children: [

                              Text('Date:',style: TextStyle(color: Colors.blueGrey.shade900),),
                              SizedBox(width: 3,),
                              Text('$date',style: TextStyle(color: Colors.deepOrangeAccent),),
                            ],
                          ),
                          SizedBox(height: 2.0),
                          Row(
                            children: [

                              Text('Departure Time:',style: TextStyle(color: Colors.blueGrey.shade900),),
                              SizedBox(width: 3,),
                              Text('$time',style: TextStyle(color: Colors.deepOrangeAccent),),
                            ],
                          ),
                          SizedBox(height: 2.0),
                          Row(
                            children: [

                              Text('Each seat fare:',style: TextStyle(color: Colors.blueGrey.shade900),),
                              SizedBox(width: 3,),
                              Text('$fare',style: TextStyle(color: Colors.deepOrangeAccent),),
                            ],
                          ),

                          SizedBox(height: 8.0),
                          Text(
                            'Available Seats',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Container(
                            height: 100.0,
                            child: ListView.builder(
                              itemCount: seatData.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {

                                var seat = seatData[index];
                                seatID=seat;
                                final seatNumber = seat['seatNumber'];
                                final seatStatus = seat['status'];
                                final email = seat['email'];


                                Color seatColor = Colors.black; // Default color for available seats
                                if (seatStatus == 'Reserved') {
                                  seatColor = Colors.red;
                                }

                                if (seatStatus == 'Reserved') {
                                  // Seat is reserved, hide it
                                  return SizedBox.shrink();
                                } else {
                                  // Seat is available or other status, show it
                                  return GestureDetector(
                                    onTap: () async{

                                      Position userPosition = await _getGeoLocationPosition();

                                      setState(() {
                                        seatData.forEach((seat) {
                                          if (seat['seatNumber'] == seatNumber) {
                                            seat['isSelected'] = true; // Set the selected seat
                                            seat['status'] = 'Reserved'; // Update the status to 'Reserved' or any other value you desire
                                            seat['email'] = userModelCurrentInfo!.email;
                                            seat['passengerName'] = userModelCurrentInfo!.name!;
                                            seat['passengerNumber'] = userModelCurrentInfo!.phone!;
                                            seat['latitude'] = userPosition.latitude; // Include latitude in seatData
                                            seat['longitude'] = userPosition.longitude;
                                            seat['userId']=userModelCurrentInfo!.id;

                                          } else {
                                            seat['isSelected'] = false; // Reset selection for all other seats
                                          }
                                        });
                                      });

                                      // TODO: Send seatNumber to Firebase
                                      print("Selected seat no is $seatNumber");
                                      selectedSeatNumber = seatNumber;
                                      selectedPostId = documentData.id;

                                      // Update the Firestore document with the updated seatData
                                      updateFirestoreDocument(selectedPostId!, seatData);
                                      Fluttertoast.showToast(
                                          msg: "Dear ${userModelCurrentInfo!.name} your seat no ${seatNumber} is reserved, please wait for driver's approval",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.black,
                                          textColor: Colors.white,
                                          fontSize: 16.0
                                      );
                                    },


                                    child: Stack(
                                      children: [
                                        SizedBox(width: 50.0),
                                        Column(
                                          children: [
                                            SizedBox(height: 5.0),
                                            Image.asset(
                                              "images/seat.png",
                                              scale: 10,
                                              color: seat['isSelected'] == true ? Colors.red : seatColor,
                                            ),
                                            Text(
                                              seatNumber,
                                              style: TextStyle(
                                                color: Colors.orange,
                                                fontSize: 11.0,
                                              ),
                                            ),
                                            Text(seatStatus),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            ),
                          ),


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
