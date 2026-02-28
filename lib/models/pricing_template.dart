class PricingTemplate {
  final String id;
  final String name; // t.ex. "Snickare - Standard"
  final String trade; // t.ex. "Snickare"
  final double hourlyRate; // €/h
  final double minHours; // min debitering i timmar
  final double travelFee; // fast reseersättning (€)
  final double markupPct; // påslag i %

  PricingTemplate({
    required this.id,
    required this.name,
    required this.trade,
    required this.hourlyRate,
    required this.minHours,
    required this.travelFee,
    required this.markupPct,
  });

  factory PricingTemplate.newTemplate({
    required String name,
    required String trade,
    required double hourlyRate,
    required double minHours,
    required double travelFee,
    required double markupPct,
  }) {
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    return PricingTemplate(
      id: id,
      name: name,
      trade: trade,
      hourlyRate: hourlyRate,
      minHours: minHours,
      travelFee: travelFee,
      markupPct: markupPct,
    );
  }

  PricingTemplate copyWith({
    String? name,
    String? trade,
    double? hourlyRate,
    double? minHours,
    double? travelFee,
    double? markupPct,
  }) {
    return PricingTemplate(
      id: id,
      name: name ?? this.name,
      trade: trade ?? this.trade,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      minHours: minHours ?? this.minHours,
      travelFee: travelFee ?? this.travelFee,
      markupPct: markupPct ?? this.markupPct,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'trade': trade,
        'hourlyRate': hourlyRate,
        'minHours': minHours,
        'travelFee': travelFee,
        'markupPct': markupPct,
      };

  factory PricingTemplate.fromJson(Map<String, dynamic> json) => PricingTemplate(
        id: (json['id'] ?? '') as String,
        name: (json['name'] ?? '') as String,
        trade: (json['trade'] ?? '') as String,
        hourlyRate: (json['hourlyRate'] as num?)?.toDouble() ?? 0,
        minHours: (json['minHours'] as num?)?.toDouble() ?? 0,
        travelFee: (json['travelFee'] as num?)?.toDouble() ?? 0,
        markupPct: (json['markupPct'] as num?)?.toDouble() ?? 0,
      );
}