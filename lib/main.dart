import 'dart:async';

import 'package:flutter/material.dart';
import 'package:good/fourth_screen.dart';
import 'package:good/sesssion/Session.dart';
import 'package:good/sesssion/SessionManager.dart';
import 'package:good/sesssion/session_constants.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  StreamController streamController = StreamController();

  Session session = Session();

  // This widget is the root of your application.
  void redirectUrl() {
    if (globalNavigatorKey.currentContext != null) {
      Navigator.pop(globalNavigatorKey.currentContext!);
      Navigator.push(
          globalNavigatorKey.currentContext!,
          MaterialPageRoute(
              builder: (context) => MyHomePage(session: session)));
    }
  }

  @override
  Widget build(BuildContext context) {
    session.enableLoginPage = false;
    if (globalNavigatorKey.currentContext != null) {
      session.startListener(
          streamController: streamController,
          context: globalNavigatorKey.currentContext!);
    }

    return SessionManager(
      streamController: streamController,
      duration: const Duration(seconds: 20),
      sessionTimeExpired: () {
        if (globalNavigatorKey.currentContext != null &&
            session.enableLoginPage == true) {
          ScaffoldMessenger.of(globalNavigatorKey.currentContext!).showSnackBar(SnackBar(content: Container(
            child: const Text('Session timout'),
          )));
          redirectUrl();
          session.enableLoginPage = false;
        }
      },
      context: context,
      globalNavigatorKey: globalNavigatorKey,
      child: MaterialApp(
        title: 'Flutter Demo',
        navigatorKey: globalNavigatorKey,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(session: session),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  Session session;

  MyHomePage({Key? key, required this.session}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              widget.session.enableLoginPage = true;
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SecondRoute()));
            },
            child: const Text('start')),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  StreamController? streamController;

  SecondRoute({super.key, this.streamController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => thridRoute()));
              },
              child: const Text('move front'),
            ),
            TextFormField(
              onChanged: (value) {},
            )
          ],
        ),
      ),
    );
  }
}

class thridRoute extends StatelessWidget {
  const thridRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
      ),
      body: Center(
        child: Column(
          children: [
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FourthScreen()));
                },
                child: const Text('hello')),
            const Text('back')
          ],
        ),
      ),
    );
  }
}
