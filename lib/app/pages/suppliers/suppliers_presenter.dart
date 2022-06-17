import 'package:good_manager/app/pages/base_list_presenter.dart';
import 'package:good_manager/domain/entities/supplier.dart';
import 'package:good_manager/domain/entities/supplier_settings.dart';


class SuppliersPresenter extends BaseListPresenter<Supplier, SupplierSettings> {
  SuppliersPresenter(repository) : super(repository);
}