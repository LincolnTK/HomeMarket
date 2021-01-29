import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future <void> userSetup (String displayName, var phone, var address, bool admin,){

  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = auth.currentUser.uid.toString();

  users.doc(uid).set(
      {
        'displayName': displayName,
        'phone': '+'+phone,
        'address': address,
        'uid': uid,
        'admin': admin,
      });

  return null;

}


/*Future  userData () async {


  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = auth.currentUser.uid.toString();



  var firebaseUser = FirebaseAuth.instance.currentUser;
  final documentSnapshot = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
  final data = documentSnapshot.data();
  final phone = data['phone'];


  return null;

}*/
