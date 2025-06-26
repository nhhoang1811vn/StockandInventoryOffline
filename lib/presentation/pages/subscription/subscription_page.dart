// import 'package:flutter/material.dart';
// import 'package:good_manager/revenuecat_purchase_manager.dart';
// import 'package:purchases_flutter/models/offering_wrapper.dart';
// import 'package:purchases_flutter/models/offerings_wrapper.dart';
// import 'package:purchases_flutter/models/package_wrapper.dart';
//
// import '../../../l10n/app_localizations.dart';
// import '../../constants.dart';
//
// class SubscriptionPage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return SubscriptionPageState();
//   }
// }
//
// class SubscriptionPageState extends State<SubscriptionPage> {
//   Offerings? offerings;
//   Package? monthlyPackage;
//   Package? yearlyPackage;
//   Package? lifeTimePackage;
//   String monthlyIdentifier = "\$rc_monthly";
//   String yearlyIdentifier = "\$rc_annual";
//   String lifeTimeIdentifier = "\$rc_lifetime";
//   //bool _purchaseMonthly = false;
//   //bool _purchaseYearly = false;
//   bool _purchaseSubscription = false;
//   bool _purchaseLifeTime = false;
//   @override
//   void initState(){
//     super.initState();
//     loadData();
//   }
//   Future<void> loadData() async {
//     final result = await RevenueCatService.getOfferings();
//     final purchaseSubscription = await RevenueCatService.isProSubscription();
//     final purchaseLifeTime = await RevenueCatService.isProLifeTime();
//     setState(() {
//       offerings = result;
//       if (offerings?.current != null){
//         monthlyPackage = offerings!.current!.availablePackages.firstWhereOrNull((package) => package.identifier == monthlyIdentifier);
//         yearlyPackage = offerings!.current!.availablePackages.firstWhereOrNull((package) => package.identifier == yearlyIdentifier);
//         lifeTimePackage = offerings!.current!.availablePackages.firstWhereOrNull((package) => package.identifier == lifeTimeIdentifier);
//       }
//       _purchaseSubscription = purchaseSubscription;
//       _purchaseLifeTime = purchaseLifeTime;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(appBar: _buildAppBar(context), body: _buildBody(context));
//   }
//
//   Widget _buildBody(BuildContext context) {
//     return ListView(padding: EdgeInsets.all(16), children: [
//       if (monthlyPackage != null && yearlyPackage != null)
//         _buildPro(_purchaseSubscription),
//       //  _buildProLifetime(monthlyPackage!, _purchaseMonthly),
//       //if (yearlyPackage != null)
//       //  _buildProLifetime(yearlyPackage!, _purchaseYearly),
//       if (lifeTimePackage != null)
//         _buildProLifetime(lifeTimePackage!, _purchaseLifeTime)
//     ]);
//   }
//
//   Widget _buildPro(bool isPurchase) {
//     var title = "Pro";
//     var description = AppLocalizations.of(context)!.pro_benefits_description;
//     var monthlyButtonText = AppLocalizations.of(context)!.monthly;
//     var yearlyButtonText = AppLocalizations.of(context)!.yearly;
//     if (isPurchase){
//       title += "(Active)";
//     }
//     var monthlyPriceText = monthlyPackage!.storeProduct.priceString;
//     var yearlyPriceText = yearlyPackage!.storeProduct.priceString;
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(title, style: Theme.of(context).textTheme.titleMedium),
//             SizedBox(
//               height: 16,
//             ),
//             Text(description),
//             SizedBox(
//               height: 16,
//             ),
//             Row(
//               children: [
//                   Expanded(
//                     child: ElevatedButton(
//                         onPressed: (){
//                           RevenueCatService.purchase(monthlyPackage!);
//                           //setState(() async{
//                           //  _purchaseSubscription = await RevenueCatService.isProSubscription();
//                           //});
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue,
//                           foregroundColor: Colors.white,
//                           elevation: 4,
//                           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: Column(children: [
//                           Text(monthlyButtonText,
//                               style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white)),
//                           Text(monthlyPriceText,
//                               style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white))
//                         ])),
//                   ),
//                 SizedBox(
//                   width: 16,
//                 ),
//                   Expanded(
//                     child: ElevatedButton(
//                         onPressed: (){
//                           RevenueCatService.purchase(yearlyPackage!);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue,
//                           foregroundColor: Colors.white,
//                           disabledBackgroundColor: Colors.grey,
//                           elevation: 4,
//                           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: Column(children: [
//                           Text(yearlyButtonText,
//                               style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white)),
//                           Text(yearlyPriceText,
//                               style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white))
//                         ])),
//                   ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProLifetime(Package package, bool isPurchase){
//     var title = "Pro - Lifetime";
//     //var title = package.storeProduct.title;
//     //var description = package.storeProduct.description; //AppLocalizations.of(context)!.pro_lifetime_benefits_description
//     var description = AppLocalizations.of(context)!.pro_lifetime_benefits_description;
//     var buttonText = AppLocalizations.of(context)!.payonce;
//     if (isPurchase){
//       title += "(Active)";
//     }
//     var priceText = package.storeProduct.priceString;
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(title, style: Theme.of(context).textTheme.titleMedium),
//             SizedBox(
//               height: 16,
//             ),
//             Text(description),
//             SizedBox(
//               height: 16,
//             ),
//               SizedBox(width: double.infinity, child: ElevatedButton(
//                   onPressed: (){
//                       RevenueCatService.purchase(package);
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                     foregroundColor: Colors.white,
//                     elevation: 4,
//                     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: Column(children: [
//                     Text(
//                       buttonText,
//                       style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white),
//                     ),
//                     Text(priceText,
//                         style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white))
//                   ])))
//           ],
//         ),
//       ),
//     );
//   }
//
//   PreferredSize _buildAppBar(BuildContext context) {
//     return PreferredSize(
//         preferredSize: Size.fromHeight(UIConstants.appBarHeight),
//         child: AppBar(title: Text(AppLocalizations.of(context)!.subscriptions_title), actions: <Widget>[]));
//   }
// }
