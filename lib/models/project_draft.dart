class ProjectDraft {
  final String id; // stabilt id för edit/delete
  final String title;
  final String clientName;
  final String notes;
  final DateTime createdAt;

  // koppling till pris-mall (valfritt)
  final String? pricingTemplateId;

  ProjectDraft({
    required this.id,
    required this.title,
    required this.clientName,
    required this.notes,
    required this.createdAt,
    this.pricingTemplateId,
  });

  /// Hjälpare för att skapa nya projekt
  factory ProjectDraft.newDraft({
    required String title,
    required String clientName,
    required String notes,
    String? pricingTemplateId,
  }) {
    final now = DateTime.now();
    return ProjectDraft(
      id: now.microsecondsSinceEpoch.toString(),
      title: title,
      clientName: clientName,
      notes: notes,
      createdAt: now,
      pricingTemplateId: pricingTemplateId,
    );
  }

  ProjectDraft copyWith({
    String? title,
    String? clientName,
    String? notes,
    String? pricingTemplateId,
    bool clearPricingTemplateId = false,
  }) {
    return ProjectDraft(
      id: id,
      title: title ?? this.title,
      clientName: clientName ?? this.clientName,
      notes: notes ?? this.notes,
      createdAt: createdAt,
      pricingTemplateId:
          clearPricingTemplateId ? null : (pricingTemplateId ?? this.pricingTemplateId),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'clientName': clientName,
        'notes': notes,
        'createdAt': createdAt.toIso8601String(),
        'pricingTemplateId': pricingTemplateId,
      };

  /// Bakåtkompatibel: om gamla sparade objekt saknar id så skapar vi ett från createdAt
  factory ProjectDraft.fromJson(Map<String, dynamic> json) {
    final createdAt = DateTime.parse(json['createdAt'] as String);
    final id = (json['id'] as String?) ?? createdAt.microsecondsSinceEpoch.toString();

    return ProjectDraft(
      id: id,
      title: (json['title'] ?? '') as String,
      clientName: (json['clientName'] ?? '') as String,
      notes: (json['notes'] ?? '') as String,
      createdAt: createdAt,
      pricingTemplateId: json['pricingTemplateId'] as String?,
    );
  }
}