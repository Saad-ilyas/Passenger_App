
import 'package:flutter/material.dart';

import 'DriverSchedule/driverschedulescreen.dart';
import 'DriverSchedule/tripRequest_screen.dart';



class CarpoolScreen extends StatefulWidget {
  const CarpoolScreen({Key? key}) : super(key: key);

  @override
  _CarpoolScreenState createState() => _CarpoolScreenState();
}

class _CarpoolScreenState extends State<CarpoolScreen> {
  @override
  Widget build(BuildContext context) {
    var appSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,

        title:  Text("Passenger Dashboard",style: TextStyle(color: Colors.white,
            fontSize: appSize.width*0.055,
            fontWeight: FontWeight.w800),),

        centerTitle: true,



        elevation: 0,



      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [


              SizedBox(height: appSize.height*0.06,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>  SeatSelectionScreen(



                      )));

                    },
                    child: Container(
                      height: appSize.height*0.23,
                      width: appSize.width*0.42,
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: const Offset(
                              5.0,
                              5.0,
                            ),
                            blurRadius: 10.0,
                            spreadRadius: 2.0,
                          ), //BoxShadow
                          //BoxShadow
                        ],

                      ),
                      child: Column(
                        children: [
                          Container(
                            height: appSize.height*0.16,
                            width: appSize.width*0.8,
                            decoration: BoxDecoration(


                                image: DecorationImage(
                                  image: AssetImage("images/post.png"),
                                )
                            ),

                          ),
                          SizedBox(height: appSize.height*0.01,),
                          Text("DRIVER POSTS",style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Roboto",
                              fontSize: appSize.width*0.036
                          ),),
                        ],
                      ),
                    ),
                  ),InkWell(
                    onTap: (){

                        Navigator.push(context, MaterialPageRoute(builder: (context)=>  RequestScreen(



                        )
                        ));



                    },
                    child: Container(
                      height: appSize.height*0.23,
                      width: appSize.width*0.42,
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: const Offset(
                              5.0,
                              5.0,
                            ),
                            blurRadius: 10.0,
                            spreadRadius: 2.0,
                          ), //BoxShadow
                          //BoxShadow
                        ],

                      ),
                      child: Column(
                        children: [
                          Container(
                            height: appSize.height*0.15,
                            width: appSize.width*0.8,
                            decoration: BoxDecoration(


                                image: DecorationImage(
                                  image: AssetImage("images/order.png"),
                                )
                            ),

                          ),
                          SizedBox(height: appSize.height*0.02,),
                          Text("MY REQUESTS",style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Roboto",
                              fontSize: appSize.width*0.036
                          ),),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
              SizedBox(height: appSize.height*0.06,),



            ],
          ),
        ),
      ),
    );
  }


}
