import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homemarket/screens/firebase.dart';
import 'package:homemarket/welcome_screen/welcome_screen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _email = '';
  var _password = '';
  var _repPassword = '';
  var _isLogin = true;
  var _isBusy = false;
  var _userName= '';
  var _phone = '';
  var _address= '';
  bool _admin = false;

  final _formkey = GlobalKey<FormState>();
  final _scaffoldkey = GlobalKey<ScaffoldState>();

  void _submitForm() async{
    final isValid = _formkey.currentState.validate();

    if (isValid) {
      _formkey.currentState.save();
      FocusScope.of(context).unfocus(); // close the keyboard

      setState(() {
        _isBusy = true;
      });
      print('_email: $_email');
      print('_password: $_password');
      print('_repPasword: $_repPassword');

      UserCredential authRes;

      try{

      if (_isLogin) {
        authRes = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
      } else {
        authRes = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        userSetup(_userName,_phone,_address,_admin);
      }
      if(authRes.user==null){
        _scaffoldkey.currentState.showSnackBar(SnackBar(
          content:Text('Please enter correct email/password'),
        ));

      }else{
        _scaffoldkey.currentState.showSnackBar(SnackBar(
          content:Text('Success'),


        ));
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => WelcomeScreen()));

            }

    } catch(e) {
        _scaffoldkey.currentState.showSnackBar(SnackBar(
            content:Text(e.message),
          ));
      }finally {
        setState(() {
          _isBusy=false;
        });

      }

      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Card(
          margin: EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formkey,
                child: Column(
                  children: <Widget>[
                    if (!_isLogin)
                    TextFormField(
                      key: ValueKey('userName'),
                      decoration: InputDecoration(labelText: 'Name'),

                      onSaved: (val) {
                        _userName = val.trim();
                      },
                      validator: (val) {
                        if (val.trim().isEmpty) {
                          return 'Name cannot be empty';
                        }
                        return null;
                      },
                    ),
                    if (!_isLogin)
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        key: ValueKey('Phone'),
                        decoration: InputDecoration(labelText: 'Phone/Whatsapp',prefixText: '+',),

                        onSaved: (val) {
                          _phone = val.trim();
                        },
                        validator: (val) {
                          if (val.trim().isEmpty) {
                            return 'Phone field cannot be empty';
                          }
                          return null;
                        },
                      ),
                    if (!_isLogin)
                    TextFormField(
                      keyboardType: TextInputType.streetAddress,
                      key: ValueKey('address'),
                      decoration: InputDecoration(labelText: 'Enter your Address',),

                      onSaved: (val) {
                        _address = val.trim();
                      },
                      validator: (val) {
                        if (val.trim().isEmpty) {
                          return 'Enter your Address';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      key: ValueKey('Email'),
                      decoration: InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (val) {
                        _email = val.trim();
                      },
                      validator: (val) {
                        if (val.trim().isEmpty) {
                          return 'Email cannot be empty';
                        }
                        if (!val.trim().contains('@')) {
                          return 'Enter correct email';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      key: ValueKey('password'),
                      obscureText: true,
                      decoration: InputDecoration(labelText: 'Password'),
                      onSaved: (val) {
                        _password = val.trim();
                      },
                      validator: (val) {
                        _password = val.trim();
                        if (val.trim().isEmpty) {
                          return 'Pasword cannot be empty';
                        }
                        if (val.trim().length < 5) {
                          return 'Password too short';
                        }

                        return null;
                      },
                    ),
                    if (!_isLogin)
                      TextFormField(
                        key: ValueKey('repPassword'),
                        obscureText: true,
                        decoration:
                            InputDecoration(labelText: 'Repeat Password'),
                        onSaved: (val) {
                          _repPassword = val.trim();
                        },
                        validator: (val) {
                          if (val.trim().isEmpty) {
                            return 'Repeat password cannot be empty';
                          }
                          if (val.trim() != _password) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    SizedBox(
                      height: 15,
                    ),
                    if(_isBusy)
                      CircularProgressIndicator(),
                if(!_isBusy)
                Column(
                  children: <Widget>[
                    RaisedButton(
                      color: Color(0xFF872602),
                      textColor: Colors.white,
                   onPressed: _submitForm,
                      child: Text(_isLogin ? 'Login' : 'Signup'),
                    ),
                    FlatButton(
                      color: Colors.white,
                      textColor: Color(0xFFff8c00),
                      child: Text(_isLogin
                          ? 'Create new Account'
                          : 'I already have an account', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                    ),
                  ],
                ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
