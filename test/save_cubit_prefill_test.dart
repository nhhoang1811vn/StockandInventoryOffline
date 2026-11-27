import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/domain/entity/entity.dart';
import 'package:good_manager/domain/usecase/usecase.dart';
import 'package:good_manager/presentation/pages/save_customer/bloc/save_customer_cubit.dart';
import 'package:good_manager/presentation/pages/save_supplier/bloc/save_supplier_cubit.dart';

class _FakeSuppliersUseCase extends Fake implements SuppliersUseCase {}

class _FakeCustomersUseCase extends Fake implements CustomersUseCase {}

void main() {
  group('SaveSupplierCubit.init', () {
    SaveSupplierCubit cubit() =>
        SaveSupplierCubit(useCase: _FakeSuppliersUseCase());

    test('new supplier with prefilled values keeps them in state', () {
      final c = cubit();
      c.init(Supplier()
        ..name = 'Nguyen Van An'
        ..description = 'Cong ty ABC'
        ..address = '12 Le Loi'
        ..email = 'an@example.com'
        ..phone = '0901234567');
      expect(c.state.name.value, 'Nguyen Van An');
      expect(c.state.name.isValid, isTrue);
      expect(c.state.description, 'Cong ty ABC');
      expect(c.state.address, '12 Le Loi');
      expect(c.state.email, 'an@example.com');
      expect(c.state.phone, '0901234567');
    });

    test('blank new supplier leaves the name pure (no error on open)', () {
      final c = cubit();
      c.init(Supplier());
      expect(c.state.name.isPure, isTrue);
    });
  });

  group('SaveCustomerCubit.init', () {
    SaveCustomerCubit cubit() =>
        SaveCustomerCubit(useCase: _FakeCustomersUseCase());

    test('new customer with prefilled values keeps them in state', () {
      final c = cubit();
      c.init(Customer()
        ..name = 'Nguyen Van An'
        ..description = 'Cong ty ABC'
        ..address = '12 Le Loi'
        ..email = 'an@example.com'
        ..phone = '0901234567');
      expect(c.state.name.value, 'Nguyen Van An');
      expect(c.state.name.isValid, isTrue);
      expect(c.state.description, 'Cong ty ABC');
      expect(c.state.address, '12 Le Loi');
      expect(c.state.email, 'an@example.com');
      expect(c.state.phone, '0901234567');
    });

    test('blank new customer leaves the name pure (no error on open)', () {
      final c = cubit();
      c.init(Customer());
      expect(c.state.name.isPure, isTrue);
    });
  });
}
