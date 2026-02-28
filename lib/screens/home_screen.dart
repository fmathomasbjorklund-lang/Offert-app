import 'package:flutter/material.dart';
import '../state/app_state.dart';
import 'project_screen.dart';
import 'projects_list_screen.dart';
import 'templates_list_screen.dart';

class HomeScreen extends StatelessWidget {
  final AppState appState;

  const HomeScreen({super.key, required this.appState});

  void _openNewProject(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ProjectScreen(appState: appState)),
    );
  }

  void _openProjectsList(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ProjectsListScreen(appState: appState)),
    );
  }

  void _openTemplates(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => TemplatesListScreen(appState: appState)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Offert"),
        actions: [
          IconButton(
            tooltip: "Mallar",
            icon: const Icon(Icons.tune),
            onPressed: () => _openTemplates(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            const Text(
              "Välkommen",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            SizedBox(
              height: 60,
              child: ElevatedButton(
                onPressed: () => _openNewProject(context),
                child: const Text(
                  "Starta nytt projekt",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 60,
              child: OutlinedButton(
                onPressed: () => _openProjectsList(context),
                child: const Text(
                  "Mina projekt",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}