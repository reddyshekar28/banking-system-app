import 'dart:convert';

import 'package:banking/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TransactionScreen extends StatefulWidget {
  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  List customers = [];
  getCustomers() {
    http
        .get(Uri.parse('https://reddy-banking.herokuapp.com/transfers'))
        .then((value) {
      var data = jsonDecode(value.body);
      print(data);
      setState(() {
        customers = data;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WebViewExample(),
                ),
              ),
              child: Text('GO BACK'),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: customers.length,
                itemBuilder: (_, i) {
                  return ListTile(
                    title: Text(
                      "TO: " + customers[i]['to']['name'],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "FROM: " + customers[i]['from']['name'],
                        ),
                        Text(
                          "AMOUNT :" + customers[i]['amount'].toString(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
