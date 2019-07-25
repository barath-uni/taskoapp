import 'package:flutter/material.dart';
import 'package:tasko_app/Text.dart';
import 'package:tasko_app/TaskModel.dart';
import 'package:tasko_app/MetricsModel.dart';
import 'package:admob_flutter/admob_flutter.dart';

class SettingsPage extends StatefulWidget{

  _SettingsPageState createState() => _SettingsPageState();

}

String getBannerAdUnitId()
{
  return "ca-app-pub-6998319902801484/9161902559";
}
String getAppId()
{
  return "ca-app-pub-6998319902801484~3511880816";
}

class _SettingsPageState extends State<SettingsPage> {
  String dropdownValue = "1 Day";
  CreateMetricsDB metrics_db_ref;
  Future update_task_frequency(value)
  async {
    metrics_db_ref.initialise();
    var completed_count = await metrics_db_ref.get_completed_count();
    var remaining_count = await metrics_db_ref.get_remaining_count();
    // Insert the completed count by 1
    var completed_count_var = Metrics(
        id: 1,
        completed_tasks:  completed_count,
        remaining_tasks: remaining_count,
        frequency: 2
    );
    await metrics_db_ref.insertMetrics(completed_count_var);

  }

  @override
  Widget build(BuildContext context) {
    metrics_db_ref = CreateMetricsDB.instance;
    metrics_db_ref.initialise();

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
            height: 100.0,
            child: ListTile(
                      title: Text("Backlog Frequency"),
                      subtitle: Text("Current support is as per the user's choice"),
                    ),
          ),
          RaisedButton(
            color: Color(0xffb41CAC6),
            splashColor: Colors.deepPurpleAccent,
            child: Text("Clear Dashboard", style: TextStyle(color: Colors.white, fontSize: 19, fontFamily: 'OpenSans'),),
            onPressed: () async{
              List<Metrics> metricsList =  await metrics_db_ref.metrics();
              for(Metrics metrics in metricsList)
              {
                await metrics_db_ref.deleteMetrics(metrics.id);
              }
              Scaffold.of(context).showSnackBar(
                  new SnackBar(
                      content: Text("All metrics are cleared")));
            },),
          Container(
            height: 70.0,
            child: Card(
              child: Row(
                children: <Widget>[
                  AppBoldText(text: "Metrics",),
                  Spacer(),
                  AppBoldText(text:"In percentage"),
                  Spacer()
                ],
              ),
            ),
          ),
          Container(
            height: 100.0,
            child: Card(
              child: Row(
                children: <Widget>[
                  AppBoldText(text: "Divide Task by",),
                  Spacer(),
                  AppBoldText(text:"1 Hour"),
                  Spacer()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}