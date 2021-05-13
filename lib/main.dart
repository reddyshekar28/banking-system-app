import 'dart:convert';

import 'package:banking/splash.dart';
import 'package:banking/transaction.dart';
import 'package:banking/transfer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class WebViewExample extends StatefulWidget {
  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewExample> {
  List customers = [];
  getCustomers() {
    http
        .get(Uri.parse('https://reddy-banking.herokuapp.com/customers'))
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
                  builder: (_) => TransactionScreen(),
                ),
              ),
              child: Text('Transaction History'),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: customers.length,
                itemBuilder: (_, i) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TransferScreen(
                            id: customers[i]['_id'],
                          ),
                        ),
                      );
                    },
                    title: Text(
                      customers[i]['name'],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customers[i]['email'],
                        ),
                        Text(
                          "Balance :" +
                              customers[i]['currentBalance'].toString(),
                        ),
                      ],
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
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
