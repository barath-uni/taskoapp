import 'package:flutter/material.dart';
import 'package:tasko_app/Text.dart';
import 'package:tasko_app/MetricsModel.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:admob_flutter/admob_flutter.dart';

class DashboardPage extends StatefulWidget{

  _DashboardPageState createState() => _DashboardPageState();

}


String getBannerAdUnitId()
{
  return "ca-app-pub-6998319902801484/9468082360";
}
String getAppId()
{
  return "ca-app-pub-6998319902801484~3511880816";
}


class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey<AnimatedCircularChartState> _chartKey = new GlobalKey<AnimatedCircularChartState>();
  CreateMetricsDB metrics_db;
  int completed_count = 0;
  int remaining_count = 0;
  int completed_percentage = 0;
  List<CircularStackEntry> data;

  @override
  Widget build(BuildContext context) {
    metrics_db = CreateMetricsDB.instance;
    metrics_db.initialise();

    // TODO: implement build
    return Container(
      child: Column(
        children: <Widget>[
          AdmobBanner(
              adUnitId: getBannerAdUnitId(),
              adSize: AdmobBannerSize.BANNER,
              listener: (AdmobAdEvent event, Map<String, dynamic> args) {
                switch (event) {
                  case AdmobAdEvent.loaded:
                    print('Admob banner loaded!');
                    break;

                  case AdmobAdEvent.opened:
                    print('Admob banner opened!');
                    break;

                  case AdmobAdEvent.closed:
                    print('Admob banner closed!');
                    break;

                  case AdmobAdEvent.failedToLoad:
                    print('Admob banner failed to load. Error code: ${args['errorCode']}');
                    break;
                  case AdmobAdEvent.clicked:
                  // TODO: Handle this case.
                    break;
                  case AdmobAdEvent.impression:
                  // TODO: Handle this case.
                    break;
                  case AdmobAdEvent.leftApplication:
                  // TODO: Handle this case.
                    break;
                  case AdmobAdEvent.completed:
                  // TODO: Handle this case.
                    break;
                  case AdmobAdEvent.rewarded:
                  // TODO: Handle this case.
                    break;
                  case AdmobAdEvent.started:
                  // TODO: Handle this case.
                    break;
                }
              }
          ),
          Container(
            height: 47.0,
            child: Column(
              children: <Widget>[
                 Row(
                    children: <Widget>[
                      AppBoldText(text: "Remaining Tasks",),
                      Spacer(),
                      FutureBuilder(
                        builder: (context, snapshot){
                          if(snapshot.data != null)
                          {
                            remaining_count = snapshot.data;
                            return AppBoldText(text: snapshot.data.toString());
                          }
                          return Container();
                        },
                        future: metrics_db.get_remaining_count(),
                      ),
                      Spacer()
                    ],
                  ),
                Row(
                    children: <Widget>[
                      AppBoldText(text: "Completed Tasks",),
                      Spacer(),
                      FutureBuilder(
                        builder: (context, snapshot){
                          if(snapshot.data != null)
                          {
                            completed_count = snapshot.data;
                            return AppBoldText(text: snapshot.data.toString());
                          }
                          return Container();
                        },
                        future: metrics_db.get_completed_count(),
                      ),
                      Spacer()
                    ],
                  ),
              ],
            ) ,
          ),
          Container(
            height: 300.0,
            width: 900.0,
            child: Card(
              child: Column(
                children: <Widget>[
                  AppBoldText(text: "Completion Percentage"),
                  FutureBuilder(
                    builder: (context, snapshot){
                      if(snapshot.data != null)
                      {

                      data = <CircularStackEntry>[
                      new CircularStackEntry(
                      <CircularSegmentEntry>[
                      new CircularSegmentEntry(completed_count.toDouble(), Colors.green[200], rankKey: 'Completed'),
                      new CircularSegmentEntry(remaining_count.toDouble(), Colors.red[200], rankKey: 'Remaining'),
                      ],
                      rankKey: 'Completion Percentage',
                      ),
                      ];
                      return AnimatedCircularChart(
                        key: _chartKey,
                        size: const Size(250.0, 250.0),
                        initialChartData: data,
                        chartType: CircularChartType.Pie,
                      );
                      //                        return AppBoldText(text: (completed_count/(remaining_count+completed_count)*100).round().toString()+"%");
                      }
                      return Container();
                    },
                    future: metrics_db.get_completed_count(),
                  ),
                ],
              ),
            ),
          ),
          ]
      ),

    );
  }

}