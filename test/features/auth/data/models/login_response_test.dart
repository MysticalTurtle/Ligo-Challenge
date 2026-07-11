import 'package:flutter_test/flutter_test.dart';
import 'package:ligo_challenge/features/auth/data/models/login_response.dart';
import 'package:ligo_challenge/features/auth/data/models/user_model.dart';

void main() {
  group('LoginResponse', () {
    const testUserModel = UserModel(
      id: 'user_123',
      name: 'John Doe',
    );

    const testJson = {
      'token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9',
      'user': {
        'id': 'user_123',
        'name': 'John Doe',
      },
    };

    const testLoginResponse = LoginResponse(
      token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9',
      user: testUserModel,
    );

    group('fromJson', () {
      test('should return a valid model from JSON', () {
        final result = LoginResponse.fromJson(testJson);

        expect(result.token, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9');
        expect(result.user, testUserModel);
        expect(result.user.id, 'user_123');
        expect(result.user.name, 'John Doe');
      });

      test('should parse different response data correctly', () {
        final differentJson = {
          'token': 'different_token_value',
          'user': {
            'id': 'user_456',
            'name': 'Jane Smith',
          },
        };

        final result = LoginResponse.fromJson(differentJson);

        expect(result.token, 'different_token_value');
        expect(result.user.id, 'user_456');
        expect(result.user.name, 'Jane Smith');
      });
    });

    group('toJson', () {
      test('should return a JSON map containing the proper data', () {
        final result = testLoginResponse.toJson();

        expect(result, testJson);
      });

      test('should serialize different response data correctly', () {
        const differentUser = UserModel(
          id: 'user_789',
          name: 'Bob Johnson',
        );

        const differentResponse = LoginResponse(
          token: 'another_token',
          user: differentUser,
        );

        final result = differentResponse.toJson();

        expect(result, {
          'token': 'another_token',
          'user': {
            'id': 'user_789',
            'name': 'Bob Johnson',
          },
        });
      });
    });
  });
}
