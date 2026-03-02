// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter

import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;

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

  static String _money(double value) => value.toStringAsFixed(2);

  static String _sanitizeFileName(String input) {
    final cleaned = input
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
    return cleaned.isEmpty ? 'projekt' : cleaned;
  }

  static List<Map<String, dynamic>> _extractLines(dynamic maybeLines) {
    if (maybeLines is! List) return const [];

    final result = <Map<String, dynamic>>[];
    for (final item in maybeLines) {
      if (item is Map<String, dynamic>) {
        result.add(item);
      } else if (item is Map) {
        result.add(Map<String, dynamic>.from(item));
      }
    }
    return result;
  }

  static double _asDouble(dynamic value, {double fallback = 0}) {
    if (value == null) return fallback;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? fallback;
  }

  static Future<void> _exportPdf(
    BuildContext context,
    dynamic draft,
    dynamic template,
  ) async {
    if (!kIsWeb) return;

    final draftMap = jsonDecode(jsonEncode(draft.toJson())) as Map<String, dynamic>;
    final templateMap = template == null
        ? null
        : (jsonDecode(jsonEncode(template.toJson())) as Map<String, dynamic>);

    final title = (draftMap['title'] ?? '').toString();
    final clientName = (draftMap['clientName'] ?? '').toString();
    final notes = (draftMap['notes'] ?? '').toString();
    final lines = _extractLines(draftMap['lines']);

    final subtotal = lines.fold<double>(0, (sum, line) {
      final qty = _asDouble(line['qty']);
      final unitPrice = _asDouble(line['unitPrice']);
      return sum + (qty * unitPrice);
    });

    final markupPct = templateMap == null ? 0.0 : _asDouble(templateMap['markupPct']);
    final markup = subtotal * (markupPct / 100);
    final total = subtotal + markup;

    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) => [
          pw.Text(
            title.isEmpty ? 'Projekt' : title,
            style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          pw.Text('Client: ${clientName.trim().isEmpty ? '-' : clientName.trim()}'),
          pw.SizedBox(height: 6),
          pw.Text('Notes: ${notes.trim().isEmpty ? '-' : notes.trim()}'),
          pw.SizedBox(height: 14),
          pw.Text(
            'Pricing template',
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 6),
          if (templateMap == null)
            pw.Text('No template selected')
          else
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Trade: ${(templateMap['trade'] ?? '').toString()}'),
                pw.Text('Name: ${(templateMap['name'] ?? '').toString()}'),
                pw.Text('Hourly rate: ${_money(_asDouble(templateMap['hourlyRate']))}'),
                pw.Text('Min hours: ${_money(_asDouble(templateMap['minHours']))}'),
                pw.Text('Travel fee: ${_money(_asDouble(templateMap['travelFee']))}'),
                pw.Text('Markup %: ${_money(markupPct)}'),
              ],
            ),
          pw.SizedBox(height: 14),
          pw.Text(
            'Line items',
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 6),
          pw.TableHelper.fromTextArray(
            headers: const ['Title', 'Qty + Unit', 'Unit Price', 'Line Total'],
            data: lines.isEmpty
                ? const [<String>['-', '-', '-', '-']]
                : lines.map((line) {
                    final itemTitle = (line['title'] ?? '').toString();
                    final qty = _asDouble(line['qty']);
                    final unit = (line['unit'] ?? '').toString();
                    final unitPrice = _asDouble(line['unitPrice']);
                    final lineTotal = qty * unitPrice;
                    return <String>[
                      itemTitle,
                      '${qty.toStringAsFixed(2)} $unit',
                      _money(unitPrice),
                      _money(lineTotal),
                    ];
                  }).toList(),
          ),
          pw.SizedBox(height: 10),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Subtotal: ${_money(subtotal)}'),
                pw.Text('Markup: ${_money(markup)}'),
                pw.Text(
                  'Total: ${_money(total)}',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    final bytes = await pdf.save();
    final fileName = 'offert_${_sanitizeFileName(title)}.pdf';
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute('download', fileName)
      ..click();
    html.Url.revokeObjectUrl(url);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PDF exporterad')),
      );
    }
  }

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

        final template = draft.pricingTemplateId == null
            ? null
            : appState.getTemplateById(draft.pricingTemplateId!);

        final draftMap = draft.toJson();
        final lines = _extractLines(draftMap['lines']);
        final subtotal = lines.fold<double>(0, (sum, line) {
          final qty = _asDouble(line['qty']);
          final unitPrice = _asDouble(line['unitPrice']);
          return sum + (qty * unitPrice);
        });
        final markupPct = template?.markupPct ?? 0;
        final markup = subtotal * (markupPct / 100);
        final total = subtotal + markup;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Projekt"),
            actions: [
              TextButton(
                onPressed: () => _exportPdf(context, draft, template),
                child: const Text('Export PDF'),
              ),
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
                  "Pris-mall",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Text(
                  template == null
                      ? "Ingen mall"
                      : "${template.trade} • ${template.name} (${template.hourlyRate.toStringAsFixed(0)} €/h)",
                ),
                const SizedBox(height: 12),
                const Text(
                  "Anteckningar",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Text(draft.notes.trim().isEmpty ? "—" : draft.notes.trim()),
                const SizedBox(height: 12),
                Text('Subtotal: ${_money(subtotal)}'),
                Text('Markup: ${_money(markup)}'),
                Text('Total: ${_money(total)}'),
              ],
            ),
          ),
        );
      },
    );
  }
}




