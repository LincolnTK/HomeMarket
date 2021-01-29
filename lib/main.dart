import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homemarket/household_screen/register_service.dart';
import 'package:homemarket/login_screen/login_page.dart';
import 'package:homemarket/sell_screen/sell_register.dart';
import 'package:homemarket/shops_screen/shops_screen.dart';
import 'package:homemarket/welcome_screen/welcome_screen.dart';
import 'package:homemarket/screens/auth_screen.dart';
import 'package:homemarket/buy_screen/buy_screen.dart';
import 'package:homemarket/household_screen/household_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Home  Market',
    theme: ThemeData(
        primarySwatch: Colors.orange,
      primaryColor: Colors.orange,
      backgroundColor: Color(0xFF872602),
    ),

      home: StreamBuilder(

        stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context,snapshot){
          if(snapshot.hasData){
            return WelcomeScreen();
          }
          return AuthScreen();
      },
      ),
    debugShowCheckedModeBanner: false,
 //       initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        BuyScreen.id: (context) => BuyScreen(),
        LoginPage.id: (context) => LoginPage(),
        HouseholdScreen.id: (context) => HouseholdScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        SellRegisterScreen.id: (context) => SellRegisterScreen(),
        ShopsScreen.id: (context) => ShopsScreen()

      },

    );
  }
}
