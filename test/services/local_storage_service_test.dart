import 'package:flutter_test/flutter_test.dart';
import 'package:pocket/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('LocalStorageServiceTest -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
