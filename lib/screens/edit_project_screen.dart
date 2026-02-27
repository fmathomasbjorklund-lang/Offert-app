import 'package:flutter/material.dart';
import '../state/app_state.dart';

class EditProjectScreen extends StatefulWidget {
  final AppState appState;
  final String draftId;

  const EditProjectScreen({
    super.key,
    required this.appState,
    required this.draftId,
  });

  @override
  State<EditProjectScreen> createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends State<EditProjectScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _clientNameController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    final d = widget.appState.getById(widget.draftId);
    _titleController = TextEditingController(text: d?.title ?? "");
    _clientNameController = TextEditingController(text: d?.clientName ?? "");
    _notesController = TextEditingController(text: d?.notes ?? "");
  }

  @override
  void dispose() {
    _titleController.dispose();
    _clientNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final d = widget.appState.getById(widget.draftId);
    if (d == null) return;

    final updated = d.copyWith(
      title: _titleController.text.trim(),
      clientName: _clientNameController.text.trim(),
      notes: _notesController.text.trim(),
    );

    await widget.appState.updateDraft(updated);

    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Projekt uppdaterat")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Redigera projekt")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
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
                  onPressed: _save,
                  child: const Text("Spara ändringar"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}