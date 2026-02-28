import 'package:flutter/material.dart';
import '../state/app_state.dart';
import 'edit_template_screen.dart';

class TemplatesListScreen extends StatelessWidget {
  final AppState appState;

  const TemplatesListScreen({super.key, required this.appState});

  Future<void> _confirmDelete(BuildContext context, String templateId) async {
    final t = appState.getTemplateById(templateId);
    if (t == null) return;

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Ta bort mall?"),
        content: Text('Vill du ta bort "${t.name}"?'),
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
      await appState.deleteTemplate(templateId);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mall borttagen")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        final templates = appState.templates;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Mallar"),
            actions: [
              IconButton(
                tooltip: "Ny mall",
                icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => EditTemplateScreen(appState: appState),
                    ),
                  );
                },
              )
            ],
          ),
          body: templates.isEmpty
              ? const Center(child: Text("Inga mallar ännu"))
              : ListView.separated(
                  itemCount: templates.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final t = templates[i];
                    return ListTile(
                      title: Text(t.name),
                      subtitle: Text(
                        "${t.trade} • ${t.hourlyRate.toStringAsFixed(0)} €/h • min ${t.minHours.toStringAsFixed(1)} h",
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: "Redigera",
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => EditTemplateScreen(
                                    appState: appState,
                                    templateId: t.id,
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            tooltip: "Ta bort",
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => _confirmDelete(context, t.id),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}