import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homemarket/household_screen/register_service.dart';
import 'package:homemarket/welcome_screen/welcome_screen.dart';
import 'package:homemarket/buy_screen/call_service.dart';
import 'package:shimmer/shimmer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homemarket/screens/auth_screen.dart';

var _uid = '';

var _phone = '';
var _address = '';
var _admin = '';
var _displayName = '';
Future _userData(var field) async {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth auth = await FirebaseAuth.instance;
  final uid = auth.currentUser.uid;

  var firebaseUser = FirebaseAuth.instance.currentUser;
  final documentSnapshot = await FirebaseFirestore.instance
      .collection('Users')
      .doc(uid.toString())
      .get();
  final data = documentSnapshot.data();
  _uid = uid.toString();

  var address = await data['address'].toString();
  var admin = await data['admin'].toString();
  var displayName = await data['displayName'].toString();
  var phone = await data['phone'].toString();

  _address = address.toString();
  print(_address);

  _admin = admin.toString();
  print(_admin);

  _displayName = displayName.toString();
  print(_displayName);

  _phone = phone.toString();
  print(_phone);
}




class HouseholdScreen extends StatefulWidget {
  static const String id = 'household_screen';

  @override
  _HouseholdScreenState createState() => _HouseholdScreenState();
}


class _HouseholdScreenState extends State<HouseholdScreen> {
  @override
  Widget build(BuildContext context) {

    var load = _userData('address');

    return Scaffold(

      backgroundColor: Color(0xFF872602),
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) {
                return WelcomeScreen();
              }), ModalRoute.withName(WelcomeScreen.id));
            }),
        actions: <Widget>[
          FlatButton(
            onPressed: () async {
              showDialog(
                  context: context,
                  child: AlertDialog(
                    title: Text("Are you sure you want to Log Out?"),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('No, Cancel')),
                      FlatButton(
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) {
                                  return AuthScreen();
                                }), ModalRoute.withName(WelcomeScreen.id));
                          },
                          child: Text('Yes'))
                    ],
                  ));
            },
            child: Text('Log Out'),
            textColor: Colors.white,
          )
        ],
        title: Text('SERVICES NEEDED'),
        backgroundColor: Color(0xFFff8c00),
      ),
      body: Center(
        child: Container(
            padding: const EdgeInsets.all(10.0),
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('services').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Shimmer.fromColors(
                        baseColor: Color(0xFF872602),
                        highlightColor: Color(0xFFff8c00),
                        period: Duration(seconds:3),
                        child: new ListView(
                          children: snapshot.data.docs.map((doc) {
                            var load2 = _userData('address');
                            var serviceuid = doc.get('uid').toString();
                            return Card(
                              elevation: 20.0,
                              color: Colors.orangeAccent,
                              child: Container(
                                color: Colors.white30,
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "Service Requester: " + doc.get('name'),
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Address: " + doc.get('flatNo'),
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Service Required: " + doc.get('serviceType'),
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    ButtonBar(
                                      alignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        CallService('tel:' + doc.get('contact')),
                                        if(_uid==serviceuid|| _admin=='true')
                                          FlatButton(


                                            color: Colors.white,
                                            textColor: Colors.red,

                                            child: const Text('Delete'),
                                            onPressed: () async {
                                              showDialog(
                                                  context: context,
                                                  child: AlertDialog(
                                                    title: Text(
                                                        "Do you want to delete requested service?"),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                          onPressed: () {
                                                            Navigator.pop(context);
                                                          },
                                                          child: Text('No, Cancel')),
                                                      FlatButton(
                                                          onPressed: () async {
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                'services')
                                                                .doc(doc.id)
                                                                .delete();
                                                            Navigator.pop(context);
                                                          },
                                                          child: Text('Yes'))
                                                    ],
                                                  ));
                                            },
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ));
                  default:
                    return new ListView(
                      children: snapshot.data.docs.map((doc) {
                        var load2 = _userData('address');
                        var serviceuid = doc.get('uid').toString();
                        return Card(
                          elevation: 20.0,
                          color: Colors.orangeAccent,
                          child: Container(
                            color: Colors.white30,
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "Service Requester: " + doc.get('name'),
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Address: " + doc.get('flatNo'),
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Service Required: " + doc.get('serviceType'),
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ButtonBar(
                                  alignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    CallService('tel:' + doc.get('contact')),
                                    if(_uid==serviceuid|| _admin=='true')
                                    FlatButton(


                                      color: Colors.white,
                                      textColor: Colors.red,

                                      child: const Text('Delete'),
                                      onPressed: () async {
                                        showDialog(
                                            context: context,
                                            child: AlertDialog(
                                              title: Text(
                                                  "Do you want to delete requested service?"),
                                              actions: <Widget>[
                                                FlatButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('No, Cancel')),
                                                FlatButton(
                                                    onPressed: () async {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'services')
                                                          .doc(doc.id)
                                                          .delete();
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('Yes'))
                                              ],
                                            ));
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                }
              },
            )),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, RegisterScreen.id);
        },
        icon: Icon(Icons.add),
        label: Text("Add Request"),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
