import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../purchase_manager.dart';
import '../../constants.dart';

class SubscriptionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SubscriptionPageState();
  }
}

class SubscriptionPageState extends State<SubscriptionPage> {
  final purchaseManager = PurchaseManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(context), body: _buildBody(context));
  }

  Widget _buildBody(BuildContext context) {
    return ListView(padding: EdgeInsets.all(16), children: [
      //_buildPro(),
      //SizedBox(height: 16),
      _buildProLifetime()
    ]);
  }

  // Widget _buildPro() {
  //   return Card(
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text("Pro", style: Theme.of(context).textTheme.titleLarge),
  //           SizedBox(
  //             height: 16,
  //           ),
  //           Text(AppLocalizations.of(context)!.pro_benefits_description),
  //           SizedBox(
  //             height: 16,
  //           ),
  //           Row(
  //             children: [
  //               if (purchaseManager.proMonthlyProductDetail != null)
  //                 Expanded(
  //                   child: ElevatedButton(
  //                       onPressed: () {
  //                         purchaseManager.buyProMonthly();
  //                       },
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: Colors.blue,
  //                         // Background color
  //                         foregroundColor: Colors.white,
  //                         // Text color
  //                         elevation: 4,
  //                         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(12),
  //                         ),
  //                       ),
  //                       child: Column(children: [
  //                         Text(AppLocalizations.of(context)!.monthly,
  //                             style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white)),
  //                         Text(purchaseManager.proMonthlyProductDetail!.price,
  //                             style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white))
  //                       ])),
  //                 ),
  //               SizedBox(
  //                 width: 16,
  //               ),
  //               if (purchaseManager.proYearlyProductDetail != null)
  //                 Expanded(
  //                   child: ElevatedButton(
  //                       onPressed: () {
  //                         purchaseManager.buyProYearly();
  //                       },
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: Colors.blue,
  //                         // Background color
  //                         foregroundColor: Colors.white,
  //                         // Text color
  //                         elevation: 4,
  //                         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(12),
  //                         ),
  //                       ),
  //                       child: Column(children: [
  //                         Text(AppLocalizations.of(context)!.yearly,
  //                             style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white)),
  //                         Text(purchaseManager.proYearlyProductDetail!.price,
  //                             style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white))
  //                       ])),
  //                 ),
  //             ],
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildProLifetime() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pro LifeTime", style: Theme.of(context).textTheme.titleLarge),
            SizedBox(
              height: 16,
            ),
            Text(AppLocalizations.of(context)!.pro_lifetime_benefits_description),
            SizedBox(
              height: 16,
            ),
            if (purchaseManager.proLifeTimeProductDetail != null)
              Center(
                  child: ElevatedButton(
                      onPressed: () {
                        purchaseManager.buyProLifeTime();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Column(children: [
                        Text(
                          AppLocalizations.of(context)!.payonce,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white),
                        ),
                        Text(purchaseManager.proLifeTimeProductDetail!.price,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white))
                      ])))
            else
              Text("This product is not ready at this moment, please try again later")
          ],
        ),
      ),
    );
  }

  PreferredSize _buildAppBar(BuildContext context) {
    return PreferredSize(
        preferredSize: Size.fromHeight(UIConstants.appBarHeight),
        child: AppBar(title: Text(AppLocalizations.of(context)!.subscriptions_title), actions: <Widget>[]));
  }
}
