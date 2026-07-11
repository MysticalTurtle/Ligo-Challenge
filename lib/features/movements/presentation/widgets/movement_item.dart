import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ligo_challenge/core/routing/app_routes.dart';
import 'package:ligo_challenge/features/movements/domain/entities/movement.dart';
import 'package:ligo_challenge/features/movements/domain/entities/movement_status.dart';
import 'package:ligo_challenge/features/movements/domain/entities/movement_type.dart';

/// Widget to display a single movement item
class MovementItem extends StatelessWidget {
  const MovementItem({
    required this.movement,
    super.key,
  });

  final Movement movement;

  @override
  Widget build(BuildContext context) {
    final isIncoming = movement.type.isIncoming;
    final isCompleted = movement.status == MovementStatus.completed;

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          unawaited(context.push(AppRoutes.movementDetail, extra: movement));
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: isIncoming
                    ? Colors.green[100]
                    : Colors.red[100],
                child: Icon(
                  isIncoming ? Icons.arrow_downward : Icons.arrow_upward,
                  color: isIncoming ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movement.description,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          movement.id,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? Colors.green[50]
                                : Colors.orange[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            movement.status.value,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: isCompleted
                                      ? Colors.green
                                      : Colors.orange,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                '${isIncoming ? '+' : '-'}\$${movement.amount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: isIncoming ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
