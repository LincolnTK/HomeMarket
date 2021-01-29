import 'package:flutter/material.dart';
import 'package:homemarket/household_screen/household_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


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
var load = _userData('address');

class RegisterScreen extends StatefulWidget {
  static const String id = 'register_service';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    var load2 = _userData('address');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) {
                return HouseholdScreen();
              }), ModalRoute.withName(HouseholdScreen.id));
            }),
        title: Text('Services Needed'),
        backgroundColor: Color(0xFFff8c00),
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Add Your Service Request ",
                  style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 25,
                      fontFamily: 'Roboto')),
              RegisterService(),
            ]),
      )),
    );
  }
}

class RegisterService extends StatefulWidget {
  @override
  _RegisterServiceState createState() => _RegisterServiceState();
}

class _RegisterServiceState extends State<RegisterService> {
  final _formKey = GlobalKey<FormState>();
  final serviceType = TextEditingController();
  final serviceName = TextEditingController();
  final serviceContact = TextEditingController();
  final serviceFlat = TextEditingController();

  //final dbRef = FirebaseDatabase.instance.reference().child("services");

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(children: <Widget>[

              Padding(
                padding: EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: serviceType,
                  maxLength: 20,
                  maxLengthEnforced: true,
                  decoration: InputDecoration(
                    labelText: "What kind of service do you need?",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter service needed';
                    }
                    return null;
                  },
                ),
              ),

          Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    color: Color(0xFF872602),

                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        FirebaseFirestore.instance
                            .collection('services')
                            .add({
                              "name": _displayName,
                              "contact": _phone,
                              "flatNo": _address,
                          "uid": _uid,
                              "serviceType": serviceType.text,
                            })
                            .then((result) => {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(builder: (context) {
                                    return HouseholdScreen();
                                  }), ModalRoute.withName(HouseholdScreen.id)),
                                  serviceName.clear(),
                                  serviceContact.clear(),
                                  serviceFlat.clear(),
                                  serviceType.clear()
                                })
                            .catchError((err) => print(err))
                            .then((_) {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('Successfully Added')));
                              serviceName.clear();
                              serviceFlat.clear();
                              serviceContact.clear();
                              serviceType.clear();
                            })
                            .catchError((onError) {
                              Scaffold.of(context).showSnackBar(
                                  SnackBar(content: Text(onError)));
                            });
                      }
                    },
                    child: Text('Submit', style: TextStyle(color: Colors.white,),),
                  ),
                ],
              )),
        ])));
  }

  @override
  void dispose() {
    super.dispose();
    serviceName.dispose();
    serviceContact.dispose();
    serviceFlat.dispose();
    serviceType.dispose();
  }
}
