import 'package:act_class/widgets/common/drawer.dart';
import 'dart:convert';
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
        title: Text("DASHBOARD"),
      ),
      drawer: drawer(user, context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Container(
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
            SizedBox(
              height: 10,
            ),
            Text(
              "Welcome",
              style: Theme.of(context).textTheme.subtitle2,
            ),
            Text("Mr. ${user.name}",
                style: Theme.of(context).textTheme.subtitle1),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: GridView.count(
                  padding: EdgeInsets.all(12),
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/home');
                      },
                      child: Card(
                        color: Theme.of(context).primaryColor,
                        child: Column(children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.group,
                              size: 80,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                          Text("MEETINGS",
                              style: Theme.of(context).textTheme.headline4)
                        ]),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/profile');
                      },
                      child: Card(
                        color: Theme.of(context).primaryColor,
                        child: Column(children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.person,
                              size: 80,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                          Text("PROFILE",
                              style: Theme.of(context).textTheme.headline4)
                        ]),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed('/changepassword');
                      },
                      child: Card(
                        color: Theme.of(context).primaryColor,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Icon(
                                  Icons.refresh,
                                  size: 80,
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                              Text("CHANGE",
                                  style: Theme.of(context).textTheme.headline4),
                              Text("PASSWORD",
                                  style: Theme.of(context).textTheme.headline4)
                            ]),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed('/transaction');
                      },
                      child: Card(
                        color: Theme.of(context).primaryColor,
                        child: Column(children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.payment,
                              size: 80,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                          Text("TRANSACTIONS",
                              style: Theme.of(context).textTheme.headline6)
                        ]),
                      ),
                    )
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
