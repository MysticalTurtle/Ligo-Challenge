import 'package:flutter_test/flutter_test.dart';
import 'package:ligo_challenge/features/auth/data/models/login_request.dart';

void main() {
  group('LoginRequest', () {
    const testLoginRequest = LoginRequest(
      user: 'testuser',
      password: 'testpassword',
    );

    group('toJson', () {
      test('should return a JSON map containing the proper data', () {
        final result = testLoginRequest.toJson();

        expect(result, {
          'user': 'testuser',
          'password': 'testpassword',
        });
      });

      test('should serialize different credentials correctly', () {
        const differentRequest = LoginRequest(
          user: 'admin@example.com',
          password: 'securePassword123',
        );

        final result = differentRequest.toJson();

        expect(result, {
          'user': 'admin@example.com',
          'password': 'securePassword123',
        });
      });

      test('should handle empty strings', () {
        const emptyRequest = LoginRequest(
          user: '',
          password: '',
        );

        final result = emptyRequest.toJson();

        expect(result, {
          'user': '',
          'password': '',
        });
      });
    });
  });
}
