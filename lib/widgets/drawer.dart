
import 'package:flutter/material.dart';

import 'package:passenger_app/MainScreens/about_screen.dart';
import 'package:passenger_app/MainScreens/profile_screen.dart';

import '../MainScreens/trips_history_screen.dart';
import '../SplashScreen/splash_screen.dart';
import '../global/global.dart';




class MyDrawer extends StatefulWidget
{
  String? name;
  String? email;

  MyDrawer({this.name, this.email});

  @override
  _MyDrawerState createState() => _MyDrawerState();
}



class _MyDrawerState extends State<MyDrawer>
{



  @override
  Widget build(BuildContext context)
  {
    return Drawer(
      child: ListView(
        children: [
          //drawer header
          Container(
            height: 165,
            color: Colors.transparent,
            child: DrawerHeader(
              decoration:  BoxDecoration(color:Colors.blueGrey.shade900),
              child: Row(
                children: [
                  const Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.white,
                  ),

                  const SizedBox(width: 16,),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.name.toString(),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.deepOrangeAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Text(
                        widget.email.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.yellowAccent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const  SizedBox(height: 12.0,),

          //drawer body
          GestureDetector(
            onTap: ()
            {
              Navigator.push(context, MaterialPageRoute(builder: (c)=> TripsHistoryScreen()));
            },
            child: const ListTile(
              leading: Icon(Icons.history, color: Colors.white,),
              title: Text(
                "Trip History",
                style: TextStyle(
                    color: Colors.white
                ),
              ),
            ),
          ),
SizedBox(height: 5,),
          const Divider(
            height: 1,
            thickness: 2,
            color: Colors.grey,
          ),
          GestureDetector(
            onTap: ()
            {
              Navigator.push(context, MaterialPageRoute(builder: (c)=> ProfileScreen()));
            },
            child: const ListTile(
              leading: Icon(Icons.person, color: Colors.white,),
              title: Text(
                "Visit Profile",
                style: TextStyle(
                    color: Colors.white
                ),
              ),
            ),
          ),
          SizedBox(height: 5,),
          const Divider(
            height: 1,
            thickness: 2,
            color: Colors.grey,
          ),
          GestureDetector(
            onTap: ()
            {
              Navigator.push(context, MaterialPageRoute(builder: (c)=> AboutScreen() ));
            },
            child: const ListTile(
              leading: Icon(Icons.info, color: Colors.white,),
              title: Text(
                "About",
                style: TextStyle(
                    color: Colors.white
                ),
              ),
            ),
          ),
          SizedBox(height: 5,),
          const Divider(
            height: 1,
            thickness: 2,
            color: Colors.grey,
          ),
          GestureDetector(
            onTap: ()
            {
              fAuth.signOut();
              Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
            },
            child: const ListTile(
              leading: Icon(Icons.logout, color: Colors.white,),
              title: Text(
                "Sign Out",
                style: TextStyle(
                    color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 5,),
          const Divider(
            height: 1,
            thickness: 2,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}

