import 'package:act_class/models/user.dart';
import 'package:act_class/services/registration.dart';
import 'package:act_class/widgets/common/login_animation.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '../models/user_registration.dart';
import '../models/class.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  UserRegistration _regFormModel = UserRegistration();
  RegistrationService _register = RegistrationService();
  AnimationController _registerButtonController;
  final FocusNode _focusNode = FocusNode();
  DateTime _selectedDate;
  Class _selectedClass;
  String _selectedGender;
  List<GradeFee> selectedClassGradeList;
  final dateController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  List<Class> data = []; //edited line
  bool isLoading = false;
  int _radioValue = 0;
  bool isNewUser = false;

  @override
  void initState() {
    _registerButtonController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    this.getSWData();
    super.initState();
  }

  @override
  void dispose() {
    _registerButtonController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      setState(() {
        isLoading = true;
      });
      await _registerButtonController.forward();
    } on TickerCanceled {
      FlutterError('[_playAnimation] error');
    }
  }

  Future<Null> _stopAnimation() async {
    try {
      await _registerButtonController.reverse();
      setState(() {
        isLoading = false;
      });
    } on TickerCanceled {
      FlutterError('[_stopAnimation] error');
    }
  }

  void _birthDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      } else {
        setState(() {
          _selectedDate = pickedDate;
        });
        dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
      }
    });
  }

  Future<void> checkUser(String email) async {
    print("Calling checke");
    try {
      var res = await http.post('http://live.akashtech24.com/api/checkuser',
          headers: {'Content-Type': 'application/json'},
          body: convert.jsonEncode({'email': email}));
      var resBody = convert.json.decode(res.body);
      print("RESPONSE : $resBody");
      bool status = resBody['success'];
      print("NEW USER STATUS : $status");
      setState(() {
        isNewUser = status;
      });
    } catch (e) {
      print("CHECK USER ERROR:");
      print(e.toString());
    }
  }

  String _emailvalidator(String value) {
    print("INITIAL VALUE");
    if (value == null) {
      return null;
    }
    if (!EmailValidator.validate(value)) {
      return 'Invalid Email Address';
    }
    if (!isNewUser) {
      return 'Email already exist';
    }
    return isNewUser ? null : "The Email already exists";
  }

  Future<void> getSWData() async {
    try {
      var res = await http.get("http://live.akashtech24.com/api/classes");
      var resBody = convert.json.decode(res.body);
      List<dynamic> classData = resBody['data'];
      // List<Class> d = classData
      //     .map((dynamic cls) => Class.fromJson(Map<String, dynamic>.from(cls)))
      //     .toList();
      List<Class> d = classData.map((dynamic cls) {
        List<dynamic> grades = cls['gradefee'];
        List<GradeFee> gradeFees = grades
            .map((dynamic grade) =>
                GradeFee.fromJson(Map<String, dynamic>.from(grade)))
            .toList();
        Class clsObj = Class.fromJson(Map<String, dynamic>.from(cls));
        clsObj.gradeFees = gradeFees;
        return clsObj;
      }).toList();

      setState(() {
        data = d;
      });
    } catch (e) {
      print("getClass error");
      print(e.toString());
    }
  }

  Iterable<E> mapIndexed<E, T>(
      Iterable<T> items, E Function(int index, T item) f) sync* {
    var index = 0;

    for (final item in items) {
      yield f(index, item);
      index = index + 1;
    }
  }

  // Future<void> userRegistration(
  //     BuildContext context, UserRegistration user) async {
  //   await _playAnimation();
  //   var response = await _register.registerUser(user: user);
  //   if (response == "Email Id already Registered") {
  //     var snackBar = SnackBar(
  //         elevation: 4.0,
  //         behavior: SnackBarBehavior.floating,
  //         backgroundColor: Colors.white,
  //         content: Text(
  //           "Email id is already registered",
  //           style: TextStyle(fontSize: 20.0, color: Colors.red),
  //         ));
  //     Scaffold.of(context).showSnackBar(snackBar);
  //     await _stopAnimation();
  //   } else {
  //     User user = User.fromJson(Map<String, dynamic>.from(response));
  //     var snackBar = SnackBar(
  //         elevation: 4.0,
  //         behavior: SnackBarBehavior.floating,
  //         backgroundColor: Colors.white,
  //         content: Text(
  //           "${user.name} registered successfully",
  //           style: TextStyle(
  //               fontSize: 20.0, color: Color.fromRGBO(10, 29, 150, 1)),
  //         ));
  //     Scaffold.of(context).showSnackBar(snackBar);
  //     await _stopAnimation();
  //     Navigator.pushReplacementNamed(context, '/login');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // _formKey.currentState?.validate();
    // print("STATE : ${_formKey.currentState}");
    return Scaffold(
        backgroundColor: Colors.blueGrey[50],
        appBar: AppBar(
          title: Text("REGISTRATION"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              elevation: 4.0,
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        style: Theme.of(context).textTheme.caption,
                        decoration: InputDecoration(
                            labelText: 'Name',
                            errorStyle: TextStyle(fontSize: 12)),
                        validator: (value) {
                          if (value == '') {
                            return 'Required Field';
                          }
                          return null;
                        },
                        onSaved: (value) => _regFormModel.name = value,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        style: Theme.of(context).textTheme.caption,
                        controller: emailTextController,
                        decoration: InputDecoration(
                            labelText: 'Email',
                            errorStyle: TextStyle(fontSize: 12)),
                        validator: (value) => _emailvalidator(value),
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (value) => _regFormModel.email = value,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        style: Theme.of(context).textTheme.caption,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            errorStyle: TextStyle(fontSize: 12)),
                        validator: (value) {
                          if (value == '') {
                            return 'Required Field';
                          }
                          return null;
                        },
                        obscureText: true,
                        onSaved: (value) => _regFormModel.password = value,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        style: Theme.of(context).textTheme.caption,
                        decoration: InputDecoration(
                            labelText: 'Phone',
                            errorStyle: TextStyle(fontSize: 12)),
                        validator: (value) {
                          if (value == '') {
                            return 'Required Field';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.phone,
                        onSaved: (value) => _regFormModel.phone = value,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DropdownButtonFormField(
                        style: Theme.of(context).textTheme.caption,
                        // autovalidate: true,
                        value: _selectedGender,
                        decoration: InputDecoration(
                            labelText: '--Gender--',
                            labelStyle: Theme.of(context).textTheme.caption,
                            errorStyle: TextStyle(fontSize: 12)),
                        validator: (value) {
                          if (value == null) {
                            return "Required";
                          }
                          return null;
                        },
                        items: [
                          {'id': 'Male'},
                          {'id': 'Female'},
                          {'id': 'Other'},
                        ]
                            .map((label) => DropdownMenuItem(
                                  child: Text(label['id'].toString()),
                                  value: label['id'],
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value;
                            _regFormModel.gender = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        style: Theme.of(context).textTheme.caption,
                        decoration: InputDecoration(
                            labelText: 'Date of Birth',
                            errorStyle: TextStyle(fontSize: 12)),
                        controller: dateController,
                        validator: (value) {
                          if (value == '') {
                            return 'Required Field';
                          }
                          return null;
                        },
                        readOnly: true,
                        onTap: () {
                          // FocusScope.of(context).requestFocus(new FocusNode());
                          _birthDatePicker();
                        },
                        onSaved: (value) =>
                            _regFormModel.dateOfBirth = dateController.text,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        style: Theme.of(context).textTheme.caption,
                        decoration: InputDecoration(
                            labelText: 'Current Address',
                            errorStyle: TextStyle(fontSize: 12)),
                        validator: (value) {
                          if (value == '') {
                            return 'Required Field';
                          }
                          return null;
                        },
                        onSaved: (value) =>
                            _regFormModel.currentAddress = value,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        focusNode: _focusNode,
                        style: Theme.of(context).textTheme.caption,
                        decoration: InputDecoration(
                            labelText: 'Permanent Address',
                            errorStyle: TextStyle(fontSize: 12)),
                        validator: (value) {
                          if (value == '') {
                            return 'Required Field';
                          }
                          return null;
                        },
                        onSaved: (value) =>
                            _regFormModel.permanentAddress = value,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DropdownButtonFormField<Class>(
                        style: Theme.of(context).textTheme.caption,
                        value: _selectedClass,
                        decoration: InputDecoration(
                            labelText: '--Select Class--',
                            labelStyle: Theme.of(context).textTheme.caption,
                            errorStyle: TextStyle(fontSize: 12)),
                        validator: (value) {
                          if (value == null) {
                            return 'Required Field';
                          }
                          return null;
                        },
                        items: data
                            .map((Class label) => DropdownMenuItem(
                                  child: Text('${label.className}'),
                                  value: label,
                                ))
                            .toList(),
                        onTap: () {
                          if (_focusNode.hasFocus) {
                            _focusNode.unfocus();
                          }
                        },
                        onChanged: (Class value) {
                          print("Selected class : ${value.classPrice}");
                          setState(() {
                            _selectedClass = value;
                            _regFormModel.classObj = value;
                            _regFormModel.classId = value.id;
                            selectedClassGradeList = value.gradeFees;
                            if (selectedClassGradeList != null &&
                                selectedClassGradeList.isNotEmpty) {
                              _regFormModel.selectedPlan =
                                  selectedClassGradeList[0];
                              print(
                                  "Init Fees : ${selectedClassGradeList[0].fees}");
                            }
                          });
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      if (selectedClassGradeList != null &&
                          selectedClassGradeList.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Plans :", style: TextStyle(fontSize: 18)),
                            Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                direction: Axis.horizontal,
                                children: mapIndexed(
                                    selectedClassGradeList,
                                    (index, grade) => Container(
                                            child: Row(children: [
                                          new Radio(
                                              activeColor: Theme.of(context)
                                                  .primaryColor,
                                              value: index,
                                              groupValue: _radioValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  _radioValue = value;
                                                  _regFormModel.selectedPlan =
                                                      grade;
                                                  print(grade.fees);
                                                });
                                              }),
                                          new Text(
                                            '${grade.termName}(${grade.fees})',
                                            style:
                                                new TextStyle(fontSize: 16.0),
                                          )
                                        ]))).toList()

                                ///,
                                ),
                          ],
                        ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Builder(
                          builder: (context) {
                            return StaggerAnimation(
                              titleButton: "PROCEED",
                              color: Theme.of(context).primaryColor,
                              buttonController: _registerButtonController.view,
                              onTap: () async {
                                _playAnimation();
                                await checkUser(emailTextController.text);
                                await _stopAnimation();
                                print("IS LOADING : $isLoading");
                                if (!isLoading) {
                                  if (_formKey.currentState.validate()) {
                                    _formKey.currentState.save();

                                    // checkUser(emailTextController.text);
                                    var json = this._regFormModel.toJson();
                                    print(
                                        "CLASS OBJ INSTANCE : ${this._regFormModel.classObj}");
                                    print("REGISTER DATA: $json");

                                    // userRegistration(context, this._regFormModel);
                                    Navigator.pushNamed(context, '/payment',
                                        arguments: this._regFormModel);
                                  }
                                }
                              },
                            );
                            // return RaisedButton(
                            //   onPressed: () {
                            //     // Validate returns true if the form is valid, or false
                            //     // otherwise.
                            //     if (_formKey.currentState.validate()) {
                            //       _formKey.currentState.save();
                            //       // If the form is valid, display a Snackbar.
                            //       var json = this._regFormModel.toJson();
                            //       print(
                            //           "CLASS OBJ INSTANCE : ${this._regFormModel.classObj}");
                            //       print("REGISTER DATA: $json");

                            //       userRegistration(context, this._regFormModel);
                            //       // Navigator.pushNamed(context, '/payment',
                            //       //     arguments: this._regFormModel);
                            //     }
                            //   },
                            //   color: Color.fromRGBO(10, 29, 150, 1),
                            //   shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(20)),
                            //   child: Padding(
                            //     padding: const EdgeInsets.all(12.0),
                            //     child: Text('Make Payment',
                            //         style: TextStyle(
                            //             fontSize: 20, color: Colors.white)),
                            //   ),
                            // );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
