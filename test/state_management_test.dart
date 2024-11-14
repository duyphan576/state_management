import 'package:flutter_test/flutter_test.dart';

import 'package:state_management/state_management_package.dart';

void main() {
  group('StateManagement', () {
    final stateManagement = StateManagement();

    test('Khởi tạo state với giá trị mặc định', () {
      stateManagement.initState('counter', 0);
      expect(stateManagement.getState('counter'), 0);
    });

    test('Cập nhật state đồng bộ', () {
      stateManagement.updateStateSync('counter', 1);
      expect(stateManagement.getState('counter'), 1);
    });

    test('Cập nhật state bất đồng bộ', () async {
      await stateManagement.updateStateAsync('counter', Future.value(2));
      expect(stateManagement.getState('counter'), 2);
    });

    test('Reset state', () {
      stateManagement.resetState('counter');
      expect(stateManagement.getState('counter'), null);
    });
  });
}
