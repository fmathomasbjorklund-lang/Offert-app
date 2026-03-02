import 'dart:math';

class PricingTemplate {
  final String id;
  final String name;
  final String trade;
  final double hourlyRate;
  final double minHours;
  final double travelFee;
  final double markupPct;

  const PricingTemplate({
    required this.id,
    required this.name,
    required this.trade,
    required this.hourlyRate,
    required this.minHours,
    required this.travelFee,
    required this.markupPct,
  });

  static String _newId() {
    // microseconds + random => praktiskt taget alltid unikt
    final ts = DateTime.now().microsecondsSinceEpoch;
    final rnd = Random().nextInt(1 << 20); // 0..~1M
    return '${ts}_$rnd';
  }

  factory PricingTemplate.newTemplate({
    required String name,
    required String trade,
    required double hourlyRate,
    required double minHours,
    required double travelFee,
    required double markupPct,
  }) {
    return PricingTemplate(
      id: _newId(),
      name: name,
      trade: trade,
      hourlyRate: hourlyRate,
      minHours: minHours,
      travelFee: travelFee,
      markupPct: markupPct,
    );
  }

  PricingTemplate copyWith({
    String? id,
    String? name,
    String? trade,
    double? hourlyRate,
    double? minHours,
    double? travelFee,
    double? markupPct,
  }) {
    return PricingTemplate(
      id: id ?? this.id,
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

  factory PricingTemplate.fromJson(Map<String, dynamic> json) {
    double asDouble(dynamic v, {double fallback = 0}) {
      if (v == null) return fallback;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? fallback;
    }

    return PricingTemplate(
      id: json['id']?.toString() ?? _newId(),
      name: json['name']?.toString() ?? '',
      trade: json['trade']?.toString() ?? '',
      hourlyRate: asDouble(json['hourlyRate'], fallback: 0),
      minHours: asDouble(json['minHours'], fallback: 0),
      travelFee: asDouble(json['travelFee'], fallback: 0),
      markupPct: asDouble(json['markupPct'], fallback: 0),
    );
  }
}