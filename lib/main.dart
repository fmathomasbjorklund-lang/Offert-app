import 'package:flutter/material.dart';

import 'services/storage_service.dart';
import 'state/app_state.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appState = AppState(StorageService());
  await appState.init();

  runApp(OffertApp(appState: appState));
}

class OffertApp extends StatelessWidget {
  final AppState appState;

  const OffertApp({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Offert',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: HomeScreen(appState: appState),
    );
  }
}