import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constant/constant.dart';
import '../../../common/platform_support.dart';
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
  bool _restoring = false;

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocConsumer<MenuCubit, MenuState>(
      listener: (context, state) async {},
      builder: (context, state) => Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          title: Text(
            context.tr("settings"),
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),
          iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
        ),
        body: ListView(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 100),
          children: [
            SettingsSectionHeader(context.tr("inventory")),
            _buildManagementCard(),
            SettingsSectionHeader(context.tr("settings")),
            _buildSettingsCard(),
            SettingsSectionHeader(context.tr("help_title")),
            _buildSupportCard(),
            SettingsSectionHeader(context.tr("social")),
            _buildSocialCard(),
            const SizedBox(height: 32),
            Center(
              child: Text(
                "version".tr(args: [_packageInfo.version]),
                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.3),
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildManagementCard() {
    return SettingsMenuCard(
      children: [
        SettingsMenuItem(
          icon: UIConstants.storeIconData,
          title: context.tr("stores"),
          onTap: () => onStoresItemPressed(context),
        ),
        SettingsMenuItem(
          icon: UIConstants.paymentIconData,
          title: context.tr("payments_title"),
          onTap: openPayments,
        ),
        SettingsMenuItem(
          icon: Icons.category_outlined,
          title: context.tr("categories"),
          onTap: openPaymentCategories,
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildSettingsCard() {
    return SettingsMenuCard(
      children: [
        SettingsMenuItem(
          icon: UIConstants.settingIconData,
          title: context.tr("settings"),
          onTap: () => onSettingsItemPressed(context),
        ),
        SettingsMenuItem(
          icon: Icons.checklist_rounded,
          title: context.tr("good_properties"),
          tag: SettingsNewTag(label: context.tr("tag_new")),
          onTap: () =>
              Navigator.of(context).pushNamed(Pages.settings_good_properties),
        ),
        SettingsMenuItem(
          icon: Icons.description_outlined,
          title: context.tr("document_properties"),
          tag: SettingsNewTag(label: context.tr("tag_new")),
          onTap: () => Navigator.of(context)
              .pushNamed(Pages.settings_document_properties),
        ),
        SettingsMenuItem(
          icon: Icons.workspace_premium_outlined,
          title: context.tr("subscriptions_title"),
          onTap: () async => await RevenueCatUI.presentPaywall(),
          isLast: !isMobilePlatform,
        ),
        if (isMobilePlatform)
          SettingsMenuItem(
            icon: Icons.restore,
            title: context.tr("restore_purchases"),
            onTap: _onRestorePurchasesPressed,
            isLast: true,
          ),
      ],
    );
  }

  Widget _buildSupportCard() {
    return SettingsMenuCard(
      children: [
        SettingsMenuItem(
          icon: Icons.help_outline,
          title: context.tr("help_title"),
          onTap: () => onHelp(context),
        ),
        SettingsMenuItem(
          icon: Icons.new_releases_outlined,
          title: context.tr("whats_new_title"),
          onTap: () => onWhatsNew(context),
        ),
        SettingsMenuItem(
          icon: Icons.description_outlined,
          title: context.tr("terms_of_use_title"),
          onTap: () => onTermsOfUse(),
        ),
        SettingsMenuItem(
          icon: Icons.privacy_tip_outlined,
          title: context.tr("privacy_policy_title"),
          onTap: () => onPrivacyPolicy(),
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildSocialCard() {
    return SettingsMenuCard(
      children: [
        SettingsMenuItem(
          icon: Icons.share_outlined,
          title: context.tr("invite_friend"),
          onTap: () => onInviteFriend(context),
        ),
        SettingsMenuItem(
          icon: Icons.feedback_outlined,
          title: context.tr("question_or_suggestion_title"),
          onTap: () => onSelectMessageType(context),
        ),
        SettingsMenuItem(
          icon: Icons.star_outline,
          title: context.tr("review_the_app_title"),
          onTap: _openStoreReview,
          isLast: true,
        ),
      ],
    );
  }

  void onStoresItemPressed(BuildContext context) {
    Navigator.of(context)
        .pushNamed(Pages.store_list, arguments: {"isSelection": false});
  }

  void openPaymentCategories() {
    Navigator.of(context).pushNamed(Pages.payment_categories);
  }

  void openPayments() {
    Navigator.of(context).pushNamed(
      Pages.payments,
      arguments: {"setting": null, "initialIndex": 0},
    );
  }

  void onSettingsItemPressed(BuildContext context) {
    Navigator.of(context).pushNamed(Pages.settings);
  }

  /// Opens the store review page. The native in-app prompt is rate-limited by
  /// the OS and silently does nothing when the quota is used, so an explicit
  /// tap goes straight to the store listing.
  Future<void> _openStoreReview() async {
    try {
      await InAppReview.instance.openStoreListing(
        appStoreId: Config.iOSAppStoreId,
      );
    } catch (_) {
      NavigatorUtils.openUrl(
        Platform.isIOS ? Config.iOSStoreLink : Config.androidStoreLink,
      );
    }
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
      String subject =
          "${Config.appName} - ${type.getText(context)} - ${Platform.operatingSystem}";
      onSendMail(subject, "", Config.supportEmail);
    }
  }

  Future<MessageType?> showSelectMessageType(BuildContext context) async {
    return await showModalBottomSheet<MessageType>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SettingsBottomSheetTitle(
                  title: context.tr("select_message_type")),
              ...MessageType.values.map(
                (type) => ListTile(
                  contentPadding: kBottomSheetTilePadding,
                  title: Text(type.getText(context)),
                  onTap: () => Navigator.pop(context, type),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  void onSendMail(String subject, String body, String path) {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: path,
      query: _encodeQueryParameters(<String, String>{
        "subject": subject,
        "body": body,
      }),
    );
    launchUrl(emailLaunchUri);
  }

  String _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  Future<void> _onRestorePurchasesPressed() async {
    if (_restoring) return;
    _restoring = true;
    showProgressIndicator(context);
    final RestoreResult result;
    try {
      result = await RevenueCatService.restorePurchases();
    } finally {
      _restoring = false;
    }
    if (!mounted) return;
    hideDialog(context);
    switch (result) {
      case RestoreResult.proActive:
        ToastUtils.showSuccessToast(context.tr("restore_purchases_success"));
      case RestoreResult.nothingToRestore:
        ToastUtils.showErrorToast(context.tr("restore_purchases_not_found"));
      case RestoreResult.failed:
        ToastUtils.showErrorToast(context.tr("restore_purchases_failed"));
    }
    // Refreshes the Pro tag shown on Home.
    await RevenueCatService.isPro();
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

  void onTermsOfUse() => NavigatorUtils.openUrl(Config.termOfUseUrl);
  void onPrivacyPolicy() => NavigatorUtils.openUrl(Config.privacyPolicyUrl);

  void onHelp(BuildContext context) =>
      Navigator.of(context).pushNamed(Pages.helps, arguments: {});
}
