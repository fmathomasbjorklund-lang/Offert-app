import 'package:flutter/material.dart';
import '../models/project_draft.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final ProjectDraft draft;

  const ProjectDetailsScreen({super.key, required this.draft});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Projekt")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              draft.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
  }
}