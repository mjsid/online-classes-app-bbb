import 'dart:convert';
import 'package:strings/strings.dart';
import 'package:act_class/models/user.dart';
import 'package:act_class/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget drawer(User user, BuildContext context) {
  final double height = MediaQuery.of(context).size.height;
  return Drawer(
      child: ListView(
    children: <Widget>[
      UserAccountsDrawerHeader(
        decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        accountName: Text(
          capitalize(user.name),
          style: Theme.of(context).textTheme.headline4,
        ),
        accountEmail: Text(user.email),
        currentAccountPicture: CircleAvatar(
            backgroundColor: Theme.of(context).platform == TargetPlatform.iOS
                ? Color.fromRGBO(10, 29, 150, 1)
                : Colors.white,
            backgroundImage: MemoryImage(base64Decode(user.pic))),
      ),
      ListTile(
        leading: Icon(Icons.person, color: Colors.black),
        title: Text("Profile", style: Theme.of(context).textTheme.caption),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.of(context).pushReplacementNamed('/profile');
        },
      ),
      Divider(
        height: 2.0,
        thickness: 2.0,
      ),
      ListTile(
        leading: Icon(Icons.dashboard, color: Colors.black),
        title: Text("Dashboard", style: Theme.of(context).textTheme.caption),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.of(context).pushReplacementNamed('/dashboard');
        },
      ),
      Divider(
        height: 2.0,
        thickness: 2.0,
      ),
      ListTile(
        leading: Icon(Icons.group, color: Colors.black),
        title: Text("Meetings", style: Theme.of(context).textTheme.caption),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.of(context).pushReplacementNamed('/home');
        },
      ),
      Divider(
        height: 2.0,
        thickness: 2.0,
      ),
      ListTile(
        leading: Icon(Icons.payment, color: Colors.black),
        title: Text("Transactions", style: Theme.of(context).textTheme.caption),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          // Provider.of<UserModel>(context, listen: false).logout();
          Navigator.of(context).pushReplacementNamed('/transaction');
        },
      ),
      Divider(
        height: 2.0,
        thickness: 2.0,
      ),
      ListTile(
        leading: Icon(Icons.subscriptions, color: Colors.black),
        title:
            Text("Subscriptions", style: Theme.of(context).textTheme.caption),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          // Provider.of<UserModel>(context, listen: false).logout();
          Navigator.of(context).pushReplacementNamed('/subscription');
        },
      ),
      Divider(
        height: 2.0,
        thickness: 2.0,
      ),
      ListTile(
        leading: Icon(Icons.refresh, color: Colors.black),
        title:
            Text("Change Password", style: Theme.of(context).textTheme.caption),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          // Provider.of<UserModel>(context, listen: false).logout();
          Navigator.of(context).pushReplacementNamed('/changepassword');
        },
      ),
      Divider(
        height: 2.0,
        thickness: 2.0,
      ),
      ListTile(
        leading: Icon(Icons.exit_to_app, color: Colors.black),
        title: Text("LogOut", style: Theme.of(context).textTheme.caption),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          Provider.of<UserModel>(context, listen: false).logout();
          Navigator.of(context).pushReplacementNamed('/login');
        },
      ),
    ],
  ));
}
