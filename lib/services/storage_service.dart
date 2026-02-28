import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/project_draft.dart';
import '../models/pricing_template.dart';

class StorageService {
  static const String _draftsKey = 'project_drafts_v2'; // v2 pga nytt fält senare
  static const String _templatesKey = 'pricing_templates_v1';

  Future<List<ProjectDraft>> loadDrafts() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_draftsKey);
    if (raw == null || raw.isEmpty) return [];

    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => ProjectDraft.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveDrafts(List<ProjectDraft> drafts) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(drafts.map((d) => d.toJson()).toList());
    await prefs.setString(_draftsKey, raw);
  }

  Future<List<PricingTemplate>> loadTemplates() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_templatesKey);
    if (raw == null || raw.isEmpty) return [];

    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => PricingTemplate.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveTemplates(List<PricingTemplate> templates) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(templates.map((t) => t.toJson()).toList());
    await prefs.setString(_templatesKey, raw);
  }
}