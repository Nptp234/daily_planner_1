
import 'package:daily_planner_1/model/notification_logic.dart';
import 'package:daily_planner_1/state/notification_provider.dart';
import 'package:daily_planner_1/state/reorder_provider.dart';
import 'package:daily_planner_1/state/statistic_provider.dart';
import 'package:daily_planner_1/ui/wellcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

final notificationCenter = NotificationCenter();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await dotenv.load(fileName: "assets/.env");
  await notificationCenter.initializeNotifications();
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
        ChangeNotifierProvider(create: (context)=>StatisticProvider()),
        ChangeNotifierProvider(create: (context)=>NotificationProvider()),
        ChangeNotifierProvider(create: (context)=>ReorderProvider()),
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
