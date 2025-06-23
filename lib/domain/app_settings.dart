import 'dart:ui';

import 'package:good_manager/domain/entities/customers_setting.dart';
import 'package:good_manager/domain/entities/documents_setting.dart';
import 'package:good_manager/domain/entities/goods_setting.dart';
import 'package:good_manager/domain/entities/minimum_quantity_settings.dart';
import 'package:good_manager/domain/entities/my_company.dart';
import 'package:good_manager/domain/entities/payments_setting.dart';
import 'package:good_manager/domain/entities/save_document_setting.dart';
import 'package:good_manager/domain/entities/stores_setting.dart';
import 'package:good_manager/domain/entities/suppliers_setting.dart';

abstract class AppSettings{
  MyCompany getMyCompany();
  void setMyCompany(MyCompany obj);
  MinimumQuantitySettings getMinimumQuantitySettings();
  void setMinimumQuantitySettings(MinimumQuantitySettings obj);
  SuppliersSetting getSuppliersSetting();
  void setSuppliersSetting(SuppliersSetting obj);

  CustomersSetting getCustomersSetting();
  void setCustomersSetting(CustomersSetting obj);

  GoodsSetting getGoodsSetting();
  void setGoodsSetting(GoodsSetting obj);

  DocumentsSetting getDocumentsSetting();
  void setDocumentsSetting(DocumentsSetting obj);

  StoresSetting getStoresSetting();
  void setStoresSetting(StoresSetting obj);

  SaveDocumentSetting getSaveDocumentSetting();
  void setSaveDocumentSetting(SaveDocumentSetting obj);

  PaymentsSetting getPaymentsSetting();
  void setPaymentsSetting(PaymentsSetting obj);

  Color getIncomingDocumentColor();
  void setIncomingDocumentColor(Color color);


  Color getOutgoingDocumentColor();
  void setOutgoingDocumentColor(Color color);
}