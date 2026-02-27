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

  Future<void> addDraft(ProjectDraft draft) async {
    _drafts.insert(0, draft);
    await _storage.saveDrafts(_drafts);
    notifyListeners();
  }

  Future<void> deleteDraft(ProjectDraft draft) async {
    _drafts.remove(draft);
    await _storage.saveDrafts(_drafts);
    notifyListeners();
  }
}