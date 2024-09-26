import 'package:daily_planner_1/data/api/plans_api.dart';
import 'package:daily_planner_1/model/notification_logic.dart';
import 'package:daily_planner_1/state/statistic_provider.dart';
import 'package:daily_planner_1/ui/wellcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
Future<void> showNotification(String title, String description) async{
  try{
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails("planner1", "Planner Daily", importance: Importance.high, priority: Priority.high, showWhen: true);
    NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
      0, 
      title, 
      description, 
      notificationDetails
    );
  }
  catch(e){
    rethrow;
  }
  }

void callbackDispatcher(){
  Workmanager().executeTask(
    (t, inputData) async{
      
      await showNotification("Test", "Testing");
      return Future.value(true);
    }
  );
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);  // Set false in production
  runApp(const MainApp());
}

class MainApp extends StatefulWidget{
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainApp();
}

class _MainApp extends State<MainApp> {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>StatisticProvider())
      ],
      child: MaterialApp(
        theme: ThemeData(
            colorScheme: const ColorScheme.light(),
            useMaterial3: true,
          ),
        home: WellcomePage()
      ),
    );
  }
}
