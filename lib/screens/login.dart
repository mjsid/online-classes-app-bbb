//Flutter imports
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//User Defined imports
import '../common/constants/images.dart';
import '../widgets/common/login_animation.dart';
import '../widgets/firebase/firebase_cloud_messaging_wrapper.dart';
import '../models/user_model.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  AnimationController _loginButtonController;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  FirebaseCloudMessagagingWrapper _firebaseWrapper;
  String email, password;
  bool isLoading = false;
  bool isTeacher = false;

  var deviceToken;

  @override
  void initState() {
    super.initState();
    _loginButtonController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    _firebaseWrapper = FirebaseCloudMessagagingWrapper();
    getToken();
  }

  getToken() async {
    deviceToken = await _firebaseWrapper.getToken();
    print("${deviceToken.runtimeType}");
    print("DeviceToken : $deviceToken");
  }

  @override
  void dispose() {
    _loginButtonController.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      setState(() {
        isLoading = true;
      });
      await _loginButtonController.forward();
    } on TickerCanceled {
      FlutterError('[_playAnimation] error');
    }
  }

  Future<Null> _stopAnimation() async {
    try {
      await _loginButtonController.reverse();
      setState(() {
        isLoading = false;
      });
    } on TickerCanceled {
      FlutterError('[_stopAnimation] error');
    }
  }

  void _welcomeMessage(user, context) {
    final snackBar = SnackBar(
      content: Text('Welcome ${user.name} !'),
    );
    Scaffold.of(context).showSnackBar(snackBar);

    print("USER : $user");
    Navigator.of(context).pushReplacementNamed('/dashboard');
  }

  void _failMessage(message, context) {
    /// Showing Error messageSnackBarDemo
    /// Ability so close message
    final snackBar = SnackBar(
      elevation: 4.0,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      content: Text("Incorrect Credentials",
          style: TextStyle(color: Theme.of(context).primaryColor)),
      duration: Duration(seconds: 30),
      action: SnackBarAction(
        textColor: Theme.of(context).primaryColor,
        label: "close",
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  _login(context) async {
    if (email == null || password == null) {
      var snackBar = SnackBar(
          backgroundColor: Theme.of(context).accentColor,
          content: Text(
            "Please input username and password",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ));
      Scaffold.of(context).showSnackBar(snackBar);
    } else {
      await _playAnimation();
      await Provider.of<UserModel>(context, listen: false).userLogin(
          email: email.trim(),
          password: password.trim(),
          deviceToken: deviceToken,
          success: (user) {
            _stopAnimation();
            _welcomeMessage(user, context);
          },
          fail: (message) {
            _stopAnimation();
            _failMessage(message, context);
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      persistentFooterButtons: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Text(
                "Copyright \u00a9 2020 by Varsha Sinha. All Rights Reserved",
                style: TextStyle(
                    fontSize: 12, color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
      ],
      // backgroundColor: Color.fromRGBO(255, 120, 10, 1),
      body: SafeArea(
          child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: ListenableProvider.value(
          value: Provider.of<UserModel>(context),
          child: Consumer<UserModel>(builder: (context, model, child) {
            return Center(
              child: Stack(children: [
                SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                        alignment: Alignment.center,
                        width: screenSize.width /
                            (2 / (screenSize.height / screenSize.width)),
                        constraints: BoxConstraints(maxWidth: 700),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          elevation: 0,
                          child: Column(children: <Widget>[
                            // const SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                    child: Image.asset(
                                  kLogo,
                                  width: 300,
                                  height: 300,
                                )),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                              child: TextField(
                                  controller: _emailController,
                                  onChanged: (value) => email = value,
                                  decoration: InputDecoration(
                                      labelText: 'Email',
                                      labelStyle: TextStyle(
                                          color:
                                              Color.fromRGBO(255, 120, 10, 1)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  255, 120, 10, 1))),
                                      border: new UnderlineInputBorder(
                                          borderSide: new BorderSide(
                                              color: Color.fromRGBO(
                                                  255, 120, 10, 1))))),
                            ),
                            const SizedBox(height: 8.0),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                              child: TextField(
                                  onChanged: (value) => password = value,
                                  obscureText: true,
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                      labelText: 'Password',
                                      labelStyle: TextStyle(
                                          color:
                                              Color.fromRGBO(255, 120, 10, 1)),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  255, 120, 10, 1))),
                                      border: new UnderlineInputBorder(
                                          borderSide: new BorderSide(
                                              color: Color.fromRGBO(
                                                  255, 120, 10, 1))))),
                            ),
                            SizedBox(
                              height: 30.0,
                            ),
                            StaggerAnimation(
                              titleButton: "SIGN IN",
                              color: Theme.of(context).primaryColor,
                              buttonController: _loginButtonController.view,
                              onTap: () async {
                                if (!isLoading) {
                                  _login(context);
                                }
                              },
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            // StaggerAnimation(
                            //     titleButton: "Register",
                            //     buttonController: _registerButtonController.view,
                            //     onTap: () {
                            //       Navigator.of(context).pushNamed('/register');
                            //     }),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed('/register');
                              },
                              child: Container(
                                  width: 220,
                                  height: 50,
                                  alignment: FractionalOffset.center,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black38,
                                          blurRadius: 5.0, // soften the shadow
                                          spreadRadius: 0.8, //extend the shadow
                                          offset: Offset(
                                            3.0, // Move to right 10  horizontally
                                            3.0, // Move to bottom 10 Vertically
                                          ))
                                    ],
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.all(
                                        const Radius.circular(25.0)),
                                  ),
                                  child: Text(
                                    "REGISTER",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.3,
                                    ),
                                  )),
                            ),
                            SizedBox(
                              height: 30.0,
                            ),
                          ]),
                        ))),
                // Positioned(
                //   bottom: 0,
                //   child: Container(
                //     width: MediaQuery.of(context).size.width,
                //     // padding: EdgeInsets.only(left: 55),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: <Widget>[
                //         Flexible(
                //           flex: 1,
                //           child: Text(
                //             "Copyright \u00a9 2020 by Varsha Sinha. All Rights Reserved",
                //             style: TextStyle(
                //                 fontSize: 12,
                //                 color: Theme.of(context).primaryColor),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // )
              ]),
            );
          }),
        ),
      )),
    );
  }
}
