import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class PageToolTimeScreen extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<PageToolTimeScreen> {
  bool isDarkMode = true;
  StreamController _streamController;
  Stream _stream;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    SystemChrome.setEnabledSystemUIOverlays([]);
    _streamController = StreamController<DateTime>();
    _stream = _streamController.stream;
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      _streamController.sink.add(DateTime.now());
    });
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    _streamController.close();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isDarkMode = !isDarkMode;
        });
      },
      child: Scaffold(
        backgroundColor: isDarkMode ? Colors.black87 : Colors.white.withAlpha(233),
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder<DateTime>(
            stream: _stream,
            initialData: DateTime.now(),
            builder: (BuildContext context, AsyncSnapshot<DateTime> snapshot) {
              if (snapshot.hasData) {
                DateTime dateTime = snapshot.data;
                return Stack(
                  children: <Widget>[
                    Center(
                      child: Text(
                        DateFormat("HH : mm : ss").format(dateTime),
                        style: TextStyle(
                          color: isDarkMode ? Colors.white.withAlpha(233) : Colors.black54,
                          fontSize: 96,
                          textBaseline: TextBaseline.alphabetic,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 48, right: 64),
                        child: Text(
                          DateFormat("EEEE  d  MMMM", "en").format(dateTime),
                          style: TextStyle(
                            fontSize: 20,
                            color: isDarkMode ? Colors.white.withAlpha(233) : Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}
