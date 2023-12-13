import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Countdown Circular Progress'),
        ),
        body: Center(
          child: CountdownCircularProgress(),
        ),
      ),
    );
  }
}

class CountdownCircularProgress extends StatefulWidget {
  @override
  _CountdownCircularProgressState createState() =>
      _CountdownCircularProgressState();
}

class _CountdownCircularProgressState extends State<CountdownCircularProgress> {
  int _timeInSeconds = 30;
  late Timer _timer;
  double _progressValue = 1.0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    const oneSecond = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSecond,
      (Timer timer) {
        setState(() {
          if (_timeInSeconds < 1) {
            timer.cancel();
          } else {
            _timeInSeconds -= 1;
            _progressValue = _timeInSeconds / 30.0;
          }
        });
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          value: _progressValue,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          strokeWidth: 10.0,
        ),
        SizedBox(height: 20.0),
        Text(
          'Time Remaining: $_timeInSeconds seconds',
          style: TextStyle(fontSize: 18.0),
        ),
      ],
    );
  }
}
