


import 'package:firebase_auth/firebase_auth.dart';
import 'package:passenger_app/models/user_model.dart';

import '../models/directions_details_info.dart';

final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseuser;

UserModel? userModelCurrentInfo;
List dList =[];
DirectionDetailsInfo? tripDirectionDetailsInfo;
String? ChosenDriverId="";
String cloudMessagingServerToken = "key=AAAAI6VTo9E:APA91bHj_xcq2O7LLGsYB05nVhJFY8iz_7Ggp2i715Wb6QMZqdm3wERJKA77I3jrdDEnXg5iVtbqNfaCxE7tm9Xmii87hlGKNVKhC8Qap4FISF2whMXZ3V9d8BWbZVNctV18lbV6ZO6y";
String userDropOffAddress = "";
String driverCarDetails="";
String driverName="";
String driverPhone="";
double countRatingStars=0.0;
String titleStarsRating="";
String userPickupAddress = "";