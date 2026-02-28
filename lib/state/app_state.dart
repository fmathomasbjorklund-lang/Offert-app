import 'package:flutter/foundation.dart';
import '../models/project_draft.dart';
import '../models/pricing_template.dart';
import '../services/storage_service.dart';

class AppState extends ChangeNotifier {
  final StorageService _storage;
  final List<ProjectDraft> _drafts = [];
  final List<PricingTemplate> _templates = [];

  AppState(this._storage);

  List<ProjectDraft> get drafts => List.unmodifiable(_drafts);
  List<PricingTemplate> get templates => List.unmodifiable(_templates);

  Future<void> init() async {
    final loadedDrafts = await _storage.loadDrafts();
    _drafts
      ..clear()
      ..addAll(loadedDrafts);

    final loadedTemplates = await _storage.loadTemplates();
    _templates
      ..clear()
      ..addAll(loadedTemplates);

    // Om inga mallar finns första gången: lägg några standarder
    if (_templates.isEmpty) {
      _templates.addAll([
        PricingTemplate.newTemplate(
          name: 'Snickare - Standard',
          trade: 'Snickare',
          hourlyRate: 55,
          minHours: 2,
          travelFee: 0,
          markupPct: 0,
        ),
        PricingTemplate.newTemplate(
          name: 'Målare - Standard',
          trade: 'Målare',
          hourlyRate: 48,
          minHours: 2,
          travelFee: 0,
          markupPct: 0,
        ),
        PricingTemplate.newTemplate(
          name: 'VVS - Standard',
          trade: 'VVS',
          hourlyRate: 62,
          minHours: 1.5,
          travelFee: 0,
          markupPct: 0,
        ),
        PricingTemplate.newTemplate(
          name: 'El - Standard',
          trade: 'El',
          hourlyRate: 65,
          minHours: 1.5,
          travelFee: 0,
          markupPct: 0,
        ),
        PricingTemplate.newTemplate(
          name: 'Mark - Standard',
          trade: 'Mark',
          hourlyRate: 70,
          minHours: 3,
          travelFee: 0,
          markupPct: 0,
        ),
      ]);
      await _storage.saveTemplates(_templates);
    }

    notifyListeners();
  }

  ProjectDraft? getById(String id) {
    for (final d in _drafts) {
      if (d.id == id) return d;
    }
    return null;
  }

  PricingTemplate? getTemplateById(String id) {
    for (final t in _templates) {
      if (t.id == id) return t;
    }
    return null;
  }

  Future<void> addDraft(ProjectDraft draft) async {
    _drafts.insert(0, draft);
    await _storage.saveDrafts(_drafts);
    notifyListeners();
  }

  Future<void> deleteDraft(ProjectDraft draft) async {
    _drafts.removeWhere((d) => d.id == draft.id);
    await _storage.saveDrafts(_drafts);
    notifyListeners();
  }

  Future<void> updateDraft(ProjectDraft updated) async {
    final idx = _drafts.indexWhere((d) => d.id == updated.id);
    if (idx == -1) return;

    _drafts[idx] = updated;
    await _storage.saveDrafts(_drafts);
    notifyListeners();
  }

  Future<void> addTemplate(PricingTemplate template) async {
    _templates.insert(0, template);
    await _storage.saveTemplates(_templates);
    notifyListeners();
  }

  Future<void> updateTemplate(PricingTemplate updated) async {
    final idx = _templates.indexWhere((t) => t.id == updated.id);
    if (idx == -1) return;

    _templates[idx] = updated;
    await _storage.saveTemplates(_templates);
    notifyListeners();
  }

  Future<void> deleteTemplate(String templateId) async {
    _templates.removeWhere((t) => t.id == templateId);

    // Koppla bort mall från projekt som använder den
    for (var i = 0; i < _drafts.length; i++) {
      final d = _drafts[i];
      if (d.pricingTemplateId == templateId) {
        _drafts[i] = d.copyWith(clearPricingTemplateId: true);
      }
    }

    await _storage.saveTemplates(_templates);
    await _storage.saveDrafts(_drafts);
    notifyListeners();
  }
}