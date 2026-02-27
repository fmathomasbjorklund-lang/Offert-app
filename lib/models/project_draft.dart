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
        title: (json['title'] ?? '') as String,
        clientName: (json['clientName'] ?? '') as String,
        notes: (json['notes'] ?? '') as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}