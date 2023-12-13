import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

AudioPlayer audioPlayer = AudioPlayer();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

bool _BookingNotification = false;
bool isMuted = false;
// void playAudio() async {
//   int result = await audioPlayer.play('audio_file.mp3'); // Replace 'audio_file.mp3' with your audio file path or URL
//   if (result == 1) {
//     // success
//     print('Audio playing');
//   } else {
//     // error
//     print('Error playing audio');
//   }
// }

class _HomePageState extends State<HomePage> {
  int _seconds = 30;
  bool _isPaused = true;
  bool round1 = false;

  void _toggleTimer() {
    if (_isPaused) {
      _startTimer();
    } else {
      _pauseTimer();
    }
  }

  void _startTimer() {
    setState(() {
      _isPaused = false;
      _seconds = 30;
    });

    _runTimer();
  }

  void _continueTimer() {
    setState(() {
      _isPaused = false;
    });
    _runTimer();
  }

  void _runTimer() {
    Future.delayed(Duration(seconds: 1), () {
      if (_seconds > 0 && !_isPaused) {
        setState(() {
          _isPaused = false;
          _seconds--;
          if (_seconds == 0) {
            setState(() {
              round1 = true;
            });
          }
          if (_seconds <= 5) {
            final player = AudioPlayer();
            player.play(AssetSource(
              'a.mp3',
            ));
          }
        });
        _runTimer();
      }
    });
  }

  void _pauseTimer() {
    setState(() {
      _isPaused = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    double Width = screenSize.width;
    double Height = screenSize.height;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 2, 18, 31),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 2, 18, 31),
        leading: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        title: Text(
          'Mindful Meal timer',
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ActiveContainer(),
                SizedBox(
                  width: Width * 0.02,
                ),
                ActiveContainer(),
                SizedBox(
                  width: Width * 0.02,
                ),
                InactiveContainer(),
              ],
            ),
            SizedBox(
              height: Height * 0.01,
            ),
            Text(
              round1 ? 'Break Time' : 'Nom nom:)',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.white,
                fontSize: 25,
              ),
            ),
            SizedBox(
              height: Height * 0.01,
            ),
            Text(
              'You have 10 minutes to eat before the pause.\n Focus on eating slowly',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 160, 157, 157),
              ),
            ),
            SizedBox(
              height: Height * 0.02,
            ),
            Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Stack(
                  children: [
                    Container(
                      height: 230,
                      width: 230,
                      decoration: BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                    ),
                    Positioned(
                      top: Height * 0.053,
                      left: Width * 0.12,
                      right: Width * 0.12,
                      child: SizedBox(
                        width: 150,
                        height: 150,
                        child: CircularProgressIndicator(
                          color: Colors.green,
                          value: _seconds / 30,
                          strokeWidth: 10,
                        ),
                      ),
                    ),
                    Positioned(
                      top: Height * 0.12,
                      left: Width * 0.18,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '00: $_seconds ',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            "minutes remaining",
                            style: TextStyle(fontSize: 12),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: <Widget>[
            //     ElevatedButton(
            //       onPressed: _toggleTimer,
            //       child: Text(_isPaused ? 'Start' : 'Pause/Resume'),
            //     ),
            //   ],
            // ),
            SizedBox(
              height: Height * 0.02,
            ),
            Transform.scale(
              scale: 1.3,
              child: Switch(
                value: _BookingNotification,
                onChanged: (bool newValue) {
                  setState(() {
                    _BookingNotification = newValue;
                  });
                  setState(() {
                    isMuted = !isMuted;
                    audioPlayer.setVolume(isMuted ? 0.0 : 1.0);
                  });
                },
                activeColor: Colors.green[400],
                inactiveThumbColor: Colors.grey,
                inactiveTrackColor: Colors.grey[300],
              ),
            ),
            Text(
              'Sound On',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              height: Height * 0.01,
            ),
            InkWell(
              onTap: () {
                _toggleTimer();
              },
              child: CommonButton(
                  height: Height,
                  width: Width,
                  text: _isPaused || round1 ? 'START' : 'PAUSE'),
            ),
            SizedBox(
              height: Height * 0.015,
            ),
            CommonButton2(
              height: Height,
              width: Width,
              text: "LET'S STOP I'M FULL NOW",
            ),
          ],
        ),
      ),
    );
  }
}

class CommonButton extends StatelessWidget {
  const CommonButton({
    super.key,
    required this.height,
    required this.width,
    required this.text,
    this.color,
  });

  final double height;
  final double width;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.07,
      width: width * 0.86,
      decoration: BoxDecoration(
          color: Colors.green[100], borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
    );
  }
}

class CommonButton2 extends StatelessWidget {
  const CommonButton2({
    super.key,
    required this.height,
    required this.width,
    required this.text,
    this.color,
  });

  final double height;
  final double width;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.07,
      width: width * 0.86,
      decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white)),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
    );
  }
}

class ActiveContainer extends StatelessWidget {
  const ActiveContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15,
      width: 15,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(50)),
    );
  }
}

class InactiveContainer extends StatelessWidget {
  const InactiveContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: 10,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 161, 154, 154),
          borderRadius: BorderRadius.circular(50)),
    );
  }
}
