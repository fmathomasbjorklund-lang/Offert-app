import 'package:flutter/foundation.dart';
import '../models/project_draft.dart';
import '../services/storage_service.dart';

class AppState extends ChangeNotifier {
  final StorageService _storage;
  final List<ProjectDraft> _drafts = [];

  AppState(this._storage);

  List<ProjectDraft> get drafts => List.unmodifiable(_drafts);

  Future<void> init() async {
    final loaded = await _storage.loadDrafts();
    _drafts
      ..clear()
      ..addAll(loaded);
    notifyListeners();
  }

  ProjectDraft? getById(String id) {
    for (final d in _drafts) {
      if (d.id == id) return d;
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
}