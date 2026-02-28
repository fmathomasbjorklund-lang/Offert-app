import 'package:flutter/material.dart';
import '../models/project_draft.dart';
import '../state/app_state.dart';

class ProjectScreen extends StatefulWidget {
  final AppState appState;

  const ProjectScreen({super.key, required this.appState});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _clientNameController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedTemplateId;

  @override
  void dispose() {
    _titleController.dispose();
    _clientNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveDraft() async {
    if (!_formKey.currentState!.validate()) return;

    final draft = ProjectDraft.newDraft(
      title: _titleController.text.trim(),
      clientName: _clientNameController.text.trim(),
      notes: _notesController.text.trim(),
      pricingTemplateId: _selectedTemplateId,
    );

    await widget.appState.addDraft(draft);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Utkast sparat: "${draft.title}"')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final templates = widget.appState.templates;

    return Scaffold(
      appBar: AppBar(title: const Text("Nytt projekt")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String?>(
                value: _selectedTemplateId,
                decoration: const InputDecoration(
                  labelText: "Pris-mall",
                  border: OutlineInputBorder(),
                ),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text("Ingen mall"),
                  ),
                  ...templates.map(
                    (t) => DropdownMenuItem<String?>(
                      value: t.id,
                      child: Text("${t.trade} • ${t.name}"),
                    ),
                  ),
                ],
                onChanged: (v) => setState(() => _selectedTemplateId = v),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Projektets titel",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? "Fyll i en titel" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _clientNameController,
                decoration: const InputDecoration(
                  labelText: "Kundens namn",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Beskrivning",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _saveDraft,
                  child: const Text("Spara utkast"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}