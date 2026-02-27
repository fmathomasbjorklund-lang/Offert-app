import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/project_draft.dart';

class StorageService {
  static const String _draftsKey = 'project_drafts_v1';

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
}