import 'dart:async';

import 'package:flutter/material.dart';

class SessionManager extends StatefulWidget {
  Widget child;
  StreamController streamController;
  Duration duration;
  VoidCallback sessionTimeExpired;
  BuildContext context;
  GlobalKey<NavigatorState> globalNavigatorKey;

  SessionManager(
      {Key? key,
      required this.child,
      required this.streamController,
      required this.duration,
      required this.sessionTimeExpired,
      required this.context,
      required this.globalNavigatorKey})
      : super(key: key);

  @override
  State<SessionManager> createState() => _SessionManagerState();
}

class _SessionManagerState extends State<SessionManager> {
  Timer? _sessionTimer;
  StreamController? streamController;

  void _startSessionTimer() {
    print('timer started');
    _sessionTimer = Timer(widget.duration, () {
      widget.sessionTimeExpired();
      cancelTimer();
    });
  }

  void cancelTimer() {
    if (_sessionTimer != null) {
      _sessionTimer!.cancel();
    }
  }

  void _startSession() {
    cancelTimer();
    _startSessionTimer();
  }

  @override
  void initState() {
    super.initState();
    streamController = widget.streamController;
    streamController!.stream.listen((event) {
      if (event != null && event['timer'] as bool) {
        _startSession();
      } else {
        cancelTimer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        _startSession();
      },
      child: widget.child,
    );
  }
}
