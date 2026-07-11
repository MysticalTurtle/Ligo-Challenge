import 'package:flutter_test/flutter_test.dart';
import 'package:ligo_challenge/features/auth/data/models/user_model.dart';
import 'package:ligo_challenge/features/auth/domain/entities/user.dart';

void main() {
  group('UserModel', () {
    const testJson = {
      'id': 'user_123',
      'name': 'John Doe',
    };

    const testUserModel = UserModel(
      id: 'user_123',
      name: 'John Doe',
    );

    test('should be a subclass of User entity', () {
      expect(testUserModel, isA<User>());
    });

    group('fromJson', () {
      test('should return a valid model from JSON', () {
        final result = UserModel.fromJson(testJson);

        expect(result, testUserModel);
        expect(result.id, 'user_123');
        expect(result.name, 'John Doe');
      });

      test('should parse different user data correctly', () {
        final differentJson = {
          'id': 'user_456',
          'name': 'Jane Smith',
        };

        final result = UserModel.fromJson(differentJson);

        expect(result.id, 'user_456');
        expect(result.name, 'Jane Smith');
      });
    });

    group('toJson', () {
      test('should return a JSON map containing the proper data', () {
        final result = testUserModel.toJson();

        expect(result, testJson);
      });

      test('should serialize different user data correctly', () {
        const differentUser = UserModel(
          id: 'user_789',
          name: 'Bob Johnson',
        );

        final result = differentUser.toJson();

        expect(result, {
          'id': 'user_789',
          'name': 'Bob Johnson',
        });
      });
    });
  });
}
