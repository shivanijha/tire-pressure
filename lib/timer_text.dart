import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class ElapsedTime {
  final int hundreds;
  final int seconds;
  final int minutes;

  ElapsedTime({
    this.hundreds,
    this.seconds,
    this.minutes,
  });
}

class Dependencies {

  final List<ValueChanged<ElapsedTime>> timerListeners = <ValueChanged<ElapsedTime>>[];
  final TextStyle textStyle = const TextStyle(fontSize: 18.0, fontFamily: "Bebas Neue");
  final Stopwatch stopwatch = new Stopwatch();
  final int timerMillisecondsRefreshRate = 30;
}

class TimerPage extends StatefulWidget {
  TimerPage({Key key}) : super(key: key);

  TimerPageState createState() => new TimerPageState();
}

class TimerPageState extends State<TimerPage> {
  final Dependencies dependencies = new Dependencies();

  var txt = TextEditingController(text: "80 PSI");
  List<Color> _colors = [
    Colors.red,
    Colors.green
  ];
  int index = 1;
  void rightButtonPressed() {
    setState(() {
      if (dependencies.stopwatch.isRunning) {
        dependencies.stopwatch.stop();
        int rand = generateRandomNumber();
        txt.text = "$rand PSI";
        if(rand > 100) {
          index = 0;
        } else {
          index = 1;
        }

      } else {
        dependencies.stopwatch.start();
      }
    });
  }

  Widget buildFloatingButton(String text, VoidCallback callback) {
    TextStyle roundTextStyle = const TextStyle(fontSize: 18.0, color: Colors.black,);
    return new FloatingActionButton(
      elevation: 20,
        child:
        new Text(text, style: roundTextStyle),
        onPressed: callback);
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,

      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 5.0,
                    color: Colors.white,
                  ),
                ),
                margin: EdgeInsets.all(4.0),
                color: Colors.white,
                elevation: 20.0,
                child: Padding(

                    padding: const EdgeInsets.all(24.0),
                    child: new Column(

                        children: <Widget>[
                                  Text(
                                    'Wheel Pressure',
                                    style: TextStyle(
                                      fontSize: 24.0,
                                        fontFamily: "Bebas Neue",
                                        fontStyle: FontStyle.normal,
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                          TextField(
                            readOnly: true,
                            textAlign: TextAlign.center,
                            controller: txt,
                            decoration: new InputDecoration.collapsed(
                            ),
                            style: new TextStyle(color: _colors[index],fontWeight: FontWeight.bold),
                          ),

                                ],


                    )
                ),
              ),
            ),
          ],
        ),
        new Expanded(
          child: new TimerText(dependencies: dependencies),

        ),

        new Expanded(
          flex: 0,
          
          child: new Padding(
            
            padding: const EdgeInsets.all(32.0),

            child: new Row(

              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[

                buildFloatingButton(dependencies.stopwatch.isRunning ? "Stop" : "Start", rightButtonPressed),

              ],
            ),
          ),
        ),
      ],
    );
  }

  int generateRandomNumber() {


    final _random = new Random();

    /**
     * Generates a positive random integer uniformly distributed on the range
     * from [min], inclusive, to [max], exclusive.
     */
    int min = 70;
    int max = 130;
    return min + _random.nextInt(max - min);
  }
}

class TimerText extends StatefulWidget {
  TimerText({this.dependencies});
  final Dependencies dependencies;

  TimerTextState createState() => new TimerTextState(dependencies: dependencies);
}

class TimerTextState extends State<TimerText> {
  TimerTextState({this.dependencies});
  final Dependencies dependencies;
  Timer timer;
  int milliseconds;

  @override
  void initState() {
    timer = new Timer.periodic(new Duration(milliseconds: dependencies.timerMillisecondsRefreshRate), callback);
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  void callback(Timer timer) {
    if (milliseconds != dependencies.stopwatch.elapsedMilliseconds) {
      milliseconds = dependencies.stopwatch.elapsedMilliseconds;
      final int hundreds = (milliseconds / 10).truncate();
      final int seconds = (hundreds / 100).truncate();
      final int minutes = (seconds / 60).truncate();
      final ElapsedTime elapsedTime = new ElapsedTime(
        hundreds: hundreds,
        seconds: seconds,
        minutes: minutes,
      );
      for (final listener in dependencies.timerListeners) {
        listener(elapsedTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new RepaintBoundary(
          child: new SizedBox(
            height: 80.0,
            child: new MinutesAndSeconds(dependencies: dependencies),
          ),
        ),
        new RepaintBoundary(
          child: new SizedBox(
            height: 80.0,
            child: new Hundreds(dependencies: dependencies),
          ),
        ),
      ],
    );
  }
}

class MinutesAndSeconds extends StatefulWidget {
  MinutesAndSeconds({this.dependencies});
  final Dependencies dependencies;

  MinutesAndSecondsState createState() => new MinutesAndSecondsState(dependencies: dependencies);
}

class MinutesAndSecondsState extends State<MinutesAndSeconds> {
  MinutesAndSecondsState({this.dependencies});
  final Dependencies dependencies;

  int minutes = 0;
  int seconds = 0;

  @override
  void initState() {
    dependencies.timerListeners.add(onTick);
    super.initState();
  }

  void onTick(ElapsedTime elapsed) {
    if (elapsed.minutes != minutes || elapsed.seconds != seconds) {
      setState(() {
        minutes = elapsed.minutes;
        seconds = elapsed.seconds;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return new Text('$minutesStr:$secondsStr.', style: dependencies.textStyle);
  }
}

class Hundreds extends StatefulWidget {
  Hundreds({this.dependencies});
  final Dependencies dependencies;

  HundredsState createState() => new HundredsState(dependencies: dependencies);
}

class HundredsState extends State<Hundreds> {
  HundredsState({this.dependencies});
  final Dependencies dependencies;

  int hundreds = 0;

  @override
  void initState() {
    dependencies.timerListeners.add(onTick);
    super.initState();
  }

  void onTick(ElapsedTime elapsed) {
    if (elapsed.hundreds != hundreds) {
      setState(() {
        hundreds = elapsed.hundreds;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String hundredsStr = (hundreds % 100).toString().padLeft(2, '0');
    return new Text(hundredsStr, style: dependencies.textStyle);
  }
}
