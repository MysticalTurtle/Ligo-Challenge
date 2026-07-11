import 'package:flutter_test/flutter_test.dart';
import 'package:ligo_challenge/features/movements/data/models/movement_model.dart';
import 'package:ligo_challenge/features/movements/domain/entities/movement.dart';
import 'package:ligo_challenge/features/movements/domain/entities/movement_status.dart';
import 'package:ligo_challenge/features/movements/domain/entities/movement_type.dart';

void main() {
  group('MovementModel', () {
    const testJson = {
      'id': 'mov_001',
      'description': 'Pago QR',
      'amount': 25.5,
      'type': 'out',
      'status': 'completed',
    };

    const testMovementModel = MovementModel(
      id: 'mov_001',
      description: 'Pago QR',
      amount: 25.5,
      type: MovementType.outgoing,
      status: MovementStatus.completed,
    );

    test('should be a subclass of Movement entity', () {
      expect(testMovementModel, isA<Movement>());
    });

    group('fromJson', () {
      test('should return a valid model from JSON', () {
        final result = MovementModel.fromJson(testJson);

        expect(result, testMovementModel);
        expect(result.id, 'mov_001');
        expect(result.description, 'Pago QR');
        expect(result.amount, 25.5);
        expect(result.type, MovementType.outgoing);
        expect(result.status, MovementStatus.completed);
      });

      test('should parse incoming movement correctly', () {
        final incomingJson = {
          ...testJson,
          'type': 'in',
        };

        final result = MovementModel.fromJson(incomingJson);

        expect(result.type, MovementType.incoming);
      });

      test('should parse pending status correctly', () {
        final pendingJson = {
          ...testJson,
          'status': 'pending',
        };

        final result = MovementModel.fromJson(pendingJson);

        expect(result.status, MovementStatus.pending);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing the proper data', () {
        final result = testMovementModel.toJson();

        expect(result, testJson);
      });
    });
  });
}
