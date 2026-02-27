import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AppState {
  static const _key = 'project_drafts_v1';
  static final List<ProjectDraft> drafts = [];

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return;

    final list = jsonDecode(raw) as List<dynamic>;
    drafts
      ..clear()
      ..addAll(list.map((e) => ProjectDraft.fromJson(e)));
  }

  static Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(drafts.map((d) => d.toJson()).toList());
    await prefs.setString(_key, raw);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppState.load();
  runApp(const OffertApp());
}

class OffertApp extends StatelessWidget {
  const OffertApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Offert',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openNewProject(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ProjectScreen()),
    );
  }

  void _openProjectsList(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ProjectsListScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Offert")),
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

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _clientNameController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _clientNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveDraft() async {
    if (!_formKey.currentState!.validate()) return;

    final draft = ProjectDraft(
      title: _titleController.text.trim(),
      clientName: _clientNameController.text.trim(),
      notes: _notesController.text.trim(),
      createdAt: DateTime.now(),
    );

    AppState.drafts.insert(0, draft);
    await AppState.save();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Utkast sparat: "${draft.title}"')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nytt projekt")),
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
              ElevatedButton(
                onPressed: _saveDraft,
                child: const Text("Spara utkast"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProjectsListScreen extends StatelessWidget {
  const ProjectsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final drafts = AppState.drafts;

    return Scaffold(
      appBar: AppBar(title: const Text("Mina projekt")),
      body: drafts.isEmpty
          ? const Center(child: Text("Inga projekt ännu"))
          : ListView.builder(
              itemCount: drafts.length,
              itemBuilder: (context, i) {
                final d = drafts[i];
                return ListTile(
                  title: Text(d.title),
                  subtitle: Text(d.clientName),
                );
              },
            ),
    );
  }
}

class ProjectDraft {
  final String title;
  final String clientName;
  final String notes;
  final DateTime createdAt;

  ProjectDraft({
    required this.title,
    required this.clientName,
    required this.notes,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'clientName': clientName,
        'notes': notes,
        'createdAt': createdAt.toIso8601String(),
      };

  factory ProjectDraft.fromJson(Map<String, dynamic> json) => ProjectDraft(
        title: json['title'],
        clientName: json['clientName'],
        notes: json['notes'],
        createdAt: DateTime.parse(json['createdAt']),
      );
}