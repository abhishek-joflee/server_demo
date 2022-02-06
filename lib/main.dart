import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

void main() {
  runApp(const MaterialApp(home: Home()));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String statusText = "Start Server";
  startServer() async {
    setState(() {
      statusText = "Starting server on Port : 8080";
    });
    Response _echoRequest(Request request) =>
        Response.ok('Request for "${request.url}"');
    var handler =
        const Pipeline().addMiddleware(logRequests()).addHandler(_echoRequest);

    var server = await shelf_io.serve(
      handler,
      InternetAddress.anyIPv4,
      8080,
    );

    // Enable content compression
    server.autoCompress = true;

    log("Serving at http://${server.address.host}:${server.port}");
    setState(() {
      statusText =
          "Server running on http://${server.address.host}:${server.port}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              startServer();
            },
            child: Text(statusText),
          )
        ],
      ),
    ));
  }
}
