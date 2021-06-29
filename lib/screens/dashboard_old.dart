import 'package:act_class/widgets/common/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../models/user.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  User user;
  @override
  void didChangeDependencies() {
    user = Provider.of<UserModel>(context).user;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print("DASHBOARD : $user");
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      drawer: drawer(user, context),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          // padding: EdgeInsets.all(10),
          child: Center(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 10,
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
                        child: Text(
                          "Name :",
                          style: Theme.of(context).textTheme.caption,
                          textAlign: TextAlign.end,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          " ${user.name}",
                          style: Theme.of(context).textTheme.bodyText2,
                          textAlign: TextAlign.start,
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
                        child: Text(
                          "Email :",
                          textAlign: TextAlign.end,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          " ${user.email}",
                          style: Theme.of(context).textTheme.bodyText2,
                          textAlign: TextAlign.start,
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
                        child: Text(
                          "Roll Number :",
                          textAlign: TextAlign.end,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          " ${user.details.rollNumber.toString()}",
                          style: Theme.of(context).textTheme.bodyText2,
                          textAlign: TextAlign.start,
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
                        child: Text(
                          "Phone :",
                          textAlign: TextAlign.end,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          " ${user.details.phone}",
                          style: Theme.of(context).textTheme.bodyText2,
                          textAlign: TextAlign.start,
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
                        child: Text(
                          "Gender :",
                          textAlign: TextAlign.end,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          " ${user.details.gender}",
                          style: Theme.of(context).textTheme.bodyText2,
                          textAlign: TextAlign.start,
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
                        child: Text(
                          "Date Of Birth :",
                          textAlign: TextAlign.end,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          " ${user.details.dateofbirth}",
                          style: Theme.of(context).textTheme.bodyText2,
                          textAlign: TextAlign.start,
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
                        child: Text(
                          "Current Address :",
                          textAlign: TextAlign.end,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          " ${user.details.currentAddress}",
                          style: Theme.of(context).textTheme.bodyText2,
                          textAlign: TextAlign.start,
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
                        child: Text(
                          "Permanent Address :",
                          textAlign: TextAlign.end,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          " ${user.details.permanentAddress}",
                          style: Theme.of(context).textTheme.bodyText2,
                          textAlign: TextAlign.start,
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
                        child: Text(
                          "Subscription Date :",
                          textAlign: TextAlign.end,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          " ${user.details.subscriptionDate}",
                          style: Theme.of(context).textTheme.bodyText2,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Expanded(
                  //       child: Text(
                  //         "Class :",
                  //         textAlign: TextAlign.end,
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: Text(
                  //         " ${user.details.selectedClass}",
                  //         style: Theme.of(context).textTheme.bodyText2,
                  //         textAlign: TextAlign.start,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Expanded(
                  //       child: Text(
                  //         "Student Parent :",
                  //         textAlign: TextAlign.end,
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: Text(
                  //         " ${user.details.parentName}",
                  //         style: Theme.of(context).textTheme.bodyText2,
                  //         textAlign: TextAlign.start,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Expanded(
                  //       child: Text(
                  //         "Parent Email :",
                  //         textAlign: TextAlign.end,
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: Text(
                  //         " ${user.parentEmail}",
                  //         style: Theme.of(context).textTheme.bodyText2,
                  //         textAlign: TextAlign.start,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Expanded(
                  //       child: Text(
                  //         "Parent Phone :",
                  //         textAlign: TextAlign.end,
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: Text(
                  //         " ${user.parentPhone}",
                  //         style: Theme.of(context).textTheme.bodyText2,
                  //         textAlign: TextAlign.start,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Expanded(
                  //       child: Text(
                  //         "Parent Address :",
                  //         textAlign: TextAlign.end,
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: Text(
                  //         " ${user.parentAddress}",
                  //         style: Theme.of(context).textTheme.bodyText2,
                  //         textAlign: TextAlign.start,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
