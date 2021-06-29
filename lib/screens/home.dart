import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strings/strings.dart';
import 'dart:core';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import '../models/user_model.dart';
import '../models/meeting.dart';
import '../services/meeting.dart';
import '../widgets/common/webview.dart';
import '../widgets/common/drawer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  User user;
  MeetingService meetingService;
  List<Meeting> meetings = [];
  String meetingUrl;
  final int HOUR = 12;
  bool isEnabled = false;

  @override
  void initState() {
    meetingService = MeetingService();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    user = Provider.of<UserModel>(context).user;
    super.didChangeDependencies();
  }

  Future<void> joinMeeting(BuildContext context, int id, int meetingId) async {
    var cameraPermissionStatus = await Permission.camera.status;
    var microphonePermissionStatus = await Permission.microphone.status;

    print("Camera Permission : $cameraPermissionStatus");
    print("Microphone permission : $microphonePermissionStatus");

    if (!cameraPermissionStatus.isGranted) {
      await Permission.camera.request();
    }
    if (!microphonePermissionStatus.isGranted) {
      await Permission.microphone.request();
    }

    meetingUrl =
        await meetingService.getMeetingUrl(id: id, meetingId: meetingId);

    if (meetingUrl == null) {
      var snackBar = SnackBar(
          elevation: 4.0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.white,
          content: Text(
            "Meeting is not started yet. Please wait...",
            style: TextStyle(fontSize: 20.0, color: Colors.black),
          ));
      Scaffold.of(context).showSnackBar(snackBar);
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                OpenWebView(url: meetingUrl, title: 'Meeting'),
          ));
    }
  }

  dynamic getConvertedTime(String startTime, String endTime) {
    int startHr, startMin, endHr, endMin;
    String convertedStartTime;
    String convertedEndTime;

    if (startTime != null) {
      startHr = int.parse(startTime.split(':')[0]);
      startMin = int.parse(startTime.split(':')[1]);
      int hrStart = startHr > HOUR ? startHr - HOUR : startHr;
      String startPeriod = startHr > 12 ? "pm" : "am";
      convertedStartTime =
          '${hrStart.toString().padLeft(2, "0")}:${startMin.toString().padLeft(2, "0")}$startPeriod';
    }
    if (endTime != null) {
      endHr = int.parse(endTime.split(':')[0]);
      endMin = int.parse(endTime.split(':')[1]);
      int hrEnd = endHr > HOUR ? endHr - HOUR : endHr;
      String endPeriod = endHr > 12 ? "pm" : "am";
      convertedEndTime =
          '${hrEnd.toString().padLeft(2, "0")}:${endMin.toString().padLeft(2, "0")}$endPeriod';
    }

    var convertedTime = {
      'startTime': convertedStartTime,
      'endTime': convertedEndTime
    };
    return convertedTime;
  }

  @override
  Widget build(BuildContext context) {
    print("USER HOME : $user");
    return Scaffold(
        backgroundColor: Theme.of(context).accentColor,
        appBar: AppBar(
          elevation: 0,
          title: Text('MEETINGS'),
        ),
        drawer: Consumer<UserModel>(builder: (context, model, child) {
          return drawer(model.user, context);
        }),
        body: FutureBuilder(
            future: meetingService.getMeeting(userId: user.id),
            builder: (context, AsyncSnapshot snapshot) {
              var data = snapshot.data;
              print("MEETING DATA : $data");
              print(data.runtimeType);
              if (!snapshot.hasData) {
                return Center(
                    child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColor,
                ));
              } else if (data != null && data.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    child: Center(
                        child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                            "Either there is no meeting schedule or your account has not been activated yet",
                            style:
                                TextStyle(fontSize: 22, color: Colors.black)),
                      ),
                    )),
                  ),
                );
              } else {
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      Meeting meeting = data[index];
                      var timeObj =
                          getConvertedTime(meeting.startTime, meeting.endTime);

                      String dateStartTimeString =
                          '${meeting.date} ${meeting.startTime ?? ''}';
                      String dateEndTimeString =
                          '${meeting.date} ${meeting.endTime ?? ''}';
                      DateTime startTimeStamp =
                          DateTime.parse(dateStartTimeString.trim());
                      DateTime endTimeStamp =
                          DateTime.parse(dateEndTimeString.trim());
                      meeting.isEnable = false;

                      DateTime _currentDate = DateTime.now();
                      if (startTimeStamp.isBefore(_currentDate) &&
                          endTimeStamp.isAfter(_currentDate)) {
                        meeting.isEnable = true;
                      }

                      return Padding(
                        padding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
                        child: Container(
                          child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              color: Colors.white,
                              elevation: 6.0,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20.0, 15, 0, 0),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 8, 8, 0),
                                        child: Row(
                                          // mainAxisAlignment:
                                          //     MainAxisAlignment.start,
                                          // crossAxisAlignment:
                                          //     CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Flexible(
                                              child: Container(
                                                child: Text(
                                                    capitalize(meeting.title),
                                                    style: TextStyle(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 8, 8, 0),
                                        child: Row(
                                          children: <Widget>[
                                            Flexible(
                                              child: Container(
                                                child: Text(
                                                    'Description : ${meeting.description}',
                                                    style: TextStyle(
                                                        fontSize: 18)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // SizedBox(height: 15.0),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 8, 8, 0),
                                        child: Row(
                                          // mainAxisAlignment:
                                          //     MainAxisAlignment.spaceBetween,
                                          // crossAxisAlignment:
                                          //     CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              child: Flexible(
                                                fit: FlexFit.tight,
                                                child: Text(
                                                    'Subject : ${meeting.subjectName} ',
                                                    style: TextStyle(
                                                        fontSize: 18)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 8, 8, 0),
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                                'Teacher: ${meeting.teacherName}',
                                                style: TextStyle(fontSize: 18)),
                                          ],
                                        ),
                                      ),
                                      // SizedBox(height: 15.0),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 8, 8, 0),
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                                'Timing: ${timeObj['startTime'] ?? ''} - ${timeObj['endTime'] ?? ''}',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ],
                                        ),
                                      ),
                                      // SizedBox(height: 15.0),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 8, 8, 0),
                                        child: Row(
                                          children: <Widget>[
                                            Text("Date : ${meeting.date}",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ],
                                        ),
                                      ),
                                      if (meeting.className != '')
                                        Wrap(
                                            alignment: WrapAlignment.start,
                                            direction: Axis.horizontal,
                                            // textDirection: TextDirection.ltr,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 8, 8, 0),
                                                child: Row(
                                                  children: <Widget>[
                                                    Text("Classes : ",
                                                        style: TextStyle(
                                                            fontSize: 18)),
                                                  ],
                                                ),
                                              ),
                                              ...meeting.className
                                                  .split(',')
                                                  .map((name) => Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                10, 8, 8, 8),
                                                        child: Container(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(name),
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              // color: Color
                                                              //     .fromRGBO(
                                                              //         10,
                                                              //         29,
                                                              //         150,
                                                              //         1),
                                                            ),
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    const Radius
                                                                            .circular(
                                                                        25.0)),
                                                            color: Colors.white,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors
                                                                      .black38,
                                                                  blurRadius:
                                                                      5.0, // soften the shadow
                                                                  spreadRadius:
                                                                      0.8, //extend the shadow
                                                                  offset:
                                                                      Offset(
                                                                    2.0, // Move to right 10  horizontally
                                                                    2.0, // Move to bottom 10 Vertically
                                                                  )),
                                                            ],
                                                          ),
                                                        ),
                                                      ))
                                            ]),
                                      FlatButton(
                                          onPressed: () async {
                                            if (!meeting.isEnable) {
                                              Scaffold.of(context)
                                                  .showSnackBar(new SnackBar(
                                                elevation: 4.0,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .primaryColor,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                duration: Duration(seconds: 3),
                                                content: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                      "Meeting not started yet. Please wait...",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.black)),
                                                ),
                                              ));
                                            } else {
                                              await joinMeeting(
                                                  context, user.id, meeting.id);
                                            }
                                          },
                                          child: Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 8, 8, 10),
                                              width: 120,
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.black38,
                                                        blurRadius:
                                                            5.0, // soften the shadow
                                                        spreadRadius:
                                                            0.8, //extend the shadow
                                                        offset: Offset(
                                                          3.0, // Move to right 10  horizontally
                                                          3.0, // Move to bottom 10 Vertically
                                                        ))
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  // color: Color.fromRGBO(
                                                  //     10, 29, 150, 1)
                                                  color: meeting.isEnable
                                                      ? Theme.of(context)
                                                          .primaryColor
                                                      : Colors.deepOrange[300]),
                                              child: Center(
                                                child: Text(
                                                  "ATTEND",
                                                  style: TextStyle(
                                                      letterSpacing: 1,
                                                      fontSize: 20,
                                                      color: Colors.white),
                                                ),
                                              ))),
                                      SizedBox(height: 10)
                                    ]),
                              )),
                        ),
                      );
                    });
              }
            }));
  }
}
