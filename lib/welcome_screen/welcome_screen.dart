import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homemarket/screens/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homemarket/shops_screen/shops_screen.dart';
import 'package:homemarket/welcome_screen/rounded_button.dart';
import 'package:homemarket/buy_screen/buy_screen.dart';
import 'package:homemarket/household_screen/household_screen.dart';
import 'package:homemarket/sell_screen/sell_register.dart';
import 'package:from_css_color/from_css_color.dart';


class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>{

  var load = userData('address');
  var load1=userData('phone');

  final memberMobile = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                child: Image.asset('images/Logo_AMP.png'),
                height: 200,
              ),
              SizedBox(
                height: 36.0,
              ),
              RoundedButton(
                title: 'BUY PROPERTY',
                colour: Color(0xFF872602),
                onPressed: () {
                  Navigator.pushNamed(context, BuyScreen.id);
                },
              ),
              SizedBox(
                height: 8.0,
              ),
              RoundedButton(
                title: 'SELL PROPERTY',
                colour: Color(0xFF872602),
                onPressed: () {
                  Navigator.pushNamed(context, SellRegisterScreen.id);
                },
              ),
              SizedBox(
                height: 8.0,
              ),
              RoundedButton(
                title: 'SERVICES',
                colour: Color(0xFF872602),
                onPressed: () {
                  Navigator.pushNamed(context, HouseholdScreen.id);
                },
              ),
              SizedBox(
                height: 8.0,
              ),
              // RoundedButton(
              //   title: 'SHOPS NEAR ME',
              //   colour: Color(0xFF872602),
              //   onPressed: () {
              //     Navigator.pushNamed(context, ShopsScreen.id);
              //   },
              // ),
            ],
          ),
        ),
       persistentFooterButtons: <Widget>[

         RaisedButton(

           color: Colors.white,
           child: Text('Logout',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 20),),
           onPressed: (){
             FirebaseAuth.instance.signOut();

             Navigator.of(context).pushAndRemoveUntil(
                 MaterialPageRoute(builder: (context) {
                   return AuthScreen();
                 }), ModalRoute.withName(WelcomeScreen.id));
           }

         ),

      ],
    );
  }
}
