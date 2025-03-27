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
            brightness: Brightness.dark
        )
    ),
  );
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override

  bool isCityOnly = false;

  String city = "Mexico";
  String country = "Philippines";
  String location = "";

  String temp = "";
  IconData? weatherStatus;
  String weather = "";
  String humidity = "";
  String windSpeed = "";

  // 1 = standard, 2 = imperial, 3 = metric
  // OpenWeather api has &units 'query' to return specific units
  Map<int, String> unitOptions = {
    1: "standard",
    2: "imperial",
    3: "metric"
  };

  List<dynamic> countryData = [];
  Map<String, dynamic> weatherData = {};

  Future<void> getWeatherData () async {
    try{
      // Since WeatherOpen API only takes alpha-2 country code
      // User rest countries API to return coutnry alpha-2
      if(!isCityOnly){
        String restLink = "https://restcountries.com/v3.1/name/"+country+"?fields=name,cca2";
        final restResponse = await http.get(Uri.parse(restLink));

        countryData = jsonDecode(restResponse.body);
      }

      // print(countryData[0]['name']['common']);

      String baseUnit = unitOptions[3] ?? "standard";
      String link = isCityOnly
          ? "https://api.openweathermap.org/data/2.5/weather?q="+city+",&units="+baseUnit+"&appid=ad66cda9e6fae9cf07de09f1301c1f37"
          : "https://api.openweathermap.org/data/2.5/weather?q="+city+","+countryData[0]["cca2"]+"&units="+baseUnit+"&appid=ad66cda9e6fae9cf07de09f1301c1f37";
      final weatherResponse = await http.get(Uri.parse(link)    );

      weatherData = jsonDecode(weatherResponse.body);

      try{
        setState(() {

          location = isCityOnly
              ? weatherData['name']
              : weatherData['name']+", "+countryData[0]['name']['common'];

          if(baseUnit == "standard"){
            temp = (weatherData["main"]["temp"]).toStringAsFixed(0) + "K";
          }else if(baseUnit == "imperial"){
            temp = (weatherData["main"]["temp"]).toStringAsFixed(0) + "°F";
          }else{
            temp = (weatherData["main"]["temp"]).toStringAsFixed(0) + "°C";
          }

          humidity = (weatherData["main"]["humidity"]).toString() + "%";
          windSpeed = (weatherData["main"]["humidity"]).toString() + " kph";
          weather = weatherData["weather"][0]["description"];

          if(weather.contains("clear")){
            weatherStatus = CupertinoIcons.sun_max;
          }else if(weather.contains("cloud")){
            weatherStatus = CupertinoIcons.cloud;
          }else if(weather.contains("rain")){
            weatherStatus = CupertinoIcons.cloud_rain;
          }else if(weather.contains("thunderstorm")){
            weatherStatus = CupertinoIcons.cloud_bolt_rain;
          }else if(weather.contains("snow")){
            weatherStatus = CupertinoIcons.snow;
          }else if(weather.contains("smoke")){
            weatherStatus = CupertinoIcons.smoke;
          }else if(weather.contains("haze")){
            weatherStatus = CupertinoIcons.sun_haze;
          }else if(weather.contains("dust")){
            weatherStatus = CupertinoIcons.sun_dust;
          }else if(weather.contains("fog")){
            weatherStatus = CupertinoIcons.cloud_fog;
          }else if(weather.contains("tornado")){
            weatherStatus = CupertinoIcons.tornado;
          }else if(weather.contains("fog")){
            weatherStatus = CupertinoIcons.cloud_fog;
          }else if(weather.contains("drizzle")){
            weatherStatus = CupertinoIcons.cloud_drizzle;
          }

        });
      }catch(e){
        showCupertinoDialog(context: context, builder: (context){
          return CupertinoAlertDialog(
            title: Text('Message'),
            content: Text('City not found'),
            actions: [
              CupertinoButton(child: Text('Close', style: TextStyle(color: CupertinoColors.destructiveRed),), onPressed: (){
                Navigator.pop(context);
              }),
            ],
          );
        });
      }

      if(weatherData["cod"] == 200){
        // print(countryData[0]['name']['common']);
        print(weatherData["name"]);
        print(weatherData["main"]["temp"]);
        print(weatherData["weather"][0]["description"]);
      }else{
        print("Invalid City!");
      }

      // print(unitOptions[1]);
      print(weatherResponse.body);

      // String location = weatherData['name']+", "+countryData[0]['name']['common'];
      // print(location);
    }catch(e){
      showCupertinoDialog(context: context, builder: (context){
        return CupertinoAlertDialog(
          title: Text('Message'),
          content: Text('No Internet Connection'),
          actions: [
            CupertinoButton(child: Text('Close', style: TextStyle(color: CupertinoColors.destructiveRed),), onPressed: (){
              Navigator.pop(context);
            }),
            CupertinoButton(child: Text('Retry', style: TextStyle(color: CupertinoColors.systemGreen),), onPressed: (){
              Navigator.pop(context);
              getWeatherData();
            })
          ],
        );
      });
    }
  }
  @override
  void initState() {
    getWeatherData();
    super.initState();
  }
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          'iWeather',
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(
              CupertinoIcons.settings, color: CupertinoColors.systemPurple),
          onPressed: () {},
        ),
        backgroundColor: CupertinoColors.black,
      ),
      child: SafeArea(
        child: temp != "" ? Center(
          child: Column(
            children: [
              SizedBox(height: 50,),
              Text('My Location', style: TextStyle(fontSize: 30),),
              SizedBox(height: 5),
              Text('$location', style: TextStyle(fontSize: 35),),
              SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.thermometer, color: CupertinoColors.systemPurple, size: 70,),
                  Text('$temp', style: TextStyle(fontSize: 80),),
                ],
              ),
              SizedBox(height: 10),
              Icon(weatherStatus, color: CupertinoColors.systemPurple, size: 100,),
              SizedBox(height: 10),
              Text('$weather'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.drop, color: CupertinoColors.systemPurple, size: 18,),
                  Text('H: $humidity'),
                  SizedBox(width: 15,),
                  Icon(CupertinoIcons.wind, color: CupertinoColors.systemPurple, size: 18,),
                  Text('W: $windSpeed')
                ],
              ),
            ],
          ),
        ) : Center(child: CupertinoActivityIndicator(),),
      ),
    );
  }
}

