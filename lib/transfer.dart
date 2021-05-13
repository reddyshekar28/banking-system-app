import 'dart:convert';

import 'package:banking/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TransferScreen extends StatefulWidget {
  final String id;
  TransferScreen({@required this.id});
  @override
  _TransferScreenState createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  var customer;
  TextEditingController textEditingController = TextEditingController();
  bool detailLoading = true;
  bool listLoading = true;
  getCustomer() {
    http
        .get(Uri.parse(
            'https://reddy-banking.herokuapp.com/customers/' + widget.id))
        .then((value) {
      var data = jsonDecode(value.body);
      setState(() {
        customer = data;
        detailLoading = false;
      });
    });
  }

  String dropdownValue = "";

  List customers = [];
  getCustomers() {
    http
        .get(Uri.parse('https://reddy-banking.herokuapp.com/customers'))
        .then((value) {
      var data = jsonDecode(value.body);
      setState(() {
        customers = data;
        dropdownValue = customers[0]['_id'];
        listLoading = false;
      });
    });
  }

  sendMoney() {
    http
        .post(Uri.parse('https://reddy-banking.herokuapp.com/transfer'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              "to": dropdownValue,
              "from": customer['_id'],
              "amount": int.parse(textEditingController.text),
            }))
        .then((value) {
      var data = jsonDecode(value.body);
      print(data);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WebViewExample(),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    getCustomer();
    getCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              detailLoading
                  ? Container()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name : " + customer["name"]),
                        Text("Email : " + customer["email"]),
                        Text(
                          "Balance : " + customer["currentBalance"].toString(),
                        ),
                      ],
                    ),
              TextField(
                controller: textEditingController,
                decoration:
                    InputDecoration(hintText: "Enter Amount to transfer"),
              ),
              SizedBox(height: 8),
              Text("Tranfer To"),
              listLoading
                  ? Container()
                  : DropdownButton<String>(
                      value: dropdownValue,
                      icon: Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                      items: customers.map<DropdownMenuItem<String>>((value) {
                        return DropdownMenuItem<String>(
                          value: value['_id'],
                          child: Text(value["name"]),
                        );
                      }).toList(),
                    ),
              TextButton(
                onPressed: () {
                  sendMoney();
                },
                child: Text('Transfer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
