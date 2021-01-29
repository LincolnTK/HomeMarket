import 'dart:developer';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homemarket/buy_screen/buy_screen.dart';
import 'package:homemarket/login_screen/sign_in.dart';
import 'package:homemarket/welcome_screen/welcome_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homemarket/screens/auth_screen.dart';
import 'package:homemarket/screens/firebase.dart';

var _uid = '';

var _phone = '';
var _address = '';
var _admin = '';
var _displayName = '';

Future userData(var field) async {
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

String admin(admin){
  var load = userData('address');
  return admin.toString();
}

class SellRegisterScreen extends StatefulWidget {
  static const String id = 'sell_register';

  @override
  _SellRegisterScreenState createState() => _SellRegisterScreenState();
}

class _SellRegisterScreenState extends State<SellRegisterScreen> {
  @override
  Widget build(BuildContext context) {

    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    var load = userData('address');

    var load2 = userData('displayName');

    return Scaffold(
      backgroundColor: Colors.white,
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
        title: Text('Your Property'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Hello " + _displayName + "!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 25,
                      fontFamily: 'Roboto',
                      fontStyle: FontStyle.italic)),
              SizedBox(
                height: 8.0,
              ),
              Text("Register Your new Property ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 25,
                      fontFamily: 'Roboto',
                      fontStyle: FontStyle.italic)),
              SellRegisterService(),
            ]),
      )),
    );
  }
}

class SellRegisterService extends StatefulWidget {
  @override
  _SellRegisterServiceState createState() => _SellRegisterServiceState();
}

class _SellRegisterServiceState extends State<SellRegisterService> {
  File _imageFile;
  final picker = ImagePicker();
  String fileName;
  String productImage;

  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery,maxHeight:  500 , maxWidth: 500);

    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  Future locale() async {
    String locale = await Devicelocale.currentLocale;
    return locale;
  }

  Future uploadImageToFirebase(BuildContext context) async {
    fileName = basename(_imageFile.path);
    productImage = sellerName.toString() +
        '-' +
        productName.text +
        '-' +
        selleruid +
        fileName;
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('$productImage');
    UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then(
          (value) => print("Done: $value"),
        );
  }

  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  final selleruid = FirebaseAuth.instance.currentUser.uid;
  final _formKey = GlobalKey<FormState>();
  final sellerName = _displayName;
  final sellerContact = _phone;
  final sellerWAContact = _phone;
  final sellerAddress = _address;
  final productName = TextEditingController();
  final productDescription = TextEditingController();
  final TextEditingController controller = TextEditingController();
 // static final uploadDate = new DateTime(now.year, now.month, now.day);
  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('dd-MM-yyyy');
  final String uploadDate = formatter.format(now);

//  String uploadDate = DateTime(DateTime.now().day, DateTime.now().month, DateTime.now().year).toString() ;
  String initialCountry = 'NG';
  PhoneNumber number = PhoneNumber(isoCode: 'NG');
  String numbr = '012345';

  @override
  Widget build(BuildContext context) {
    void getPhoneNumber(String phoneNumber) async {
      PhoneNumber number =
          await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'US');

      setState(() {
        this.number = number;
      });
    }

    @override
    void dispose() {
      controller?.dispose();
      super.dispose();
    }

    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
              controller: productName,
              maxLength: 50,
              maxLengthEnforced: true,
              decoration: InputDecoration(
                labelText: "Enter your Property Name",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value.isEmpty) {
                  return 'Enter your Property Name';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 10,
              maxLength: 200,
              maxLengthEnforced: true,
              controller: productDescription,
              decoration: InputDecoration(
                labelText: "Describe your Property",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value.isEmpty) {
                  return 'Enter your Property description';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Select a picture of your Property:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: _imageFile != null
                      ? Image.file(_imageFile)
                      : FlatButton(
                          child: Icon(
                            Icons.add_a_photo,
                            size: 50,
                          ),
                          onPressed: pickImage,
                        ),
                ),
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    color: Color(0xFF872602),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        if (_imageFile != null) {
                          uploadImageToFirebase(context);
                          showDialog(
                              context: context,
                              child: AlertDialog(
                                title: Text('Please confirm your submission'),
                                actions: <Widget>[
                                  FlatButton(
                                      onPressed: () async {
                                        CircularProgressIndicator();
                                        final ref = FirebaseStorage.instance
                                            .ref()
                                            .child('$productImage');
                                        var url = await ref.getDownloadURL();
                                        print(url);
                                        FirebaseFirestore.instance
                                            .collection('properties')
                                            .add({

                                              "imageurl": url.toString(),
                                          "selleruid": selleruid.toString(),

                                          "name": sellerName.toString(),
                                          "mobileno":
                                          sellerContact.toString(),
                                          "WAmobileno":
                                          sellerWAContact.toString(),
                                          "flatNo":
                                          sellerAddress.toString(),
                                          "title": productName.text,
                                          "date": uploadDate,
                                          "description":
                                          productDescription.text,
                                            })
                                            .then((result) => {
                                                  Navigator.of(context)
                                                      .pushAndRemoveUntil(
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                    return BuyScreen();
                                                  }),
                                                          ModalRoute.withName(
                                                              BuyScreen.id)),
                                                  productName.clear(),
                                                  productDescription.clear(),
                                                })
                                            .catchError((err) => print(err))
                                            .then((_) {
                                              Scaffold.of(context).showSnackBar(
                                                  SnackBar(
                                                      content: Text(
                                                          'Successfully Added')));

                                              productName.clear();
                                              productDescription.clear();
                                            })
                                            .catchError((onError) {
                                              Scaffold.of(context).showSnackBar(
                                                  SnackBar(
                                                      content: Text(onError)));
                                            });
                                      },
                                      child: Text('CONFIRM'))
                                ],
                              ));
                        } else {
                          showDialog(
                              context: context,
                              child: AlertDialog(
                                title: Text('Please confirm your submission'),
                                actions: <Widget>[
                                  FlatButton(
                                      onPressed: () async {
                                        CircularProgressIndicator();
                                        FirebaseFirestore.instance
                                            .collection('properties')
                                            .add({
                                          "imageurl": 'null',
                                              "selleruid": selleruid.toString(),

                                              "name": sellerName.toString(),
                                              "mobileno":
                                                  sellerContact.toString(),
                                              "WAmobileno":
                                                  sellerWAContact.toString(),
                                              "flatNo":
                                                  sellerAddress.toString(),
                                              "title": productName.text,
                                              "date": uploadDate,
                                              "description":
                                                  productDescription.text,
                                            })
                                            .then((result) => {
                                                  Navigator.of(context)
                                                      .pushAndRemoveUntil(
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                    return BuyScreen();
                                                  }),
                                                          ModalRoute.withName(
                                                              BuyScreen.id)),
                                                  productName.clear(),
                                                  productDescription.clear(),
                                                })
                                            .catchError((err) => print(err))
                                            .then((_) {
                                              Scaffold.of(context).showSnackBar(
                                                  SnackBar(
                                                      content: Text(
                                                          'Successfully Added')));

                                              productName.clear();
                                              productDescription.clear();
                                            })
                                            .catchError((onError) {
                                              Scaffold.of(context).showSnackBar(
                                                  SnackBar(
                                                      content: Text(onError)));
                                            });
                                      },
                                      child: Text('CONFIRM'))
                                ],
                              ));
                        }
                      }
                    },
                    child: Text('Submit',
                        style: TextStyle(
                          color: Colors.white,
                        )),
                  ),
                ],
              )),
        ])));
  }

  @override
  void dispose() {
    super.dispose();

    productName.dispose();
    productDescription.dispose();
  }
}
