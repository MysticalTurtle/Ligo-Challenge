import 'package:equatable/equatable.dart';
import 'package:ligo_challenge/features/movements/domain/entities/movement_status.dart';
import 'package:ligo_challenge/features/movements/domain/entities/movement_type.dart';

class Movement extends Equatable {
  const Movement({
    required this.id,
    required this.description,
    required this.amount,
    required this.type,
    required this.status,
  });

  final String id;
  final String description;
  final double amount;
  final MovementType type;
  final MovementStatus status;

  @override
  List<Object> get props => [id, description, amount, type, status];
}
