import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../models/user_registration.dart';
import '../models/class.dart';
import '../common/constants/payment_keys.dart';
import '../services/registration.dart';

class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  static const platform = const MethodChannel("razorpay_flutter");
  Razorpay razorpay;
  RegistrationService _registerService;
  UserRegistration register;
  int _amount;
  String _email;
  String _phone;
  String _class;
  String _termName;
  String _base64Image;
  int _termId;

  TextEditingController textEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _registerService = RegistrationService();

    razorpay = new Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }

  @override
  void didChangeDependencies() {
    register = ModalRoute.of(context).settings.arguments;
    GradeFee selectedPlan = register.selectedPlan;
    if (selectedPlan != null) {
      _amount = register.selectedPlan.fees;
      _termId = register.selectedPlan.termId;
      _termName = register.selectedPlan.termName;
    } else {
      _amount = int.parse(register.classObj.classPrice ?? "0");
    }

    // _amount = _amount == null ? register.classObj.classPrice : _amount;
    _email = register.email;
    _phone = register.phone;
    _class = register.classObj.className;

    super.didChangeDependencies();
  }

  Future<void> getBase64Image() async {
    final bytes = await rootBundle.load('assets/images/logo.png');
    var buffer = bytes.buffer;
    _base64Image = base64.encode(Uint8List.view(buffer));
    print("GOT IMAGE: $_base64Image");
  }

  Future<void> userRegistration(Map<String, dynamic> user) async {
    try {
      Map<String, dynamic> response =
          await _registerService.registerUser(user: user);
      print("RESPONSE : $response");
      if (response['success']) {
        Fluttertoast.showToast(
            msg: "User " + response['data']['name'] + " register successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Theme.of(context).primaryColor,
            textColor: Colors.white,
            fontSize: 18.0);

        sleep(const Duration(seconds: 3));
        Navigator.pushReplacementNamed(context, '/login');
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

    Map<String, dynamic> json = register.toJson();
    json['payment_id'] = _paymentId;
    json['order_id'] = _orderId == null ? '' : _orderId;
    json['term_id'] = _termId == null ? '' : _termId;
    json['amount'] = _amount;

    print("JSON : $json");

    // Fluttertoast.showToast(
    //   msg: "SUCCESS: " + response.paymentId + "\n Redirecting to login page...",
    //   toastLength: Toast.LENGTH_LONG,
    //   gravity: ToastGravity.CENTER,
    //   timeInSecForIosWeb: 3,
    // );

    sleep(const Duration(seconds: 3));

    userRegistration(json);
    // Navigator.pushReplacementNamed(context, '/login');
  }

  void handlerErrorFailure(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        timeInSecForIosWeb: 4);
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

    var options = {
      "key": _key,
      "amount": _amount * 100,
      'currency': 'INR',
      "name": "ATC",
      'image':
          "https://www.akashtech24.com/wp-content/uploads/2020/08/newlogoC500.png",
      "description": "Payment for $_class class subscription",
      "prefill": {"contact": _phone, "email": _email},
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
  Widget build(BuildContext context) {
    // final UserRegistration register = ModalRoute.of(context).settings.arguments;
    // _amount = register.selectedPlan.fees;
    // _email = register.email;
    // _phone = register.phone;
    // _class = register.classObj.className;
    print(register.classObj.classPrice);
    return Scaffold(
        appBar: AppBar(
          title: Text("PAYMENT"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text("Payment Details :",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "Class : ",
                                    style: TextStyle(fontSize: 20),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Text(register.classObj.className,
                                      style: TextStyle(fontSize: 20),
                                      textAlign: TextAlign.start),
                                )
                              ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                    child: Text("Plan : ",
                                        style: TextStyle(fontSize: 20),
                                        textAlign: TextAlign.end)),
                                SizedBox(
                                  width: 8,
                                ),
                                // Text(':', style: TextStyle(fontSize: 20)),
                                Expanded(
                                  child: Text(_termName ?? "Not Available",
                                      style: TextStyle(fontSize: 20),
                                      textAlign: TextAlign.start),
                                )
                              ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Text("Amount : ",
                                      style: TextStyle(fontSize: 20),
                                      textAlign: TextAlign.end),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Text('Rs. ${_amount.toString()}',
                                      style: TextStyle(fontSize: 20),
                                      textAlign: TextAlign.start),
                                )
                              ]),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Amount to pay : ",
                              style: TextStyle(fontSize: 18)),
                          SizedBox(
                            width: 8,
                          ),
                          Text('Rs. ${_amount.toString()}',
                              style: TextStyle(fontSize: 22))
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      RaisedButton(
                        elevation: 6.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        color: Theme.of(context).primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "PAY",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                        onPressed: () {
                          openCheckout();
                        },
                      )
                    ]),
                  ),
                )
              ],
            )));
  }
}
