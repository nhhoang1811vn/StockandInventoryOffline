import 'package:good_manager/domain/entities/customer.dart';
import 'package:good_manager/domain/entities/customers_settings.dart';
import 'package:good_manager/domain/repositories/base_common_repository.dart';

abstract class CustomerRepository
    extends BaseCommonRepository<Customer, CustomersSettings> {}
