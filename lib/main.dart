import 'dart:convert';
import 'package:dev_ops_act4/config/options.dart';
import 'package:dev_ops_act4/pages/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

bool isLightMode = OptionSettings.isLightMode;

void main()=>runApp(CupertinoApp(

  home: Homepage(),
  title: 'NavBook',
  debugShowCheckedModeBanner: false,
  theme: CupertinoThemeData(
    brightness: isLightMode ? Brightness.light : Brightness.dark,
  ),
));

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override

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
      if(!OptionSettings.isCityOnly){
        String restLink = "https://restcountries.com/v3.1/name/${OptionSettings.country}?fields=name,cca2";
        final restResponse = await http.get(Uri.parse(restLink));

        countryData = jsonDecode(restResponse.body);
        print(restResponse.body);
      }


      // print(countryData[0]['name']['common']);

      String link = OptionSettings.isCityOnly
          ? "https://api.openweathermap.org/data/2.5/weather?q=${OptionSettings.city},&units=${unitOptions[OptionSettings.unit]}&appid=ad66cda9e6fae9cf07de09f1301c1f37"
          : "https://api.openweathermap.org/data/2.5/weather?q=${OptionSettings.city},${countryData[0]["cca2"]}&units=${unitOptions[OptionSettings.unit]}&appid=ad66cda9e6fae9cf07de09f1301c1f37";
      final weatherResponse = await http.get(Uri.parse(link));

      weatherData = jsonDecode(weatherResponse.body);

      try{
        setState(() {

          location = OptionSettings.isCityOnly
              ? "${weatherData["name"]}"
              : "${weatherData["name"]}, ${countryData[0]["name"]["common"]}";

          if(unitOptions[OptionSettings.unit] == "standard"){
            temp = (weatherData["main"]["temp"]).toStringAsFixed(0) + "K";
          }else if(unitOptions[OptionSettings.unit] == "imperial"){
            temp = (weatherData["main"]["temp"]).toStringAsFixed(0) + "°F";
          }else{
            temp = (weatherData["main"]["temp"]).toStringAsFixed(0) + "°C";
          }

          humidity = "${weatherData["main"]["humidity"]}%";
          windSpeed = "${weatherData["main"]["humidity"]} kph";
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
        print(link);
        print(OptionSettings.city);
        print(OptionSettings.country);
      }

      // print(unitOptions[1]);
      // print(restResponse.body);
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


  Color _color = CupertinoColors.systemPurple;

  @override
  void initState() {
    getWeatherData();
    super.initState();
  }
  Widget build(BuildContext context) {


    print("Light Mode from Main: ");
    print(OptionSettings.isLightMode);


    if (OptionSettings.accent == "purple"){
      setState(() {
        _color = CupertinoColors.systemPurple;
      });
    }else if (OptionSettings.accent == "pink"){
      _color = CupertinoColors.systemPink;
    }else if (OptionSettings.accent == "yellow"){
      _color = CupertinoColors.systemYellow;
    }else if (OptionSettings.accent == "orange"){
      _color = CupertinoColors.systemOrange;
    }else if (OptionSettings.accent == "blue"){
      _color = CupertinoColors.systemBlue;
    }else if (OptionSettings.accent == "opposite"){
      _color = CupertinoColors.label.resolveFrom(context);
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          'iWeather',
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(
              CupertinoIcons.settings, color: _color),
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => SettingsPage()),
            ).then((value) {
              setState(() {
                getWeatherData();
              });
            });
          },
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
                  Icon(CupertinoIcons.thermometer, color: _color, size: 70,),
                  Text('$temp', style: TextStyle(fontSize: 80),),
                ],
              ),
              SizedBox(height: 10),
              Icon(weatherStatus, color: _color, size: 100,),
              SizedBox(height: 10),
              Text('$weather'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.drop, color: _color, size: 18,),
                  Text('H: $humidity'),
                  SizedBox(width: 15,),
                  Icon(CupertinoIcons.wind, color: _color, size: 18,),
                  Text('W: $windSpeed')
                ],
              ),
            ],
          ),
        ) : Center(child: CupertinoActivityIndicator(),),
      ),
    );
  }

  void updateTheme() {
    final appState = context.findAncestorStateOfType<_HomepageState>();
  }
}

