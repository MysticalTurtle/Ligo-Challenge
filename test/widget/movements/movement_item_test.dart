import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ligo_challenge/features/movements/domain/entities/movement.dart';
import 'package:ligo_challenge/features/movements/domain/entities/movement_status.dart';
import 'package:ligo_challenge/features/movements/domain/entities/movement_type.dart';
import 'package:ligo_challenge/features/movements/presentation/widgets/movement_item.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('MovementItem Widget', () {
    const incomingMovement = Movement(
      id: 'mov_001',
      description: 'Pago recibido',
      amount: 100.50,
      type: MovementType.incoming,
      status: MovementStatus.completed,
    );

    const outgoingMovement = Movement(
      id: 'mov_002',
      description: 'Pago realizado',
      amount: 50.25,
      type: MovementType.outgoing,
      status: MovementStatus.completed,
    );

    const pendingMovement = Movement(
      id: 'mov_003',
      description: 'Pago pendiente',
      amount: 75,
      type: MovementType.incoming,
      status: MovementStatus.pending,
    );

    testWidgets('renders movement information correctly', (tester) async {
      await tester.pumpApp(
        const MovementItem(movement: incomingMovement),
      );

      // Verify description is shown
      expect(find.text('Pago recibido'), findsOneWidget);

      // Verify ID is shown
      expect(find.text('mov_001'), findsOneWidget);

      // Verify amount is shown with correct format
      expect(find.text(r'+$100.50'), findsOneWidget);

      // Verify status is shown
      expect(find.text('completed'), findsOneWidget);
    });

    group('Incoming movement rendering', () {
      testWidgets('displays correct icon for incoming movement', (
        tester,
      ) async {
        await tester.pumpApp(
          const MovementItem(movement: incomingMovement),
        );

        // Find the icon within CircleAvatar
        final circleAvatar = find.byType(CircleAvatar);
        expect(circleAvatar, findsOneWidget);

        final icon = find.descendant(
          of: circleAvatar,
          matching: find.byIcon(Icons.arrow_downward),
        );
        expect(icon, findsOneWidget);
      });

      testWidgets('displays correct color for incoming movement', (
        tester,
      ) async {
        await tester.pumpApp(
          const MovementItem(movement: incomingMovement),
        );

        // Find the CircleAvatar
        final circleAvatar = tester.widget<CircleAvatar>(
          find.byType(CircleAvatar),
        );

        // Verify background color
        expect(circleAvatar.backgroundColor, Colors.green[100]);

        // Find the icon and verify its color
        final icon = tester.widget<Icon>(
          find.descendant(
            of: find.byType(CircleAvatar),
            matching: find.byType(Icon),
          ),
        );
        expect(icon.color, Colors.green);
      });

      testWidgets('displays positive symbol for incoming movement', (
        tester,
      ) async {
        await tester.pumpApp(
          const MovementItem(movement: incomingMovement),
        );

        // Verify amount has positive symbol
        expect(find.textContaining(r'+$'), findsOneWidget);
      });

      testWidgets('displays amount in green for incoming movement', (
        tester,
      ) async {
        await tester.pumpApp(
          const MovementItem(movement: incomingMovement),
        );

        // Find the Text widget that contains the amount
        final amountText = tester
            .widgetList<Text>(
              find.text(r'+$100.50'),
            )
            .first;

        // Verify text color is green
        expect(amountText.style?.color, Colors.green);
      });
    });

    group('Outgoing movement rendering', () {
      testWidgets('displays correct icon for outgoing movement', (
        tester,
      ) async {
        await tester.pumpApp(
          const MovementItem(movement: outgoingMovement),
        );

        // Find the icon within CircleAvatar
        final icon = find.descendant(
          of: find.byType(CircleAvatar),
          matching: find.byIcon(Icons.arrow_upward),
        );
        expect(icon, findsOneWidget);
      });

      testWidgets('displays correct color for outgoing movement', (
        tester,
      ) async {
        await tester.pumpApp(
          const MovementItem(movement: outgoingMovement),
        );

        // Find the CircleAvatar
        final circleAvatar = tester.widget<CircleAvatar>(
          find.byType(CircleAvatar),
        );

        // Verify background color
        expect(circleAvatar.backgroundColor, Colors.red[100]);

        // Find the icon and verify its color
        final icon = tester.widget<Icon>(
          find.descendant(
            of: find.byType(CircleAvatar),
            matching: find.byType(Icon),
          ),
        );
        expect(icon.color, Colors.red);
      });

      testWidgets('displays negative symbol for outgoing movement', (
        tester,
      ) async {
        await tester.pumpApp(
          const MovementItem(movement: outgoingMovement),
        );

        // Verify amount has negative symbol
        expect(find.textContaining(r'-$'), findsOneWidget);
      });

      testWidgets('displays amount in red for outgoing movement', (
        tester,
      ) async {
        await tester.pumpApp(
          const MovementItem(movement: outgoingMovement),
        );

        // Find the Text widget that contains the amount
        final amountText = tester
            .widgetList<Text>(
              find.text(r'-$50.25'),
            )
            .first;

        // Verify text color is red
        expect(amountText.style?.color, Colors.red);
      });
    });

    group('Movement status display', () {
      testWidgets('displays completed status with green styling', (
        tester,
      ) async {
        await tester.pumpApp(
          const MovementItem(movement: incomingMovement),
        );

        // Verify status text is shown
        expect(find.text('completed'), findsOneWidget);

        // Find the status container
        final statusText = tester
            .widgetList<Text>(
              find.text('completed'),
            )
            .first;

        // Verify green text color for completed status
        expect(statusText.style?.color, Colors.green);
      });

      testWidgets('displays pending status with orange styling', (
        tester,
      ) async {
        await tester.pumpApp(
          const MovementItem(movement: pendingMovement),
        );

        // Verify status text is shown
        expect(find.text('pending'), findsOneWidget);

        // Find the status text
        final statusText = tester
            .widgetList<Text>(
              find.text('pending'),
            )
            .first;

        // Verify orange text color for pending status
        expect(statusText.style?.color, Colors.orange);
      });

      testWidgets('status badge has correct background color for completed', (
        tester,
      ) async {
        await tester.pumpApp(
          const MovementItem(movement: incomingMovement),
        );

        // Find the Container that holds the status badge
        final containers = tester.widgetList<Container>(find.byType(Container));

        // Find the status badge container (the one with the status text as child)
        final statusBadge = containers.firstWhere((container) {
          final decoration = container.decoration as BoxDecoration?;
          return decoration?.color == Colors.green[50];
        });

        final decoration = statusBadge.decoration as BoxDecoration;
        expect(decoration.color, Colors.green[50]);
      });

      testWidgets('status badge has correct background color for pending', (
        tester,
      ) async {
        await tester.pumpApp(
          const MovementItem(movement: pendingMovement),
        );

        // Find the Container that holds the status badge
        final containers = tester.widgetList<Container>(find.byType(Container));

        // Find the status badge container
        final statusBadge = containers.firstWhere((container) {
          final decoration = container.decoration as BoxDecoration?;
          return decoration?.color == Colors.orange[50];
        });

        final decoration = statusBadge.decoration as BoxDecoration;
        expect(decoration.color, Colors.orange[50]);
      });
    });

    group('Navigation on tap', () {
      testWidgets('is wrapped in InkWell for tap interaction', (tester) async {
        await tester.pumpApp(
          const MovementItem(movement: incomingMovement),
        );

        // Verify InkWell exists
        expect(find.byType(InkWell), findsOneWidget);
      });

      testWidgets('InkWell has onTap callback', (tester) async {
        await tester.pumpApp(
          const MovementItem(movement: incomingMovement),
        );

        final inkWell = tester.widget<InkWell>(find.byType(InkWell));

        // Verify onTap is not null
        expect(inkWell.onTap, isNotNull);
      });

      testWidgets('entire card is tappable', (tester) async {
        await tester.pumpApp(
          const MovementItem(movement: incomingMovement),
        );

        // Verify we can find the InkWell
        expect(find.byType(InkWell), findsOneWidget);

        // Verify InkWell has an onTap callback
        final inkWell = tester.widget<InkWell>(find.byType(InkWell));
        expect(inkWell.onTap, isNotNull);

        // Note: Actually tapping would require GoRouter context,
        // which is tested in integration tests
      });
    });

    group('Amount formatting', () {
      testWidgets('formats amount with 2 decimal places', (tester) async {
        const movementWithDecimals = Movement(
          id: 'mov_004',
          description: 'Test',
          amount: 123.456,
          type: MovementType.incoming,
          status: MovementStatus.completed,
        );

        await tester.pumpApp(
          const MovementItem(movement: movementWithDecimals),
        );

        // Verify amount is formatted to 2 decimal places
        expect(find.text(r'+$123.46'), findsOneWidget);
      });

      testWidgets('formats whole numbers with .00', (tester) async {
        const wholeNumberMovement = Movement(
          id: 'mov_005',
          description: 'Test',
          amount: 100,
          type: MovementType.outgoing,
          status: MovementStatus.completed,
        );

        await tester.pumpApp(
          const MovementItem(movement: wholeNumberMovement),
        );

        // Verify amount includes .00
        expect(find.text(r'-$100.00'), findsOneWidget);
      });
    });

    group('Layout and styling', () {
      testWidgets('renders as a Card widget', (tester) async {
        await tester.pumpApp(
          const MovementItem(movement: incomingMovement),
        );

        expect(find.byType(Card), findsOneWidget);
      });

      testWidgets('has proper elevation', (tester) async {
        await tester.pumpApp(
          const MovementItem(movement: incomingMovement),
        );

        final card = tester.widget<Card>(find.byType(Card));
        expect(card.elevation, 2);
      });

      testWidgets('CircleAvatar is displayed', (tester) async {
        await tester.pumpApp(
          const MovementItem(movement: incomingMovement),
        );

        expect(find.byType(CircleAvatar), findsOneWidget);
      });
    });
  });
}
