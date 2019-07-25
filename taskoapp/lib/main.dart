import 'package:flutter/material.dart';
import 'package:tasko_app/settingsoption.dart';
import 'package:tasko_app/dashboard.dart';
import 'package:tasko_app/AppPage.dart';
import 'package:tasko_app/TaskModel.dart';
import 'package:admob_flutter/admob_flutter.dart';

void main() {
  Admob.initialize(getAppId());
  runApp(TaskoApp());

}

String getBannerAdUnitId()
{
  return "ca-app-pub-3940256099942544/6300978111";
}
String getAppId()
{
  return "ca-app-pub-6998319902801484";
}
class TaskoApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasko',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    AppPage(),
    DashboardPage(),
    SettingsPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tasko", style: TextStyle(fontFamily: 'Pacifico'),),backgroundColor: Color(0xffb41CAC6),),
      body: Center(
        child: Stack(children: <Widget>[
          _widgetOptions.elementAt(_selectedIndex),
        ],),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        backgroundColor: Color(0XFFB524364),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Icons.home, color: Colors.white,),
            title: Text("Home", style: TextStyle(color: Colors.white),),

          ),
          BottomNavigationBarItem(
          icon: Icon(Icons.dashboard, color: Colors.white),
          title: Text("Dashboard", style: TextStyle(color: Colors.white))

          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings, color: Colors.white),
              title: Text("Settings", style: TextStyle(color: Colors.white))

          ),
        ],
      ),
    );
  }
}
