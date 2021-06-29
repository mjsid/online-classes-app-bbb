import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:act_class/models/user_model.dart';
import 'package:act_class/widgets/common/drawer.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../common/constants/payment_keys.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/registration.dart';

class Subscription extends StatefulWidget {
  @override
  _SubscriptionState createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  User user;
  int _radioValue = 0;
  String _phoneNumber;
  String _email;
  List<History> history;
  List<Map<String, dynamic>> classData = [];
  Map<String, dynamic> selectedPlan;
  static const platform = const MethodChannel("razorpay_flutter");
  Razorpay razorpay;
  RegistrationService _registerService;

  @override
  void initState() {
    // _registerService = RegistrationService();

    razorpay = new Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);

    _registerService = RegistrationService();
    super.initState();
  }

  void saveSubscription(Map<String, dynamic> json) async {
    try {
      var response = await _registerService.getSubscription(json);
      print("RESPONSE : $response");
      if (response['success']) {
        Fluttertoast.showToast(
            msg: "Subscribed Successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Theme.of(context).primaryColor,
            textColor: Colors.white,
            fontSize: 18.0);

        sleep(const Duration(seconds: 3));
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      print("Unable to register user!!");
      print(e.toString());
      Fluttertoast.showToast(
          msg: "Unable to register user : " + e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Theme.of(context).accentColor,
          textColor: Colors.red,
          fontSize: 16.0);
    }
  }

  void handlerPaymentSuccess(PaymentSuccessResponse response) {
    print("PAYMENT SUCCESSFUL!!");
    String _paymentId = response.paymentId;
    String _orderId = response.orderId;
    print("Payment ID: ${response.paymentId}");
    print("Order ID: ${response.orderId}");

    Map<String, dynamic> json = Map();

    json['payment_id'] = _paymentId;
    json['order_id'] = _orderId == null ? '' : _orderId;
    // json['term_id'] = _termId == null ? '' : _termId;
    json['amount'] = selectedPlan['fees'];
    json['user_id'] = user.id;
    json['term_id'] = selectedPlan['term_id'];
    json['class_id'] = selectedPlan['grade_id'];
    json['amount'] = selectedPlan['fees'];
    json['class_name'] =
        selectedPlan['term_name']; //This need to be changed or deleted

    print("JSON : $json");
    saveSubscription(json);
  }

  void handlerErrorFailure(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: response.message, timeInSecForIosWeb: 4);
    print("PAYEMENT ERROR : ${response.code.toString()} ");
    // sleep(const Duration(seconds: 3));
  }

  void handlerExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIosWeb: 4);

    print("EXTERNAL WALLET : ${response.walletName}");
    // sleep(const Duration(seconds: 3));
  }

  void openCheckout() async {
    String _key;
    if (kProd) {
      _key = kRazorPay['prod'];
    } else {
      _key = kRazorPay['test'];
    }

    int _amount = selectedPlan['fees'];

    var options = {
      "key": _key,
      "amount": _amount * 100,
      'currency': 'INR',
      "name": "ATC",
      'image':
          "https://www.akashtech24.com/wp-content/uploads/2020/08/newlogoC500.png",
      "description":
          "Payment for ${selectedPlan['term_name']} class subscription",
      "prefill": {"contact": _phoneNumber, "email": _email},
      "external": {
        "wallets": ["paytm"]
      }
    };

    try {
      razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void didChangeDependencies() {
    user = Provider.of<UserModel>(context).user;
    history = user.history;
    _phoneNumber = user.details.phone;
    _email = user.email;
    getClassData();
    super.didChangeDependencies();
  }

  Future<void> getClassData() async {
    try {
      var response = await http.post(
          'https://live.akashtech24.com/api/checkclass',
          headers: {"Content-Type": "Application/json; charset=UTF-8"},
          body: convert.jsonEncode({"class_id": user.details.classId}));
      print("RESPONSE : ${response.body}");
      var jsonDecode = convert.jsonDecode(response.body);
      print("Class Response : $jsonDecode");
      if (jsonDecode['success']) {
        for (dynamic d in jsonDecode['data']) {
          classData.add(Map<String, dynamic>.from(d));
        }
        print("classData : $classData");
        setState(() {});
      }
    } catch (e) {
      print("Class Data");
      print(e.toString());
      rethrow;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("SUBSCRIPTIONS"),
        ),
        drawer: drawer(user, context),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 0, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Text(
                          "Your subscription expires on",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '${user.details.subscriptionDate}',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Flexible(
            //   child: ListView.builder(
            //       shrinkWrap: true,
            //       itemCount: history.length,
            //       itemBuilder: (context, index) {
            //         History history = user.history[index];
            //         print("HISTORY: $history");
            //         return Padding(
            //           padding: const EdgeInsets.fromLTRB(4, 5, 4, 0),
            //           child: Card(
            //             shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(20)),
            //             elevation: 4.0,
            //             child: Padding(
            //               padding: const EdgeInsets.all(12.0),
            //               child: Column(
            //                 children: <Widget>[
            //                   Row(
            //                     mainAxisAlignment:
            //                         MainAxisAlignment.spaceBetween,
            //                     children: <Widget>[
            //                       Text(
            //                         "Amount ",
            //                         style: TextStyle(fontSize: 18),
            //                       ),
            //                       Text(
            //                         history.amount?.toString() ?? '',
            //                         style: TextStyle(fontSize: 18),
            //                       )
            //                     ],
            //                   ),
            //                   Row(
            //                     mainAxisAlignment:
            //                         MainAxisAlignment.spaceBetween,
            //                     children: <Widget>[
            //                       Text(
            //                         "Class Name ",
            //                         style: TextStyle(fontSize: 18),
            //                       ),
            //                       Text(
            //                         history.className ?? '',
            //                         style: TextStyle(fontSize: 18),
            //                       )
            //                     ],
            //                   ),
            //                   Row(
            //                     mainAxisAlignment:
            //                         MainAxisAlignment.spaceBetween,
            //                     children: <Widget>[
            //                       Text(
            //                         "Plan ",
            //                         style: TextStyle(fontSize: 18),
            //                       ),
            //                       Text(
            //                         history.termName ?? '',
            //                         style: TextStyle(fontSize: 18),
            //                       )
            //                     ],
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ),
            //         );
            //       }),
            // ),
            Card(
              elevation: 4.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Renew Your Subscription",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Plans :", style: TextStyle(fontSize: 18)),
                  ),
                  Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      direction: Axis.horizontal,
                      children: mapIndexed(
                          classData,
                          (index, grade) => Container(
                                  child: Row(children: [
                                new Radio(
                                    activeColor: Theme.of(context).primaryColor,
                                    value: index,
                                    groupValue: _radioValue,
                                    onChanged: (value) {
                                      setState(() {
                                        _radioValue = value;
                                        selectedPlan = grade;
                                        print(grade['fees']);
                                      });
                                    }),
                                new Text(
                                  '${grade['term_name']}(${grade['fees']})',
                                  style: new TextStyle(fontSize: 16.0),
                                )
                              ]))).toList()

                      ///,
                      ),
                ],
              ),
            ),
            SizedBox(height: 20),
            RaisedButton(
              onPressed: () {
                openCheckout();
              },
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('Make Payment',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
            )
          ],
        ));
  }
}
