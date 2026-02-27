import 'package:flutter/material.dart';
import '../state/app_state.dart';
import 'project_details_screen.dart';

class ProjectsListScreen extends StatelessWidget {
  final AppState appState;

  const ProjectsListScreen({super.key, required this.appState});

  Future<void> _confirmDelete(BuildContext context, String draftId) async {
    final draft = appState.getById(draftId);
    if (draft == null) return;

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Ta bort projekt?"),
        content: Text('Vill du ta bort "${draft.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text("Avbryt"),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text("Ta bort"),
          ),
        ],
      ),
    );

    if (ok == true) {
      await appState.deleteDraft(draft);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Projekt borttaget")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        final drafts = appState.drafts;

        return Scaffold(
          appBar: AppBar(title: const Text("Mina projekt")),
          body: drafts.isEmpty
              ? const Center(child: Text("Inga projekt ännu"))
              : ListView.separated(
                  itemCount: drafts.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final d = drafts[i];
                    return ListTile(
                      title: Text(d.title),
                      subtitle: Text(d.clientName),
                      trailing: IconButton(
                        tooltip: "Ta bort",
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _confirmDelete(context, d.id),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ProjectDetailsScreen(
                              appState: appState,
                              draftId: d.id,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}