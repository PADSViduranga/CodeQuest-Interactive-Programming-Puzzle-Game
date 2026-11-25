import 'package:flutter_test/flutter_test.dart';

import 'package:codequest/core/router/app_routes.dart';

void main() {
  test('login route path is stable', () {
    expect(AppRoutes.login, '/login');
  });
}
