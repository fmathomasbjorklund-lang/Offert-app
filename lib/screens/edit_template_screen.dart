import 'package:flutter/material.dart';
import '../models/pricing_template.dart';
import '../state/app_state.dart';

class EditTemplateScreen extends StatefulWidget {
  final AppState appState;
  final String? templateId; // null = skapa ny

  const EditTemplateScreen({
    super.key,
    required this.appState,
    this.templateId,
  });

  @override
  State<EditTemplateScreen> createState() => _EditTemplateScreenState();
}

class _EditTemplateScreenState extends State<EditTemplateScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _hourlyRateController;
  late final TextEditingController _minHoursController;
  late final TextEditingController _travelFeeController;
  late final TextEditingController _markupPctController;

  static const _trades = <String>[
    'Snickare',
    'Målare',
    'VVS',
    'El',
    'Mark',
    'Övrigt'
  ];
  String _trade = 'Snickare';

  PricingTemplate? _existing;

  @override
  void initState() {
    super.initState();
    _existing = widget.templateId == null
        ? null
        : widget.appState.getTemplateById(widget.templateId!);

    _trade = _existing?.trade ?? 'Snickare';
    _nameController = TextEditingController(text: _existing?.name ?? '');
    _hourlyRateController =
        TextEditingController(text: (_existing?.hourlyRate ?? 55).toString());
    _minHoursController =
        TextEditingController(text: (_existing?.minHours ?? 2).toString());
    _travelFeeController =
        TextEditingController(text: (_existing?.travelFee ?? 0).toString());
    _markupPctController =
        TextEditingController(text: (_existing?.markupPct ?? 0).toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _hourlyRateController.dispose();
    _minHoursController.dispose();
    _travelFeeController.dispose();
    _markupPctController.dispose();
    super.dispose();
  }

  double _parseDouble(String s, {double fallback = 0}) {
    final normalized = s.replaceAll(',', '.').trim();
    return double.tryParse(normalized) ?? fallback;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final hourly = _parseDouble(_hourlyRateController.text, fallback: 0);
    final minH = _parseDouble(_minHoursController.text, fallback: 0);
    final travel = _parseDouble(_travelFeeController.text, fallback: 0);
    final markup = _parseDouble(_markupPctController.text, fallback: 0);

    if (_existing == null) {
      final t = PricingTemplate.newTemplate(
        name: name,
        trade: _trade,
        hourlyRate: hourly,
        minHours: minH,
        travelFee: travel,
        markupPct: markup,
      );
      await widget.appState.addTemplate(t);
    } else {
      final updated = _existing!.copyWith(
        name: name,
        trade: _trade,
        hourlyRate: hourly,
        minHours: minH,
        travelFee: travel,
        markupPct: markup,
      );
      await widget.appState.updateTemplate(updated);
    }

    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Mall sparad")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isNew = _existing == null;

    return Scaffold(
      appBar: AppBar(title: Text(isNew ? "Ny mall" : "Redigera mall")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _trade,
                decoration: const InputDecoration(
                  labelText: "Yrkesgrupp",
                  border: OutlineInputBorder(),
                ),
                items: _trades
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) => setState(() => _trade = v ?? 'Snickare'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Mallnamn",
                  hintText: "t.ex. Snickare - Standard",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? "Fyll i mallnamn" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _hourlyRateController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Timpris (€/h)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _minHoursController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Min debitering (h)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _travelFeeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Reseersättning (fast €)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _markupPctController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Påslag (%)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _save,
                  child: const Text("Spara"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}