import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pocket/app/app.bottomsheets.dart';
import 'package:pocket/app/app.dialogs.dart';
import 'package:pocket/app/app.locator.dart';
import 'package:pocket/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  setupDialogUi();
  setupBottomSheetUi();
  await Permission.microphone.request();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: Routes.startupView,
      onGenerateRoute: StackedRouter().onGenerateRoute,
      navigatorKey: StackedService.navigatorKey,
      debugShowCheckedModeBanner: false,
      navigatorObservers: [StackedService.routeObserver],
    );
  }
}
