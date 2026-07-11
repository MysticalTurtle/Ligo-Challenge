import 'package:flutter/material.dart';

enum MovementType {
  incoming('in', 'Ingresos'),
  outgoing('out', 'Salidas');

  const MovementType(this.value, this.name);

  final String value;
  final String name;

  IconData get icon => isIncoming ? Icons.arrow_downward : Icons.arrow_upward;
  Color get color => isIncoming ? Colors.green : Colors.red;
  Color get backgroundColor =>
      isIncoming ? Colors.green[100]! : Colors.red[100]!;
  String get symbol => isIncoming ? '+' : '-';

  static MovementType fromString(String value) {
    return MovementType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => throw ArgumentError('Invalid movement type: $value'),
    );
  }
}

extension MovementTypeExtension on MovementType {
  bool get isIncoming => this == MovementType.incoming;
  bool get isOutgoing => this == MovementType.outgoing;
}
