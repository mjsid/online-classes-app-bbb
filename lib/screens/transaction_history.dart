import 'package:flutter/material.dart';
import 'package:act_class/widgets/common/drawer.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';

class TransactionHistory extends StatefulWidget {
  @override
  _TransactionHistoryState createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  User user;
  @override
  void didChangeDependencies() {
    user = Provider.of<UserModel>(context).user;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TRANSACTIONS"),
      ),
      drawer: drawer(user, context),
      body: ListView.builder(
          itemCount: user.history.length,
          itemBuilder: (context, index) {
            History history = user.history[index];
            return Padding(
              padding: const EdgeInsets.fromLTRB(4, 5, 4, 0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Payment Id ",
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            history.paymentId ?? '',
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Amount ",
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            history.amount?.toString() ?? '',
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Class Name ",
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            history.className ?? '',
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Plan ",
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            history.termName ?? '',
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
