import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homemarket/welcome_screen/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homemarket/buy_screen/Hyperlink.dart';
import 'package:homemarket/buy_screen/call_service.dart';
import 'package:homemarket/buy_screen/whatsapp_service.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:shimmer/shimmer.dart';
import 'package:homemarket/screens/auth_screen.dart';

class BuyScreen extends StatefulWidget {
  static const String id = 'buy_screen';

  @override
  _BuyScreenState createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
  List<Map<dynamic, dynamic>> lists = [];
  String imageurl;
  String selleruid;
  String mobileno;
  String WAmobileno;
  final selleruidtext = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    final uid = auth.currentUser.uid;
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
        title: Text('Home Market'),
        backgroundColor: Color(0xFFff8c00),
      ),
      body: Center(
        child: Container(
            padding: const EdgeInsets.all(20.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('properties')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {

                  case ConnectionState.waiting:
                    return Shimmer.fromColors(
                        baseColor: Color(0xFF872602),
                        highlightColor: Color(0xFFff8c00),
                        period: Duration(seconds:2),
                        child: CircularProgressIndicator());
                  default:
                    return new ListView(
                      children: snapshot.data.docs.map((buydoc) {
                        imageurl = buydoc.get('imageurl');

                        selleruid = buydoc.get('selleruid');
                        mobileno = buydoc.get('mobileno');
                        WAmobileno = buydoc.get('WAmobileno');
                        return new Card(
                          color: Colors.orangeAccent,
                          child: Container(
                            color: Colors.white30,
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  buydoc.get('title'),
                                  style: TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                       ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          child: imageurl != 'null'
                                              ? Image.network(imageurl)
                                              : Text('--------------------'),
                                        ),

                                    ],
                                  ),
                                ),
                                Text(
                                  buydoc.get('description'),
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  "Date Posted: " + buydoc.get('date'),
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Offered by: " + buydoc.get('name'),
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  buydoc.get('flatNo'),
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ButtonBar(
                                  alignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    CallService('tel:' + mobileno),
                                    WAService(
                                        WAmobileno,
                                        'Hi ' +
                                            buydoc.get('name') +
                                            "!" +
                                            '\nI came across your product in Home Market! I would like to know more...'),
                                    if (uid == selleruid)
                                      TextButton.icon(
                                          label: Text('Delete',),
                                          icon: Icon(Icons.warning_amber_sharp),
                                          style: TextButton.styleFrom(
                                            primary: Colors.red,
                                            backgroundColor: Colors.white,
                                            onSurface: Colors.grey,
                                          ),
                                          onPressed: () async {
                                            showDialog(
                                                context: context,
                                                child: AlertDialog(
                                                  title: Text(
                                                      "Do you want to delete following product/service?"),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child:
                                                            Text('No, Cancel')),
                                                    FlatButton(
                                                        onPressed: () async {
                                                          {
                                                            CircularProgressIndicator();
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection('properties')
                                                                .doc(buydoc.id)
                                                                .delete();
                                                            Navigator.of(
                                                                    context)
                                                                .pushAndRemoveUntil(
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) {
                                                              return BuyScreen();
                                                            }),
                                                                    ModalRoute.withName(
                                                                        BuyScreen
                                                                            .id));
                                                          }
                                                        },
                                                        child: Text('Yes'))
                                                  ],
                                                ));
                                          }),
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
    );
  }
}
