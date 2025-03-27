import 'package:flutter/cupertino.dart';

import 'package:dev_ops_act4/main.dart';
import 'package:dev_ops_act4/config/options.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

enum unitMeasurement { Kelvin, Imperial, Metric }

class _SettingsPageState extends State<SettingsPage> {


  final _city = TextEditingController();
  final _country = TextEditingController();

  Color _color = CupertinoColors.systemPurple;

  @override
  void initState() {
    super.initState();
  }
  @override

  Widget build(BuildContext context) {

    unitMeasurement? _measurement;

    if (OptionSettings.unit == 1) {
      _measurement = unitMeasurement.Kelvin;
    } else if (OptionSettings.unit == 2) {
      _measurement = unitMeasurement.Imperial;
    } else if (OptionSettings.unit == 3) {
      _measurement = unitMeasurement.Metric;
    } else {
      _measurement = unitMeasurement.Kelvin;
    }

    if (OptionSettings.accent == "purple"){
      _color = CupertinoColors.systemPurple;
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
        automaticallyImplyLeading: true,
        middle: Text('Settings'),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            Column(
              children: [
                CupertinoListSection.insetGrouped(
                  additionalDividerMargin: 5,
                  children: [
                    CupertinoListTile(
                      title: Text('Location'),
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      leading: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5),),
                          color: CupertinoColors.systemOrange,
                        ),
                        padding: EdgeInsets.all(3),
                        child: Icon(CupertinoIcons.location_fill, color: CupertinoColors.white,),
                      ),
                      additionalInfo: Text('${OptionSettings.city}'),
                      trailing: CupertinoListTileChevron(),
                      onTap: (){
                        showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: Text('Change Location'),
                              content: Column(
                                children: [
                                  SizedBox(height: 15,),
                                  Row(crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(width: 20,),
                                      Text('City: '),
                                    ],
                                  ),
                                  CupertinoTextFormFieldRow(
                                    controller: _city,
                                    decoration: BoxDecoration(
                                      color: CupertinoColors.systemBackground.resolveFrom(context),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: CupertinoColors.label.resolveFrom(context),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(width: 20,),
                                      Text('Country: '),
                                    ],
                                  ),
                                  CupertinoTextFormFieldRow(
                                    controller: _country,
                                    decoration: BoxDecoration(
                                      color: CupertinoColors.systemBackground.resolveFrom(context),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: CupertinoColors.label.resolveFrom(context),
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                CupertinoButton(
                                  child: Text('Close', style: TextStyle(color: CupertinoColors.destructiveRed)),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                CupertinoButton(
                                  child: Text('Ok', style: TextStyle(color: CupertinoColors.systemBlue)),
                                  onPressed: () {
                                    setState(() {
                                      OptionSettings.isCityOnly = _country.text.isEmpty;
                                      OptionSettings.city = _city.text;
                                      OptionSettings.country = _country.text;
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    CupertinoListTile(
                      title: Text('Unit Measurement'),
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      leading: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5),),
                          color: CupertinoColors.systemGreen,
                        ),
                        padding: EdgeInsets.all(3),
                        child: Icon(CupertinoIcons.thermometer, color: CupertinoColors.white,),
                      ),
                      additionalInfo: Text(_measurement.name),
                      trailing: CupertinoListTileChevron(),
                      onTap: (){
                        showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            unitMeasurement? tempMeasurement = _measurement;
                            return StatefulBuilder(
                              builder: (context, setModalState) {
                                return CupertinoAlertDialog(
                                  title: Text('Change Unit Measurement'),
                                  content: Column(
                                    children: [
                                      SizedBox(height: 20,),
                                      Row(mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          CupertinoRadio(value: unitMeasurement.Kelvin, groupValue: tempMeasurement, onChanged: (unitMeasurement? value){
                                            setModalState(() {
                                              tempMeasurement = value;
                                            });
                                          }),
                                          Text('Kelvin (K)')
                                        ],
                                      ),
                                      SizedBox(height: 15,),
                                      Row(mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          CupertinoRadio(value: unitMeasurement.Imperial, groupValue: tempMeasurement, onChanged: (unitMeasurement? value){
                                            setModalState(() {
                                              tempMeasurement = value;
                                            });
                                          }),
                                          Text('Imperial (°F)')
                                        ],
                                      ),
                                      SizedBox(height: 15,),
                                      Row(mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          CupertinoRadio(value: unitMeasurement.Metric, groupValue: tempMeasurement, onChanged: (unitMeasurement? value){
                                            setModalState(() {
                                              tempMeasurement = value;
                                            });
                                          }),
                                          Text('Metric (°C)')
                                        ],
                                      )
                                    ],
                                  ),
                                  actions: [
                                    CupertinoButton(
                                      child: Text('Close', style: TextStyle(color: CupertinoColors.destructiveRed)),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    CupertinoButton(
                                      child: Text('Ok', style: TextStyle(color: CupertinoColors.systemBlue)),
                                      onPressed: () {
                                        setState(() {
                                          _measurement = tempMeasurement;
                                          if(_measurement == unitMeasurement.Kelvin){
                                            setState(() {
                                              OptionSettings.unit = 1;
                                            });
                                          }else if(_measurement == unitMeasurement.Imperial){
                                            setState(() {
                                              OptionSettings.unit = 2;
                                            });
                                          }else if(_measurement == unitMeasurement.Metric){
                                            setState(() {
                                              OptionSettings.unit = 3;
                                            });
                                          }
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              }
                            );
                          },
                        );
                      },
                    ),
                    CupertinoListTile(
                      title: Text('Icon Accent'),
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      leading: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5),),
                          color: CupertinoColors.systemPink,
                        ),
                        padding: EdgeInsets.all(3),
                        child: Icon(CupertinoIcons.color_filter, color: CupertinoColors.white,),
                      ),
                      additionalInfo: Container(
                        height: 16,
                        width: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _color // needs to reflect icon accent
                        ),
                      ),
                      trailing: CupertinoListTileChevron(),
                      onTap: (){
                        showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: Text('Change Icon Accent'),
                              content: Column(
                                children: [
                                  SizedBox(height: 15,),
                                  Row(mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(children: [
                                        Row(
                                          children: [
                                            CupertinoButton(
                                              child: Container(
                                                height: 24,
                                                width: 24,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: CupertinoColors.systemPurple
                                                ),
                                              ),
                                              onPressed: (){
                                                setState(() {
                                                  _color = CupertinoColors.systemPurple;
                                                  OptionSettings.accent = "purple";
                                                });
                                              },
                                            ),
                                            CupertinoButton(
                                              child: Container(
                                                height: 24,
                                                width: 24,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: CupertinoColors.systemPink
                                                ),
                                              ),
                                              onPressed: (){
                                                setState(() {
                                                  _color = CupertinoColors.systemPink;
                                                  OptionSettings.accent = "pink";
                                                });
                                              },
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            CupertinoButton(
                                              child: Container(
                                                height: 24,
                                                width: 24,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: CupertinoColors.systemYellow
                                                ),
                                              ),
                                              onPressed: (){
                                                setState(() {
                                                  _color = CupertinoColors.systemYellow;
                                                  OptionSettings.accent = "yellow";
                                                });
                                              },
                                            ),
                                            CupertinoButton(
                                              child: Container(
                                                height: 24,
                                                width: 24,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: CupertinoColors.systemOrange
                                                ),
                                              ),
                                              onPressed: (){
                                                setState(() {
                                                  _color = CupertinoColors.systemOrange;
                                                  OptionSettings.accent = "orange";
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            CupertinoButton(
                                              child: Container(
                                                height: 24,
                                                width: 24,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: CupertinoColors.systemBlue
                                                ),
                                              ),
                                              onPressed: (){
                                                setState(() {
                                                  _color = CupertinoColors.systemBlue;
                                                  OptionSettings.accent = "Blue";
                                                });
                                              },
                                            ),
                                            CupertinoButton(
                                              child: Container(
                                                height: 24,
                                                width: 24,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: CupertinoColors.label.resolveFrom(context)
                                                ),
                                              ),
                                              onPressed: (){
                                                setState(() {
                                                  _color = CupertinoColors.label.resolveFrom(context);
                                                  OptionSettings.accent = "opposite";
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ],)
                                    ],
                                  ),
                                ]
                              ),
                              actions: [
                                CupertinoButton(
                                  child: Text('Close', style: TextStyle(color: CupertinoColors.destructiveRed)),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                CupertinoButton(
                                  child: Text('Ok', style: TextStyle(color: CupertinoColors.systemBlue)),
                                  onPressed: () {

                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    CupertinoListTile(
                      title: Text('Light Mode'),
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      leading: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5),),
                          color: CupertinoColors.systemYellow,
                        ),
                        padding: EdgeInsets.all(3),
                        child: Icon(CupertinoIcons.light_max, color: CupertinoColors.white,),
                      ),
                      additionalInfo: Transform.scale(
                        scale: 0.75,
                        child: CupertinoSwitch(value: OptionSettings.isLightMode, onChanged: (value){
                          setState(() {
                            OptionSettings.isLightMode =!OptionSettings.isLightMode;
                          });
                          print("Light Mode Changed: ");
                          print(OptionSettings.isLightMode);

                          (context.findAncestorStateOfType<_HomepageState>())?.updateTheme();

                        }),
                      ),
                      onTap: (){
                      },
                    ),
                    CupertinoListTile(
                      title: Text('About'),
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      leading: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5),),
                          color: CupertinoColors.systemBlue,
                        ),
                        padding: EdgeInsets.all(3),
                        child: Icon(CupertinoIcons.info_circle, color: CupertinoColors.white,),
                      ),
                      trailing: CupertinoListTileChevron(),
                      onTap: (){
                        showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: Text('About Us'),
                              content: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Column(
                                          children: [
                                            ClipOval(
                                              child: Image.asset(
                                                'images/devs/howen.jpg',
                                                height: 75,
                                                width: 75,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Text('Howen Julius Asuncion'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Column(
                                          children: [
                                            ClipOval(
                                              child: Image.asset(
                                                'images/devs/goco.jpg',
                                                height: 75,
                                                width: 75,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Text('John Michael Goco'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Column(
                                          children: [
                                            ClipOval(
                                              child: Image.asset(
                                                'images/devs/renz.jpg',
                                                height: 75,
                                                width: 75,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Text('Renz Gabriel Salas'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              actions: [
                                CupertinoButton(
                                  child: Text('Close', style: TextStyle(color: CupertinoColors.destructiveRed)),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ]
                ),
              SizedBox(height: 18,),
              ],
            ),
          ]
        ),
      ),
    );
  }
}
