import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(
    CupertinoApp(
        title: 'NavBook',
        home: Homepage(),
        debugShowCheckedModeBanner: false,
        theme: CupertinoThemeData(
            brightness: Brightness.light
        )
    ),
  );
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

bool isCityOnly = true;

class _HomepageState extends State<Homepage> {
  @override

  String city = "Tokyo";
  String country = "Japan";
  // String province = "PH-LUN"; // doesn't work, only for US province

  // 1 = standard, 2 = imperial, 3 = metric
  // OpenWeather api has &units 'query' to return specific units
  Map<int, String> unitOptions = {
    1: "standard",
    2: "imperial",
    3: "metric"
  };

  // Map for countries
  Map<String, String> countryOptions = {
    "Philippines": "PH",
    "United States": "US",
    "Japan": "JP",
    "South Korea": "KR",
    "United Kingdom": "UK"
  };

  Map<String, dynamic> weatherData = {};

  Future<void> getWeatherData () async {

    String? countryCode = countryOptions[country];
    String baseUnit = unitOptions[3] ?? "standard";
    String link = "https://api.openweathermap.org/data/2.5/weather?q="+city+",&units="+baseUnit+"&appid=ad66cda9e6fae9cf07de09f1301c1f37";
    final weatherResponse = await http.get(Uri.parse(link)    );

    weatherData = jsonDecode(weatherResponse.body);

    // print(unitOptions[1]);
    print(weatherData['name']);

  }
  @override
  void initState() {
    getWeatherData();
    super.initState();
  }
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
          child: Icon(
              CupertinoIcons.settings, color: CupertinoColors.systemPurple),
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
              'Location',
              style: TextStyle(color: CupertinoColors.white, fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Temperature',
              style: TextStyle(color: CupertinoColors.white,
                  fontSize: 64,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Icon(
              CupertinoIcons.cloud,
              color: CupertinoColors.systemPurple,
              size: 80,
            ),
            SizedBox(height: 10),
            Text(
              'Weather (Main)',
              style: TextStyle(color: CupertinoColors.white, fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Extra Info',
              style: TextStyle(color: CupertinoColors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

