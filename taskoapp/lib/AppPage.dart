import 'package:flutter/material.dart';
import 'package:tasko_app/Text.dart';
import 'package:tasko_app/TaskModel.dart';
import 'dart:math';
import 'package:tasko_app/MetricsModel.dart';
import 'package:admob_flutter/admob_flutter.dart';

class AppPage extends StatefulWidget{

  _AppPageState createState() => _AppPageState();

}


String getBannerAdUnitId()
{
  return "ca-app-pub-6998319902801484/2530520374";
}
String getAppId()
{
  return "ca-app-pub-6998319902801484~3511880816";
}
class _AppPageState extends State<AppPage> {
  final taskNameController = TextEditingController();
  String dropdownValue;
  List<String> dropDownOption = <String>[
    '1 Hr',
    '2 Hr',
    '3 Hr',
    '4 Hr'
  ];
  int index;
  var tasks_db_ref = CreateDB.instance;
  var metrics_db_ref = CreateMetricsDB.instance;
  var rng = new Random();
  
  Future<List<Task>> get_total_tasks()
  async {
    tasks_db_ref.initialise();
    var list_valuues = await tasks_db_ref.tasks();
    return list_valuues;
  }
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Widget _future_operation;
  Widget ReturnFutureValues()
  {
    setState((){
      _future_operation = FutureBuilder(
        builder: (context, snapshot){
          if(snapshot.data == null || snapshot.data.length < 1)
          {
            return Center(
                child:Container(
                  child: ListTile(
                    title: Text("Give us some time to crunch your numbers", style: TextStyle(color: Colors.black45, fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Pacifico'), textAlign: TextAlign.center,),
                    subtitle: AppBoldText(text: "If you dont have any tasks added. Press the Button Below"),
                  ),
                )
            );
          }
          else
          {
            return ListView.builder(
                itemCount: snapshot.data.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, index){
                  Task task_data = snapshot.data[index];
                  return ListTile(
                    onTap: (){
                      Scaffold.of(context).showSnackBar(new SnackBar(
                        content: Text("You can remove the task by long press"),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 1),
                      ));
                    },
                    onLongPress: (){
                      //Logic to remove the task from the DB
                      return showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text("You want to remove "+task_data.task_name+" from your list?", style: TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.bold),),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text("Yes!"),
                                  onPressed: () async{
                                    await tasks_db_ref.deleteTask(task_data.id);
//                              Create a snackbar for user confirmation
                                    final snackBar = new SnackBar(
                                      content: Text("Task - "+task_data.task_name+" is removed"),
                                      backgroundColor: Colors.deepPurpleAccent,
                                      duration: Duration(seconds: 1),


                                    );
                                    _scaffoldKey.currentState.showSnackBar(snackBar);
                                    Navigator.of(context).pop();
                                    ReturnFutureValues();
                                  },
                                ),
                                FlatButton(
                                  child: Text("No!"),
                                  onPressed: (){
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          }
                      );

                    },
                    title: AppBoldText(text: task_data.task_name,),
                    subtitle: Text(task_data.duration),
                    trailing: Column(
                      children: <Widget>[
                        Container(child:IconButton(
                          onPressed: () async{
                            metrics_db_ref.initialise();
                            var completed_count = await metrics_db_ref.get_completed_count();
                            var remaining_count = await metrics_db_ref.get_remaining_count();
                            var frequency = await metrics_db_ref.get_current_frequency();
                            // Insert the completed count by 1
                            var completed_count_var = Metrics(
                                id: 1,
                                completed_tasks:  ++completed_count,
                                remaining_tasks: remaining_count,
                                frequency: frequency
                            );
                            await metrics_db_ref.insertMetrics(completed_count_var);
                            await tasks_db_ref.deleteTask(task_data.id);
//                              Create a snackbar for user confirmation
                            Scaffold.of(context).showSnackBar(new SnackBar(
                              content: Text("Task - "+task_data.task_name+" is done"),
                              backgroundColor: Colors.lightGreen,
                              duration: Duration(seconds: 1),

                            ));
                            ReturnFutureValues();
                          },
                          icon: Icon(Icons.done_outline),
                          color: Colors.green,
                        ),
                          height: 25.0,
                        ),
                        Container(
                          child:IconButton(
                            onPressed: () async{
                              metrics_db_ref.initialise();
                              var completed_count = await metrics_db_ref.get_completed_count();
                              var remaining_count = await metrics_db_ref.get_remaining_count();
                              var frequency = await metrics_db_ref.get_current_frequency();
                              // Insert the completed count by 1
                              var completed_count_var = Metrics(
                                  id: 1,
                                  completed_tasks:  completed_count,
                                  remaining_tasks: ++remaining_count,
                                  frequency: frequency
                              );
                              await metrics_db_ref.insertMetrics(completed_count_var);
                              // Remove this task from the DB
                              await tasks_db_ref.deleteTask(task_data.id);
//                              Create a snackbar for user confirmation
                              Scaffold.of(context).showSnackBar(new SnackBar(
                                content: Text("Task - "+task_data.task_name+" is not done"),
                                backgroundColor: Colors.redAccent,
                                duration: Duration(seconds: 1),
                              ));
                              ReturnFutureValues();
                            },
                            icon: Icon(Icons.do_not_disturb),
                            color: Colors.red,
                          ),
                          height: 25.0,
                        )
                      ],
                    ),
                  );
                });
          }


        },
        future: get_total_tasks(),
      );
    });
  }
  Future<Widget> _dialog_operation;

  Future<Widget> ReturnDialogOption()
  {
    setState((){
      _dialog_operation = showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text("Task Name :"),
                      Flexible(child: TextField(
                        controller: taskNameController,
                      ))
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text("Choose Duration :"),
                      DropdownButton<String>(
                        value: dropdownValue,
                        onChanged: (newValue) {
                          setState(() {
                            index = dropDownOption.indexOf(newValue);
                            dropdownValue = dropDownOption[index];
                            print(dropdownValue);
                            ReturnDialogOption();
                          });
                        },
                        items: dropDownOption
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )
                    ],
                  )
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Done"),
                onPressed: () async{
                  if(taskNameController.text != "")
                    {
                  var task = Task(
                      id: rng.nextInt(1000),
                      task_name: taskNameController.text,
                      duration: dropdownValue
                  );
                  await tasks_db_ref.initialise();
                  tasks_db_ref.insertTask(task);
                  ReturnFutureValues();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                    }
                  else{
                    final snackbar = new SnackBar(
                      content: Text("Cannot input empty Values"),
                      backgroundColor: Colors.redAccent,
                    );
                    _scaffoldKey.currentState.showSnackBar(snackbar);
                  }
                  },
              )
            ],
          );
        },
      );
    });

    return _dialog_operation;
  }
  @override
  Widget build(BuildContext context) {
    ReturnFutureValues();
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: Column(children: <Widget>[
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
          _future_operation
        ],),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          return ReturnDialogOption();
        },
        backgroundColor: Color(0XFFB41CAC6),
        child: Icon(Icons.toc),),
    );
  }
}









