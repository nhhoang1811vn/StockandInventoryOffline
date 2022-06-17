import 'package:good_manager/app/pages/base_list_presenter.dart';
import 'package:good_manager/domain/entities/customer.dart';
import 'package:good_manager/domain/entities/customers_settings.dart';

class CustomersPresenter
    extends BaseListPresenter<Customer, CustomersSettings> {
  CustomersPresenter(repository) : super(repository);
}
