import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/presentation/pages/main/main_page.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constant/constant.dart';
import '../../../data/app_settings.dart';
import '../../../domain/entity/entity.dart';
import '../../../util/util.dart';
import '../../dialog/dialog.dart';
import '../../markdown/md_provider_factory.dart';
import '../../widget/widget.dart';
import '../pages.dart';
import 'bloc/menu_cubit.dart';

class MenuPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MenuPageState();
  }
}

class MenuPageState extends State<MenuPage> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );
  bool _isPro = false;

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    _loadIsPro();
  }

  void _loadIsPro() async {
    bool isPro = await RevenueCatService.isPro();
    setState(() {
      _isPro = isPro;
    });
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Widget _buildStockPremiumBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        "Premium",
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MenuCubit, MenuState>(
        listener: (context, state) async {},
        builder:
            (context, state) =>

      Scaffold(
      appBar: LogoAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildProfileCard(),
          SizedBox(height: 16,),
          // Card(
          //   clipBehavior: Clip.antiAlias,
          //   margin: EdgeInsets.all(16),
          //   child: Column(
          //     children: [
          //       SizedBox(height: 16),
          //       _buildProfile(),
          //       SizedBox(height: 16),
          //       buildDivider(indent: 0),
          //       if (isAnonymous)
          //         Column(
          //           children: [
          //             ListTile(
          //               leading: Icon(Icons.upgrade),
          //               title: Text(
          //                 context.tr("menu_item_upgrade_account"),
          //               ),
          //               onTap: () => onUpgradeAccountItemPressed(),
          //             ),
          //             buildDivider(),
          //           ],
          //         ),
          //       buildDivider(),
          //       ListTile(
          //         leading: Icon(UIConstants.settingIconData),
          //         title: Text(context.tr("settings")),
          //         trailing: Icon(Icons.navigate_next),
          //         onTap: () => onSettingsItemPressed(context),
          //       ),
          //       buildDivider(),
          //       ListTile(
          //         leading: Icon(Icons.production_quantity_limits),
          //         title:
          //             Text(context.tr("subscriptions_title")),
          //         trailing: Icon(Icons.navigate_next),
          //         onTap: () => onSubscriptionItemPressed(context),
          //       ),
          //     ],
          //   ),
          // ),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(UIConstants.storeIconData),
                  title: Text(context.tr("stores")),
                  trailing: Icon(Icons.navigate_next),
                  onTap: () => onStoresItemPressed(context),
                ),
                buildDivider(),
                ListTile(
                  leading: Icon(Icons.change_circle),
                  title:
                      Text(context.tr("change_tracking_store")),
                  subtitle: Text("${AppSettings.getSelectedStoreName()}"),
                  trailing: Icon(Icons.navigate_next),
                  onTap: () => onChangeTrackingStoreItemPressed(context),
                ),
              ],
            ),
          ),
          SizedBox(height: 16,),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.mail_outline),
                  title: Text(
                    context.tr("invite_friend"),
                  ),
                  onTap: () => onInviteFriend(context),
                ),
                buildDivider(),
                ListTile(
                  leading: Icon(Icons.question_answer_outlined),
                  title: Text(
                    context.tr("question_or_suggestion_title"),
                  ),
                  onTap: () => onSelectMessageType(context),
                ),
                buildDivider(),
                ListTile(
                  leading: Icon(Icons.star),
                  title:
                      Text(context.tr("review_the_app_title")),
                  onTap: () async {
                    //NotificationService.showNotification(id: 1, title: "title", body: "body");
                    final InAppReview inAppReview = InAppReview.instance;
                    if (await inAppReview.isAvailable()) {
                      inAppReview.requestReview();
                    } else {
                      await inAppReview.openStoreListing();
                    }
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 16,),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.help_outline),
                  title: Text(context.tr("help_title")),
                  trailing: Icon(Icons.navigate_next),
                  onTap: () => onHelp(context),
                ),
                buildDivider(),
                ListTile(
                  leading: Icon(Icons.flag_outlined),
                  title: Text(context.tr("whats_new_title")),
                  onTap: () => onWhatsNew(context),
                  trailing: Icon(Icons.navigate_next),
                ),
                buildDivider(),
                ListTile(
                  leading: Icon(Icons.description_outlined),
                  title: Text(context.tr("terms_of_use_title")),
                  onTap: () => onTermsOfUse(),
                  trailing: Icon(Icons.navigate_next),
                ),
                buildDivider(),
                ListTile(
                  leading: Icon(Icons.security),
                  title:
                      Text(context.tr("privacy_policy_title")),
                  onTap: () => onPrivacyPolicy(),
                  trailing: Icon(Icons.navigate_next),
                ),
              ],
            ),
          ),
          SizedBox(height: 16,),
          if (FirebaseAuth.instance.currentUser?.isAnonymous ==
              false) ...[
            Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.close),
                    title: Text(
                      context.tr("delete_account"),
                    ),
                    onTap: () => onDeleteAccountItemPressed(),
                  ),
                  buildDivider(),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text(context.tr("sign_out")),
                    //trailing: Icon(Icons.navigate_next),
                    onTap: () => onLogoutItemPressed(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          Center(child: Text("version".tr(args: [_packageInfo.version]))),
          SizedBox(height: 32),
        ],
      ),
    ));
  }
  Widget _buildProfileCard() {
    bool isAnonymous = FirebaseAuth.instance.currentUser?.isAnonymous ?? false;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          if (isAnonymous) _buildAnonymousInfo() else _buildUserInfo(),
          SizedBox(height: 8),
          if (_isPro) _buildStockPremiumBadge(),
          SizedBox(height: 16),
          Divider(height: 0),
          ListTile(
            leading: Icon(UIConstants.settingIconData),
            title: Text(context.tr("settings")),
            trailing: Icon(Icons.navigate_next),
            onTap: () => onSettingsItemPressed(context),
          ),
          Divider(height: 0),
          ListTile(
            leading: Icon(Icons.production_quantity_limits),
            title: Text("subscriptions_title").tr(),
            trailing: Icon(Icons.navigate_next),
            onTap: () async {
              await RevenueCatUI.presentPaywall();
            },
          ),
          Divider(height: 0),
          // ListTile(
          //   leading: Icon(Icons.search),
          //   title: Text("store_policy").tr(),
          //   trailing: Icon(Icons.navigate_next),
          //   onTap: () {
          //     context.go("/store_policy");
          //   },
          // ),
        ],
      ),
    );
  }
  Widget _buildAnonymousInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 16),
        CircleAvatar(
          radius: 30,
          child: Image(image: AssetImage('assets/images/user.png')),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(Pages.link_with);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "sign_up_or_login",
                style: Theme.of(context).textTheme.titleMedium,
              ).tr(),
              Icon(Icons.navigate_next),
            ],
          ),
        ),
        SizedBox(height: 8),
        Text("you_are_currently_on_guess_mode").tr(),
      ],
    );
  }

  Widget _buildUserInfo() {
    final user = FirebaseAuth.instance.currentUser;
    String? photoUrl;
    String? displayName;
    String? email = user?.email;
    photoUrl = user?.photoURL;
    displayName = user?.displayName;

    // if (email == null || email.isEmpty)
    // if (photoUrl == null && user?.providerData.isNotEmpty == true) {
    //   photoUrl = user!.providerData.first.photoURL;
    // }
    //
    // if (displayName == null ||
    //     displayName.isEmpty && user?.providerData.isNotEmpty == true) {
    //   displayName = user?.providerData.first.displayName;
    // }
    if (user?.providerData.isNotEmpty == true){
      var first = user!.providerData.first;
      email = first.email ?? "n/a";
      photoUrl = first.photoURL;
      displayName = first.displayName ?? "n/a";
    }


    //email = user?.email ?? "n/a";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 16),
        photoUrl != null
            ? CircleAvatar(radius: 30, backgroundImage: NetworkImage(photoUrl))
            : CircleAvatar(
          radius: 30,
          child: Image(image: AssetImage('assets/images/user.png')),
        ),
        SizedBox(height: 8),
        Text(displayName ?? "n/a", style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: 8),
        Text(email ?? "n/a"),
      ],
    );
  }

  void onDeleteAccountItemPressed() {
    showCustomAlertDialog(
      context,
      message: context.tr("message_confirm_delete_account"),
      onPositivePressed: () async{
        Navigator.of(context).pop();
        await context.read<MenuCubit>().deleteAccount();
        Navigator.of(context).pushNamedAndRemoveUntil(Pages.loading_data, (Route<dynamic> route) => false);
      },
    );
  }

  void onStoresItemPressed(BuildContext context) {
    Navigator.of(context)
        .pushNamed(Pages.store_list, arguments: {"isSelection": false});
  }

  void onChangeTrackingStoreItemPressed(BuildContext context) async {
    final result = await Navigator.of(context)
        .pushNamed(Pages.store_list, arguments: {"isSelection": true});
    if (result != null) {
      Store store = result as Store;

      AppSettings.setSelectedStoreId(store.id!);
      AppSettings.setSelectedStoreName(store.name);

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MainPage()),
        (Route<dynamic> route) => false, // Remove all previous routes
      );
    }
  }

  void onSettingsItemPressed(BuildContext context) {
    Navigator.of(context).pushNamed(Pages.settings);
  }

  void onSubscriptionItemPressed(BuildContext context) async {
    await RevenueCatUI.presentPaywall();
    //Navigator.of(context).pushNamed(Pages.subscriptions);
  }

  void onInviteFriend(BuildContext context) {
    var subject = "invitation_using_app".tr();
    var body = "invitation_using_app_content".tr(
      namedArgs: {
        'androidLink': Config.androidStoreLink,
        'iOSLink': Config.iOSStoreLink,
      },
    );
    onSendMail(subject, body, "");

  }
  void onSelectMessageType(BuildContext context) async {
    var type = await showSelectMessageType(context);
    if (type != null) {
      String subject = Config.appName;
      subject += " - ${type.getText(context)}";
      subject += " - $platformInfo";
      onSendMail(subject, "", Config.supportEmail);
    }
  }

  Future<MessageType?> showSelectMessageType(BuildContext context) async {
    return await showModalBottomSheet<MessageType>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                context.tr("select_message_type"),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Column(
              children: MessageType.values
                  .map(
                    (type) => ListTile(
                      title: Text(type.getText(context)),
                      onTap: () => Navigator.pop(context, type),
                    ),
                  )
                  .toList(),
            ),
          ],
        );
      },
    );
  }
  final platformInfo = Platform.operatingSystem;
  String encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (e) =>
      '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
    ).join('&');
  }
  void onSendMail(String subject, String body, String path) {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: path,
      query: encodeQueryParameters(<String, String>{
        "subject": subject,
        "body": body,
      }),
    );
    launchUrl(emailLaunchUri);
  }

  void onWhatsNew(BuildContext context) async {
    Navigator.of(context).pushNamed(
      Pages.help,
      arguments: {
        "title": context.tr("whats_new"),
        "content": MDProviderFactory.get().getWhatNews(),
      },
    );
  }

  void onTermsOfUse() async {
    NavigatorUtils.openUrl(Config.termOfUseUrl);
  }

  void onPrivacyPolicy() async {
    NavigatorUtils.openUrl(Config.privacyPolicyUrl);
  }

  void onHelp(BuildContext context) {
    Navigator.of(context).pushNamed(Pages.helps, arguments: {});
  }

  void onDonation(BuildContext context) {
    Navigator.of(context).pushNamed(
      Pages.help,
      arguments: {
        "title": context.tr("menu_item_donation"),
        "content": MDProviderFactory.get().getDonationText(),
      },
    );
  }

  void onLogoutItemPressed() {
    showCustomAlertDialog(
      context,
      message: context.tr("signout_message"),
      onPositivePressed: () async {
        Navigator.of(context).pop();
        showCustomAlertDialog(
          context,
          message: context.tr("question_push_data"),
          onPositivePressed: () async {
            Navigator.of(context).pop();
            await context.read<MenuCubit>().upload();
            context.read<MenuCubit>().signOut();
            Navigator.of(context).pushNamedAndRemoveUntil(Pages.loading_data, (Route<dynamic> route) => false);
          },
          onNegativePressed: () async {
            Navigator.of(context).pop();
            context.read<MenuCubit>().signOut();
            Navigator.of(context).pushNamedAndRemoveUntil(Pages.loading_data, (Route<dynamic> route) => false);
          },
        );
      },
    );
  }
}
