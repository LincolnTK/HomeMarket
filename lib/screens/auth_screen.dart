import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _email  = '';

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
child: Card(
  margin: EdgeInsets.all(15),
  child: SingleChildScrollView(
    child: Padding(padding: EdgeInsets.all(20),
    child: Form(child: Column(
      children: <Widget>[
TextFormField(key: ValueKey('Email'),
decoration: InputDecoration(labelText: 'Email'),
onSaved: (val) {
  _email=val;
},
validator: (val){
  if(val.trim()){

  }
},
)
      ],
    ),),),
  ),
),
      ),
    );
  }
}

