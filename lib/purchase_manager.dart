import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';

class PurchaseManager {
  static final PurchaseManager _instance = PurchaseManager._internal();

  factory PurchaseManager() => _instance;

  PurchaseManager._internal();

  final InAppPurchase _iap = InAppPurchase.instance;
  static const String _proMonthlyProductId = "pro_monthly";
  static const String _proYearlyProductId = "pro_yearly";
  static const String _proLifeTimeProductId = "pro_lifetime";
  final Set<String> productionIds = {
    _proMonthlyProductId,
    _proYearlyProductId,
    _proLifeTimeProductId
  };
  bool _isAvailable = false;
  List<ProductDetails> _products = [];

  List<ProductDetails> get products => _products;

  ProductDetails? get proMonthlyProductDetail =>
      _products.firstWhereOrNull((product) => product.id == _proMonthlyProductId);

  ProductDetails? get proYearlyProductDetail =>
      _products.firstWhereOrNull((product) => product.id == _proYearlyProductId);

  ProductDetails? get proLifeTimeProductDetail =>
      _products.firstWhereOrNull((product) => product.id == _proLifeTimeProductId);

  bool _purchasedProLifeTime = false;
  bool _purchasedProMonthly = false;
  bool _purchasedProYearly = false;
  Future<void> init() async {
    _isAvailable = await _iap.isAvailable();
    if (!_isAvailable) return;

    _iap.purchaseStream.listen(_handlePurchaseUpdates);
    await _loadProducts();
    await _loadPurchaseStatus();
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased
          || purchase.status == PurchaseStatus.restored
      ) {
        _verifyAndDeliver(purchase);
      }
    }
  }

  Future<void> _loadProducts() async {
    final response = await _iap.queryProductDetails(productionIds);
    _products = response.productDetails.toList();
  }

  Future<void> _loadPurchaseStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _purchasedProLifeTime = prefs.getBool('purchasedProLifeTime') ?? false;
    _purchasedProMonthly = prefs.getBool('purchasedProMonthly') ?? false;
    _purchasedProYearly = prefs.getBool('purchasedProYearly') ?? false;
  }

  void _verifyAndDeliver(PurchaseDetails purchase) async {
    final prefs = await SharedPreferences.getInstance();
    if (purchase.productID == _proLifeTimeProductId) {
      _purchasedProLifeTime = true;
      await prefs.setBool("purchasedProLifeTime", true);
    }else if (purchase.productID == _proMonthlyProductId){
      _purchasedProMonthly = true;
      await prefs.setBool("purchasedProMonthly", true);
    }else if (purchase.productID == _proYearlyProductId){
      _purchasedProYearly = true;
      await prefs.setBool("purchasedProYearly", true);
    }
  }

  Future<void> buyProLifeTime() async {
    if (_products.isEmpty) return;
    final product = _products.firstWhere((p) => p.id == _proLifeTimeProductId);
    final purchaseParam = PurchaseParam(productDetails: product);
    _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> buyProMonthly() async {
    if (_products.isEmpty) return;
    final product = _products.firstWhere((p) => p.id == _proMonthlyProductId);
    final purchaseParam = PurchaseParam(productDetails: product);
    _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> buyProYearly() async {
    if (_products.isEmpty) return;
    final product = _products.firstWhere((p) => p.id == _proYearlyProductId);
    final purchaseParam = PurchaseParam(productDetails: product);
    _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }
}
