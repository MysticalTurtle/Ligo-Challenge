import 'package:ligo_challenge/app/app.dart';
import 'package:ligo_challenge/bootstrap/bootstrap.dart';
import 'package:ligo_challenge/core/constants/api_constants.dart';

Future<void> main() async {
  await bootstrap(
    () => const App(
      baseUrl: ApiConstants.stagingBaseUrl,
    ),
  );
}
