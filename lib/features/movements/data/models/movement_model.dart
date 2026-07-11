import 'package:ligo_challenge/features/movements/domain/entities/movement.dart';
import 'package:ligo_challenge/features/movements/domain/entities/movement_status.dart';
import 'package:ligo_challenge/features/movements/domain/entities/movement_type.dart';

class MovementModel extends Movement {
  const MovementModel({
    required super.id,
    required super.description,
    required super.amount,
    required super.type,
    required super.status,
  });

  factory MovementModel.fromJson(Map<String, dynamic> json) {
    return MovementModel(
      id: json['id'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: MovementType.fromString(json['type'] as String),
      status: MovementStatus.fromString(json['status'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'description': description,
    'amount': amount,
    'type': type.value,
    'status': status.value,
  };
}
