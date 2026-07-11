import 'package:flutter_test/flutter_test.dart';
import 'package:ligo_challenge/features/movements/domain/entities/movement_type.dart';

void main() {
  group('MovementType', () {
    test('incoming returns correct value and name', () {
      expect(MovementType.incoming.value, 'in');
      expect(MovementType.incoming.name, 'Ingresos');
      expect(MovementType.incoming.isIncoming, isTrue);
      expect(MovementType.incoming.isOutgoing, isFalse);
    });

    test('outgoing returns correct value and name', () {
      expect(MovementType.outgoing.value, 'out');
      expect(MovementType.outgoing.name, 'Salidas');
      expect(MovementType.outgoing.isIncoming, isFalse);
      expect(MovementType.outgoing.isOutgoing, isTrue);
    });

    test('fromString parses value correctly', () {
      expect(MovementType.fromString('in'), MovementType.incoming);
      expect(MovementType.fromString('out'), MovementType.outgoing);
    });

    test('fromString throws ArgumentError for invalid value', () {
      expect(
        () => MovementType.fromString('invalid'),
        throwsArgumentError,
      );
    });
  });
}
