import 'package:firebase_database/firebase_database.dart';

class UserModel
{
   String? name;
   String? email;
   String? id;
   String? phone;
   String? gender;


   UserModel({this.name, this.email,this.id,this.phone,this.gender,});

   UserModel.fromSnapshot(DataSnapshot snap)
   {
     name =(snap.value as dynamic)["name"];
     phone =(snap.value as dynamic)["phone"];
     id=snap.key;
     email=(snap.value as dynamic)["email"];
     gender =(snap.value as dynamic)["gender"];

   }
}