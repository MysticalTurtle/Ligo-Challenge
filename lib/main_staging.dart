import 'package:ligo_challenge/app/app.dart';
import 'package:ligo_challenge/bootstrap/bootstrap.dart';

Future<void> main() async {
  await bootstrap(
    () => const App(),
  );
}
