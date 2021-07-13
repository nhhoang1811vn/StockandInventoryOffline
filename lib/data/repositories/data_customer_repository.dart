import 'package:good_manager/data/utils/constants.dart';
import 'package:good_manager/db/db_helper.dart';
import 'package:good_manager/domain/entities/customer.dart';
import 'package:good_manager/domain/entities/customers_settings.dart';
import 'package:good_manager/domain/entities/sort_by_text.dart';
import 'package:good_manager/domain/repositories/customer_repositories.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataCustomerRepository implements CustomerRepository {
  //Singleton object of 'DataStoreRepository'
  static DataCustomerRepository _instance = DataCustomerRepository._internal();

  //Constructor
  DataCustomerRepository._internal() {}

  factory DataCustomerRepository() => _instance;

  var db = new DBHelper();

  @override
  Future<List<Customer>> getAll() {
    return db.getCustomers();
  }

  @override
  Future<int> getCount() {
    return db.getCountCustomer();
  }

  @override
  Future<int> insert(Customer item) {
    return db.insertCustomer(item);
  }

  @override
  Future<bool> update(Customer item) {
    return db.updateCustomer(item);
  }

  @override
  Future<CustomersSettings> getSettings() async {
    var settings = CustomersSettings();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    settings.sortByName = SortByTextHelper.get(
        preferences.getInt(Constants.sortByNameCustomerKey));
    return settings;
  }

  @override
  Future<bool> setSettings(CustomersSettings settings) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt(Constants.sortByNameCustomerKey,
        SortByTextHelper.getValue(settings.sortByName));
  }

  @override
  Future<bool> delete(int id) {
    return db.deleteCustomer(id);
  }

  @override
  Future<Customer> get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }
}
