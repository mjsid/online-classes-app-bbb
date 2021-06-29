import 'package:act_class/screens/profile.dart';
import 'package:act_class/screens/dashboard.dart';
import 'package:act_class/screens/registration.dart';
import 'package:act_class/screens/subscription.dart';
import 'package:act_class/screens/transaction_history.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'widgets/firebase/firebase_cloud_messaging_wrapper.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/login.dart';
import './models/user_model.dart';
import './screens/home.dart';
import './screens/payment.dart';
import './screens/change_password.dart';
import './common/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>
    implements FirebaseCloudMessagingDelegate {
  final _user = UserModel();
  bool isLoggedIn;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    secureScreen();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    FirebaseCloudMessagagingWrapper()
      ..init()
      ..delegate = this;
  }

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  void _navigateToMeetingPage() {
    print("Going to meetings");
    Navigator.pushReplacementNamed(context, '/home');
  }

  Future<void> showLocalNotification(Map<String, dynamic> message) async {
    print("Local notification : $message");
    Map<String, dynamic> notification;
    Map<String, dynamic> data;
    try {
      notification = Map<String, dynamic>.from(message['notification']);
      data = Map<String, dynamic>.from(message['data']);
    } catch (e) {
      print("notification");
      print(e.toString());
    }
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      notification['title'],
      notification['body'],
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  Future onSelectNotification(String payload) async {
    print("Onselectnotification");
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  @override
  onLaunch(Map<String, dynamic> message) {
    print("On launch : $message");
    _navigateToMeetingPage();
  }

  @override
  onMessage(Map<String, dynamic> message) async {
    print("On message : $message");
    await showLocalNotification(message);
  }

  @override
  onResume(Map<String, dynamic> message) {
    print("On resume : $message");
    _navigateToMeetingPage();
    // _saveMessage(message);
  }

  Future<void> checkUserLoggedIn() async {
    try {
      User user = await _user.getUser();
      setState(() {
        isLoggedIn = user == null ? false : user.loggedIn;
      });
    } catch (e) {
      print("In checkUserLoggedIn");
      print(e.toString());
    }
  }

  @override
  void didChangeDependencies() async {
    await checkUserLoggedIn();
    super.didChangeDependencies();
  }

  Widget getLandingPage() {
    Widget widget;
    if (isLoggedIn == null) {
      widget = Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.deepOrangeAccent[700],
        ),
      );
    } else if (!isLoggedIn) {
      widget = Login();
    } else {
      widget = HomePage();
    }

    return widget;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserModel>(
      create: (context) => _user,
      child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: themeData,
          routes: <String, WidgetBuilder>{
            '/login': (context) => Login(),
            '/home': (context) => HomePage(),
            '/dashboard': (context) => Dashboard(),
            '/register': (context) => Registration(),
            '/payment': (context) => Payment(),
            '/transaction': (context) => TransactionHistory(),
            '/profile': (context) => Profile(),
            '/changepassword': (context) => ChangePassword(),
            '/subscription': (context) => Subscription()
          },
          home: Scaffold(body: getLandingPage())),
    );
  }
}
