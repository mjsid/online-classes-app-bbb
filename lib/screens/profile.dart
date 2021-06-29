import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:strings/strings.dart';
import 'package:act_class/widgets/common/login_animation.dart';
import 'package:act_class/services/registration.dart';
import 'package:act_class/widgets/common/drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  User user;
  UserModel _userModel;
  bool _isImagePicked = false;
  bool _isNameChanged = false;
  bool _isPhoneChanged = false;
  bool _isGenderChanged = false;
  bool _isDateOfBirthChanged = false;
  bool _isCurrentAddressChanged = false;
  bool _isPermanentAddressChanged = false;
  bool isLoading = false;
  String base64Image;
  String _selectedGender;
  String _selectedDate;
  AnimationController _controller;
  AnimationController _saveController;
  AnimationController _saveButtonController;
  Animation<double> _animation;
  Animation<double> _saveAnimation;
  bool inNameEditMode = false;
  bool inPhoneEditMode = false;
  bool inGenderEditMode = false;
  bool inDateEditMode = false;
  bool inCurrentAddressEditMode = false;
  bool inPermanentAddressEditMode = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController currentAddressController = TextEditingController();
  TextEditingController permanentAddressController = TextEditingController();
  RegistrationService _register = RegistrationService();

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _saveController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _saveButtonController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _saveAnimation = Tween(begin: 0.0, end: 1.0).animate(_saveController);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      setState(() {
        isLoading = true;
      });
      await _saveButtonController.forward();
    } on TickerCanceled {
      FlutterError('[_playAnimation] error');
    }
  }

  Future<Null> _stopAnimation() async {
    try {
      await _saveButtonController.reverse();
      setState(() {
        isLoading = false;
      });
    } on TickerCanceled {
      FlutterError('[_stopAnimation] error');
    }
  }

  @override
  void didChangeDependencies() {
    user = Provider.of<UserModel>(context).user;
    _userModel = Provider.of<UserModel>(context);
    super.didChangeDependencies();
  }

  Future<void> getImageCamera() async {
    try {
      final _file = await _picker.getImage(source: ImageSource.camera);
      if (_file == null) return;
      base64Image = base64Encode(File(_file.path).readAsBytesSync());
      setState(() {
        _isImagePicked = true;
        _userModel.setImage(base64Image);
      });

      print("BASE IMAGE : $base64Image");
    } catch (e) {
      print("Issue in image picking from camera");
      print(e.toString());
    }
  }

  Future<void> getImageGallery() async {
    try {
      final _file = await _picker.getImage(source: ImageSource.gallery);
      if (_file == null) return;
      print("HERE");
      base64Image = base64Encode(File(_file.path).readAsBytesSync());
      setState(() {
        _isImagePicked = true;
        _userModel.setImage(base64Image);
      });

      print("BASE IMAGE : $base64Image");
    } catch (e) {
      print("Issue in image picking from camera");
      print(e.toString());
    }
  }

  Future<void> selectImage(BuildContext context) async {
    print("Tapped");
    showModalBottomSheet(
        backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        elevation: 4.0,
        context: context,
        builder: (context) => Container(
              height: 120,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        print("Camera");
                        getImageCamera();
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.camera_alt),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Camera",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(thickness: 2),
                    InkWell(
                      onTap: () {
                        print("Gallery");
                        getImageGallery();
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.image),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                                Text("Gallery", style: TextStyle(fontSize: 20)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }

  void toggleNameEditMode() {
    if (inNameEditMode) {
      setState(() {
        inNameEditMode = false;
      });
    } else {
      nameController.text = user.name;
      setState(() {
        inNameEditMode = true;
      });
    }
  }

  void togglePhoneEditMode() {
    if (inPhoneEditMode) {
      setState(() {
        inPhoneEditMode = false;
      });
    } else {
      phoneController.text = user.details.phone;
      setState(() {
        inPhoneEditMode = true;
      });
    }
  }

  void toggleGenderEditMode() {
    if (inGenderEditMode) {
      setState(() {
        inGenderEditMode = false;
      });
    } else {
      // _selectedGender = user.details.gender;
      setState(() {
        inGenderEditMode = true;
      });
    }
  }

  void toggleDateEditMode() {
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
          _selectedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          print("DATE : $_selectedDate");
          if (_selectedDate != user.details.dateofbirth) {
            submitDateOfBirthData(_selectedDate);
          }
        });
        // dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
      }
    });
  }

  void toggleCurrentAddressEditMode() {
    if (inCurrentAddressEditMode) {
      setState(() {
        inCurrentAddressEditMode = false;
      });
    } else {
      currentAddressController.text = user.details.currentAddress;
      setState(() {
        inCurrentAddressEditMode = true;
      });
    }
  }

  void togglepermanentAddressEditMode() {
    if (inPermanentAddressEditMode) {
      setState(() {
        inPermanentAddressEditMode = false;
      });
    } else {
      permanentAddressController.text = user.details.permanentAddress;
      setState(() {
        inPermanentAddressEditMode = true;
      });
    }
  }

  void submitNameData() {
    setState(() {
      if (nameController.text != user.name) {
        _saveController.forward();
        _isNameChanged = true;
        _userModel.setUserName(nameController.text);
      }
    });
    toggleNameEditMode();
  }

  void submitPhoneData() {
    setState(() {
      if (phoneController.text != user.details.phone) {
        _saveController.forward();
        _isPhoneChanged = true;
        _userModel.setPhoneNumber(phoneController.text);
      }
    });
    togglePhoneEditMode();
  }

  void submitCurrentAddressData() {
    setState(() {
      if (currentAddressController.text != user.details.currentAddress) {
        _saveController.forward();
        _isCurrentAddressChanged = true;
        _userModel.setCurrentAddress(currentAddressController.text);
      }
    });
    toggleCurrentAddressEditMode();
  }

  void submitPermanentAddressData() {
    setState(() {
      if (permanentAddressController.text != user.details.permanentAddress) {
        _saveController.forward();
        _isPermanentAddressChanged = true;
        _userModel.setPermanentAddress(permanentAddressController.text);
      }
    });
    togglepermanentAddressEditMode();
  }

  void submitGenderData() {
    if (_selectedGender == null) {
    } else {
      setState(() {
        if (_selectedGender != user.details.gender) {
          _saveController.forward();
          _isGenderChanged = true;
          _userModel.setGender(_selectedGender);
        }
      });
    }
    toggleGenderEditMode();
  }

  void submitDateOfBirthData(String date) {
    print("DATE : $date");
    setState(() {
      if (date != user.details.dateofbirth) {
        _saveController.forward();
        _isDateOfBirthChanged = true;
        _userModel.setDateOfBirth(date);
      }
    });
  }

  Future<void> saveChangesToBackend() async {
    String _userName = _isNameChanged ? nameController.text : user.name;
    String _phoneNumber =
        _isPhoneChanged ? phoneController.text : user.details.phone;
    String _profilePicture = _isImagePicked ? base64Image : '';

    Map<String, dynamic> json = Map();
    json['id'] = user.id;
    json['name'] = _userName;
    json['phone'] = _phoneNumber;
    json['gender'] = user.details.gender;
    json['dateofbirth'] = user.details.dateofbirth;
    json['current_address'] = user.details.currentAddress;
    json['permanent_address'] = user.details.permanentAddress;

    if (_profilePicture != '') json['profile_picture'] = _profilePicture;

    print("Change profile data: $json");

    bool success = await _register.changeProfile(json);
    if (success) {
      Fluttertoast.showToast(
          msg: "Profile updated successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Theme.of(context).primaryColor,
          textColor: Colors.black,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "Failed to Update profile",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Theme.of(context).primaryColor,
          textColor: Colors.red,
          fontSize: 16.0);
    }

    setState(() {
      _isPhoneChanged = false;
      _isNameChanged = false;
      _isImagePicked = false;
      _isGenderChanged = false;
      _isDateOfBirthChanged = false;
      _isCurrentAddressChanged = false;
      _isPermanentAddressChanged = false;
      inPhoneEditMode = false;
      inNameEditMode = false;
      inGenderEditMode = false;
      inCurrentAddressEditMode = false;
      inPermanentAddressEditMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    print("Profile : $user");
    Size size = MediaQuery.of(context).size;
    double headerHeight = size.height * 0.25;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("PROFILE"),
      ),
      drawer: drawer(user, context),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Positioned(
              left: 0,
              right: 0,
              height: headerHeight,
              child: Container(
                height: headerHeight,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Positioned(
              left: 5,
              right: 5,
              top: size.height * 0.08,
              bottom: 0,
              child: FadeTransition(
                opacity: _animation,
                child: Card(
                  color: Theme.of(context).accentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 120),
                    child: SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "Name :",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Row(children: [
                                  inNameEditMode
                                      ? Flexible(
                                          child: TextField(
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2,
                                            controller: nameController,
                                            onSubmitted: (_) =>
                                                submitNameData(),
                                          ),
                                        )
                                      : Text(capitalize(user.name),
                                          textAlign: TextAlign.start,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2),
                                  inNameEditMode
                                      ? IconButton(
                                          icon: Icon(Icons.done),
                                          color: Theme.of(context).errorColor,
                                          onPressed: submitNameData,
                                        )
                                      : IconButton(
                                          icon: Icon(Icons.edit),
                                          color: Theme.of(context).errorColor,
                                          onPressed: toggleNameEditMode,
                                        ),
                                ]),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "Email :",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(" ${user.email}",
                                    textAlign: TextAlign.start,
                                    style:
                                        Theme.of(context).textTheme.bodyText2),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "Roll Number :",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(" ${user.details.rollNumber}",
                                    textAlign: TextAlign.start,
                                    style:
                                        Theme.of(context).textTheme.bodyText2),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "Phone :",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Row(children: [
                                  inPhoneEditMode
                                      ? Flexible(
                                          child: TextField(
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2,
                                            controller: phoneController,
                                            // decoration: InputDecoration(
                                            // ),
                                            onSubmitted: (_) =>
                                                submitPhoneData(),
                                          ),
                                        )
                                      : Text(" ${user.details.phone}",
                                          textAlign: TextAlign.start,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2),
                                  inPhoneEditMode
                                      ? IconButton(
                                          icon: Icon(Icons.done),
                                          color: Theme.of(context).errorColor,
                                          onPressed: submitPhoneData,
                                        )
                                      : IconButton(
                                          icon: Icon(Icons.edit),
                                          color: Theme.of(context).errorColor,
                                          onPressed: togglePhoneEditMode,
                                        ),
                                ]),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "Gender :",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Row(
                                  children: [
                                    inGenderEditMode
                                        ? Container(
                                            height: 80,
                                            width: 120,
                                            child: DropdownButtonFormField(
                                              autovalidate: true,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption,
                                              // autovalidate: true,
                                              value: _selectedGender,
                                              decoration: InputDecoration(
                                                  labelText: '--Gender--',
                                                  labelStyle: Theme.of(context)
                                                      .textTheme
                                                      .caption,
                                                  errorStyle:
                                                      TextStyle(fontSize: 12)),
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
                                                  .map((label) =>
                                                      DropdownMenuItem(
                                                        child: Text(label['id']
                                                            .toString()),
                                                        value: label['id'],
                                                      ))
                                                  .toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  _selectedGender = value;
                                                });
                                              },
                                            ),
                                          )
                                        : Text(" ${user.details.gender}",
                                            textAlign: TextAlign.start,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2),
                                    inGenderEditMode
                                        ? IconButton(
                                            icon: Icon(Icons.done),
                                            color: Theme.of(context).errorColor,
                                            onPressed: submitGenderData,
                                          )
                                        : IconButton(
                                            icon: Icon(Icons.edit),
                                            color: Theme.of(context).errorColor,
                                            onPressed: toggleGenderEditMode,
                                          ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "Date Of Birth :",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Row(
                                  children: [
                                    Text(" ${user.details.dateofbirth}",
                                        textAlign: TextAlign.start,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2),
                                    // inDateEditMode
                                    //     ? Container()
                                    //     :
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      color: Theme.of(context).errorColor,
                                      onPressed: toggleDateEditMode,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "Current Address :",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 2,
                                  child: Row(children: [
                                    inCurrentAddressEditMode
                                        ? Flexible(
                                            child: TextField(
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2,
                                              controller:
                                                  currentAddressController,
                                              // decoration: InputDecoration(
                                              // ),
                                              onSubmitted: (_) =>
                                                  submitCurrentAddressData(),
                                            ),
                                          )
                                        : Text(
                                            " ${user.details.currentAddress}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2,
                                            textAlign: TextAlign.start,
                                          ),
                                    inCurrentAddressEditMode
                                        ? IconButton(
                                            icon: Icon(Icons.done),
                                            color: Theme.of(context).errorColor,
                                            onPressed: submitCurrentAddressData,
                                          )
                                        : IconButton(
                                            icon: Icon(Icons.edit),
                                            color: Theme.of(context).errorColor,
                                            onPressed:
                                                toggleCurrentAddressEditMode,
                                          ),
                                  ]))
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "Permanent Address :",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 2,
                                  child: Row(children: [
                                    inPermanentAddressEditMode
                                        ? Flexible(
                                            child: TextField(
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2,
                                              controller:
                                                  permanentAddressController,
                                              // decoration: InputDecoration(
                                              // ),
                                              onSubmitted: (_) =>
                                                  submitPermanentAddressData(),
                                            ),
                                          )
                                        : Text(
                                            " ${user.details.permanentAddress}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2,
                                            textAlign: TextAlign.start,
                                          ),
                                    inPermanentAddressEditMode
                                        ? IconButton(
                                            icon: Icon(Icons.done),
                                            color: Theme.of(context).errorColor,
                                            onPressed:
                                                submitPermanentAddressData,
                                          )
                                        : IconButton(
                                            icon: Icon(Icons.edit),
                                            color: Theme.of(context).errorColor,
                                            onPressed:
                                                togglepermanentAddressEditMode,
                                          ),
                                  ]))
                            ],
                          ),
                          SizedBox(height: 40),
                        ])),
                  ),
                ),
              ),
            ),
            Positioned(
                top: size.height * 0.001,
                left: size.width * 0.3,
                child: FadeTransition(
                  opacity: _animation,
                  child: Builder(
                    builder: (BuildContext contextBuilder) => GestureDetector(
                      onTap: () async => await selectImage(contextBuilder),
                      child: Container(
                        padding: const EdgeInsets.all(1.0), // borde width
                        decoration: new BoxDecoration(
                          color: Theme.of(context).primaryColor, // border color
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          backgroundImage: MemoryImage(base64Decode(user.pic)),
                          //  _isImagePicked
                          //     ? FileImage(File(_imageFile.path))
                          //     : NetworkImage(user.pic),
                          backgroundColor: Colors.white,
                          radius: 80,
                        ),
                      ),
                    ),
                  ),
                )),
            if (_isImagePicked ||
                _isNameChanged ||
                _isPhoneChanged ||
                _isGenderChanged ||
                _isDateOfBirthChanged ||
                _isCurrentAddressChanged ||
                _isPermanentAddressChanged)
              Positioned(
                right: 10,
                bottom: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: FadeTransition(
                        opacity: _saveAnimation,
                        child: StaggerAnimation(
                            width: 100,
                            color: Theme.of(context).primaryColor,
                            titleButton: "SAVE",
                            buttonController: _saveButtonController?.view,
                            onTap: () async {
                              _playAnimation();
                              await saveChangesToBackend();
                              // await Future.delayed(
                              //     Duration(seconds: 2));
                              _stopAnimation();
                            }),
                      ),
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
