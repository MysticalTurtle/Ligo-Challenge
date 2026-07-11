import 'package:flutter/material.dart';
import 'package:ligo_challenge/features/movements/domain/entities/movement.dart';
import 'package:ligo_challenge/features/movements/domain/entities/movement_status.dart';
import 'package:ligo_challenge/features/movements/domain/entities/movement_type.dart';

class MovementDetailPage extends StatelessWidget {
  const MovementDetailPage({
    required this.movement,
    super.key,
  });

  final Movement movement;

  @override
  Widget build(BuildContext context) {
    final isIncoming = movement.type.isIncoming;
    final isCompleted = movement.status == MovementStatus.completed;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Movimiento'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      isIncoming ? Icons.arrow_downward : Icons.arrow_upward,
                      size: 64,
                      color: isIncoming ? Colors.green : Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${isIncoming ? '+' : '-'}\$${movement.amount.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(
                            color: isIncoming ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movement.type.isIncoming ? 'Ingreso' : 'Salida',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildDetailRow(
              context,
              label: 'Descripción',
              value: movement.description,
            ),
            const Divider(height: 32),
            _buildDetailRow(
              context,
              label: 'ID de Transacción',
              value: movement.id,
            ),
            const Divider(height: 32),
            _buildDetailRow(
              context,
              label: 'Estado',
              value: movement.status.value,
              valueWidget: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isCompleted ? Colors.green[50] : Colors.orange[50],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  movement.status.value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isCompleted ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required String label,
    required String value,
    Widget? valueWidget,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        valueWidget ??
            Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
      ],
    );
  }
}
