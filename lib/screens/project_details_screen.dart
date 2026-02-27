import 'package:flutter/material.dart';
import '../state/app_state.dart';
import 'edit_project_screen.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final AppState appState;
  final String draftId;

  const ProjectDetailsScreen({
    super.key,
    required this.appState,
    required this.draftId,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        final draft = appState.getById(draftId);

        if (draft == null) {
          return Scaffold(
            appBar: AppBar(title: const Text("Projekt")),
            body: const Center(child: Text("Projektet finns inte längre.")),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text("Projekt"),
            actions: [
              IconButton(
                tooltip: "Redigera",
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => EditProjectScreen(
                        appState: appState,
                        draftId: draftId,
                      ),
                    ),
                  );
                },
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Text(
                  draft.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (draft.clientName.trim().isNotEmpty)
                  Text("Kund: ${draft.clientName.trim()}"),
                const SizedBox(height: 12),
                const Text(
                  "Anteckningar",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Text(draft.notes.trim().isEmpty ? "—" : draft.notes.trim()),
              ],
            ),
          ),
        );
      },
    );
  }
}