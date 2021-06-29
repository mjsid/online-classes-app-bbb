import 'dart:io';

import 'package:act_class/widgets/common/drawer.dart';
import 'package:act_class/widgets/common/login_animation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/registration.dart';
import '../models/user_model.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword>
    with SingleTickerProviderStateMixin {
  User user;
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  RegistrationService _register = RegistrationService();
  AnimationController _pwdButtonController;
  bool isLoading = false;
  String _pwdWarning;
  String _cnfmWarning;
  String _oldPwdWarning;

  @override
  void initState() {
    _pwdButtonController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<Null> _playAnimation() async {
    try {
      setState(() {
        isLoading = true;
      });
      await _pwdButtonController.forward();
    } on TickerCanceled {
      FlutterError('[_playAnimation] error');
    }
  }

  Future<Null> _stopAnimation() async {
    try {
      await _pwdButtonController.reverse();
      setState(() {
        isLoading = false;
      });
    } on TickerCanceled {
      FlutterError('[_stopAnimation] error');
    }
  }

  @override
  void dispose() {
    _pwdButtonController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    user = Provider.of<UserModel>(context).user;
    super.didChangeDependencies();
  }

  Future<void> changePassword() async {
    String newPwd = newPasswordController.text;
    String confirmPwd = confirmPasswordController.text;
    String oldPwd = oldPasswordController.text;
    if (newPwd == '') {
      setState(() {
        _pwdWarning = "Should not be blank";
        _cnfmWarning = '';
      });
    } else if (newPwd != confirmPwd) {
      setState(() {
        _pwdWarning = '';
        _cnfmWarning = "Password mismatch";
      });
    } else if (oldPwd == '') {
      _oldPwdWarning = "Should not be blank";
    } else {
      setState(() {
        _pwdWarning = '';
        _cnfmWarning = "";
      });

      Map<String, dynamic> res = await _register.changePassword(
          oldPwd: oldPwd, newPwd: newPwd, userId: user.id);

      if (res['success']) {
        Fluttertoast.showToast(
            msg: "Password updated successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 16.0);
        sleep(const Duration(seconds: 5));
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        Fluttertoast.showToast(
            msg: "Failed to Update",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.white,
            textColor: Colors.red,
            fontSize: 16.0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("CHANGE PASSWORD"),
      ),
      drawer: drawer(user, context),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Center(
          child: Container(
            height: height * 0.7,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Old Password',
                        style: TextStyle(fontSize: 18),
                      ),
                      TextField(
                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(255, 120, 10, 1))),
                            border: new UnderlineInputBorder(
                                borderSide: new BorderSide(
                                    color: Color.fromRGBO(255, 120, 10, 1)))),
                        controller: oldPasswordController,
                        obscureText: true,
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 5),
                      Text(_oldPwdWarning ?? '',
                          style: TextStyle(color: Colors.red)),
                      SizedBox(height: 20),
                      Text(
                        'New Password',
                        style: TextStyle(fontSize: 18),
                      ),
                      TextField(
                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(255, 120, 10, 1))),
                            border: new UnderlineInputBorder(
                                borderSide: new BorderSide(
                                    color: Color.fromRGBO(255, 120, 10, 1)))),
                        controller: newPasswordController,
                        obscureText: true,
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 5),
                      Text(_pwdWarning ?? '',
                          style: TextStyle(color: Colors.red)),
                      SizedBox(height: 20),
                      Text(
                        'Confirm Password',
                        style: TextStyle(fontSize: 18),
                      ),
                      TextField(
                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(255, 120, 10, 1))),
                            border: new UnderlineInputBorder(
                                borderSide: new BorderSide(
                                    color: Color.fromRGBO(255, 120, 10, 1)))),
                        controller: confirmPasswordController,
                        obscureText: true,
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(_cnfmWarning ?? '',
                          style: TextStyle(color: Colors.red)),
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          StaggerAnimation(
                              width: 120,
                              color: Theme.of(context).primaryColor,
                              titleButton: "Change",
                              buttonController: _pwdButtonController?.view,
                              onTap: () async {
                                _playAnimation();
                                changePassword();
                                await Future.delayed(Duration(seconds: 2));
                                _stopAnimation();
                              })
                          // FlatButton(
                          //     onPressed: () {},
                          //     child: Container(
                          //         padding: EdgeInsets.fromLTRB(10, 8, 8, 10),
                          //         width: 100,
                          //         decoration: BoxDecoration(
                          //           borderRadius: BorderRadius.circular(20.0),
                          //           color: Color.fromRGBO(10, 29, 150, 1),
                          //           boxShadow: [
                          //             BoxShadow(
                          //                 color: Colors.black38,
                          //                 blurRadius: 5.0, // soften the shadow
                          //                 spreadRadius: 0.8, //extend the shadow
                          //                 offset: Offset(
                          //                   2.0, // Move to right 10  horizontally
                          //                   2.0, // Move to bottom 10 Vertically
                          //                 )),
                          //           ],
                          //         ),
                          //         child: Center(
                          //           child: Text(
                          //             "Change",
                          //             style: TextStyle(
                          //                 fontSize: 20, color: Colors.white),
                          //           ),
                          //         ))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
