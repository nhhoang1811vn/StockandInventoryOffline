import 'package:good_manager/presentation/pages/base/base_cubit.dart';
import 'package:good_manager/presentation/pages/save_customer/bloc/save_customer_data.dart';

class SaveCustomerCubit
    extends BaseCubit<SaveCustomerData> {
  SaveCustomerCubit(super.initialData);

  @override
  void dispose() {
    // TODO: implement dispose
  }
  /*TextEditingController addressTextController;
  TextEditingController emailTextController;
  TextEditingController phoneTextController;
  TextEditingController taxIDTextController;
  TextEditingController bankDetailsTextController;

  SaveCustomerController(repository, item)
      : super(SaveCustomerPresenter(repository), item) {
    addressTextController = TextEditingController();
    emailTextController = TextEditingController();
    phoneTextController = TextEditingController();
    taxIDTextController = TextEditingController();
    bankDetailsTextController = TextEditingController();
    addressTextController.text = item.address;
    emailTextController.text = item.email;
    phoneTextController.text = item.phone;
    taxIDTextController.text = item.taxID;
    bankDetailsTextController.text = item.bankDetail;
  }

  @override
  void updateItem() {
    super.updateItem();
    item.address = addressTextController.text;
    item.email = emailTextController.text;
    item.phone = phoneTextController.text;
    item.taxID = taxIDTextController.text;
    item.bankDetail = bankDetailsTextController.text;
  }

  @override
  Customer getOriginalItem(Customer item) {
    Customer customer = Customer();
    customer.name = item.name;
    customer.description = item.description;
    customer.address = item.address;
    customer.email = item.email;
    customer.phone = item.phone;
    customer.taxID = item.taxID;
    customer.bankDetail = item.bankDetail;
    return customer;
  }

  @override
  bool hasChanged(Customer item, Customer originalItem) {
    return (item.name != originalItem.name ||
        item.description != originalItem.description ||
        item.address != originalItem.address ||
        item.email != originalItem.email ||
        item.phone != originalItem.phone ||
        item.taxID != originalItem.taxID ||
        item.bankDetail != originalItem.bankDetail);
  }*/
}
