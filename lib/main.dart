import 'package:flutter/cupertino.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          'iWeather',
          style: TextStyle(color: CupertinoColors.white),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.settings, color: CupertinoColors.systemPurple),
          onPressed: () {},
        ),
        backgroundColor: CupertinoColors.black,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'My Location',
              style: TextStyle(color: CupertinoColors.white, fontSize: 24),
            ),
            SizedBox(height: 4),
            Text(
              'Russia',
              style: TextStyle(color: CupertinoColors.white, fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              '-20°',
              style: TextStyle(color: CupertinoColors.white, fontSize: 64, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Icon(
              CupertinoIcons.cloud,
              color: CupertinoColors.systemPurple,
              size: 80,
            ),
            SizedBox(height: 10),
            Text(
              'broken clouds',
              style: TextStyle(color: CupertinoColors.white, fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'H: 92% W: 3.81 kph',
              style: TextStyle(color: CupertinoColors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
