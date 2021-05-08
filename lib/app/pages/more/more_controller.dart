import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../pages.dart';

class MoreController extends Controller{
  @override
  void initListeners() {
  }
  void openSuppliersPage(){
    Navigator.of(getContext()).pushNamed(Pages.supplier_list,arguments: {
      'isSelection' : false
    });
  }
  void openCustomersPage(){
    /*Navigator.of(getContext()).pushNamed(Pages.customer_list,arguments: {
      'isSelection' : false
    });*/
  }
  void openStoresPage(){
    Navigator.of(getContext()).pushNamed(Pages.store_list);
  }
}