import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../global/global.dart';
import '../widgets/info_design_ui.dart';



class ProfileScreen extends StatefulWidget
{
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}




class _ProfileScreenState extends State<ProfileScreen>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade900,
        elevation: 0,
      ),
      backgroundColor: Colors.blueGrey.shade900,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            //name
            Text(
              userModelCurrentInfo!.name!,
              style: const TextStyle(
                fontSize: 30.0,
                color: Colors.deepOrange,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 20,
              width: 300,
              child: Divider(
                color: Colors.white,
                height: 2,
                thickness: 1,
              ),
            ),

            const SizedBox(height: 38.0,),

            //phone
            InfoDesignUIWidget(
              textInfo: userModelCurrentInfo!.phone!,
              iconData: Icons.phone_iphone,

            ),

            //email
            InfoDesignUIWidget(
              textInfo: userModelCurrentInfo!.email!,
              iconData: Icons.email,
            ),

            InfoDesignUIWidget(
              textInfo: userModelCurrentInfo!.gender!,
              iconData: Icons.person,
            ),

            const SizedBox(
              height: 20,
            ),

            ElevatedButton(
                onPressed: ()
                {
                  SystemNavigator.pop();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.yellowAccent,
                ),
                child: const Text(
                  "Close App ",
                  style: TextStyle(color: Colors.black),
                ),
            )

          ],
        ),
      ),
    );
  }
}
