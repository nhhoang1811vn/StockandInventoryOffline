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
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        context.tr("premium"),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAnonymous = FirebaseAuth.instance.currentUser?.isAnonymous ?? false;

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
            _buildProfileCard(isAnonymous),
            SettingsSectionHeader(context.tr("inventory")),
            _buildManagementCard(),
            SettingsSectionHeader(context.tr("settings")),
            _buildSettingsCard(),
            SettingsSectionHeader(context.tr("help_title")),
            _buildSupportCard(),
            SettingsSectionHeader(context.tr("social")),
            _buildSocialCard(),
            if (!isAnonymous) ...[
              SettingsSectionHeader(context.tr("account")),
              _buildAccountActionsCard(),
            ],
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

  Widget _buildProfileCard(bool isAnonymous) {
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);
    String? photoUrl;
    String? displayName;
    String? email = user?.email;
    photoUrl = user?.photoURL;
    displayName = user?.displayName;

    if (user?.providerData.isNotEmpty == true) {
      var first = user!.providerData.first;
      email = first.email;
      photoUrl = first.photoURL;
      displayName = first.displayName;
    }
    // Windows returns "" instead of null when there is no photo.
    if (photoUrl != null && photoUrl.isEmpty) photoUrl = null;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
                alpha: theme.brightness == Brightness.dark ? 0.1 : 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: isAnonymous
            ? _buildAnonymousInfo()
            : Row(
                children: [
                  photoUrl != null
                      ? CircleAvatar(
                          radius: 35,
                          backgroundImage: NetworkImage(photoUrl),
                        )
                      : CircleAvatar(
                          radius: 35,
                          backgroundColor: theme.colorScheme.primaryContainer,
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName ?? context.tr("user"),
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        if (email != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            email,
                            style: TextStyle(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.4),
                              fontSize: 14,
                            ),
                          ),
                        ],
                        if (_isPro) ...[
                          const SizedBox(height: 8),
                          _buildStockPremiumBadge(),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildAnonymousInfo() {
    return Column(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.person,
            size: 40,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "you_are_currently_on_guess_mode".tr(),
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () => Navigator.of(context).pushNamed(Pages.link_with),
          icon: const Icon(Icons.login, size: 18),
          label: Text("sign_up_or_login".tr()),
          style: FilledButton.styleFrom(
            minimumSize: const Size(200, 45),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget _buildManagementCard() {
    return SettingsMenuCard(
      children: [
        SettingsMenuItem(
          icon: Icons.sync_alt_rounded,
          title: context.tr("change_tracking_store"),
          onTap: onChangeStorePressed,
        ),
        SettingsMenuItem(
          icon: UIConstants.documentIconData,
          title: context.tr("documents"),
          onTap: openDocuments,
        ),
        SettingsMenuItem(
          icon: UIConstants.walletIconData,
          title: context.tr("title_wallet"),
          onTap: () => Navigator.of(context).pushNamed(Pages.wallet_list),
        ),
        SettingsMenuItem(
          icon: UIConstants.supplierIconData,
          title: context.tr("suppliers"),
          onTap: openSuppliers,
        ),
        SettingsMenuItem(
          icon: UIConstants.customerIconData,
          title: context.tr("customers"),
          onTap: openCustomers,
        ),
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
          icon: Icons.workspace_premium_outlined,
          title: context.tr("subscriptions_title"),
          onTap: () async => await RevenueCatUI.presentPaywall(),
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

  Widget _buildAccountActionsCard() {
    return SettingsMenuCard(
      children: [
        SettingsMenuItem(
          icon: Icons.logout,
          title: context.tr("sign_out"),
          iconColor: Colors.redAccent,
          onTap: () => onLogoutItemPressed(),
        ),
        SettingsMenuItem(
          icon: Icons.delete_forever_outlined,
          title: context.tr("delete_account"),
          iconColor: Colors.red,
          onTap: () => onDeleteAccountItemPressed(),
          isLast: true,
        ),
      ],
    );
  }

  void onDeleteAccountItemPressed() {
    showCustomAlertDialog(
      context,
      message: context.tr("message_confirm_delete_account"),
      onPositivePressed: () async {
        Navigator.of(context).pop();
        await context.read<MenuCubit>().deleteAccount();
        Navigator.of(context).pushNamedAndRemoveUntil(
            Pages.loading_data, (Route<dynamic> route) => false);
      },
    );
  }

  void onStoresItemPressed(BuildContext context) {
    Navigator.of(context)
        .pushNamed(Pages.store_list, arguments: {"isSelection": false});
  }

  Future<void> onChangeStorePressed() async {
    final result = await Navigator.of(context)
        .pushNamed(Pages.store_list, arguments: {"isSelection": true});
    if (result != null && context.mounted) {
      Store store = result as Store;
      AppSettings.setSelectedStoreId(store.id!);
      AppSettings.setSelectedStoreName(store.name);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MainPage()),
        (Route<dynamic> route) => false,
      );
    }
  }

  void openSuppliers() {
    Navigator.of(context).pushNamed(Pages.supplier_list);
  }

  void openCustomers() {
    Navigator.of(context).pushNamed(Pages.customer_list);
  }

  void openDocuments() {
    Navigator.of(context).pushNamed(Pages.document_list, arguments: {
      "documentType": null,
      "isSelection": false,
      "setting": null,
    });
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24),
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

  Future<void> _finishSignOut() async {
    await context.read<MenuCubit>().signOut();
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(
      Pages.loading_data,
      (route) => false,
    );
  }

  void onLogoutItemPressed() {
    showCustomAlertDialog(
      context,
      message: context.tr("signout_message"),
      onPositivePressed: () async {
        Navigator.of(context).pop();
        if (!mounted) return;
        showCustomAlertDialog(
          context,
          message: context.tr("question_push_data"),
          positiveText: context.tr("action_save"),
          negativeText: context.tr("signout_without_save"),
          onPositivePressed: () async {
            Navigator.of(context).pop();
            if (!mounted) return;
            var saved = false;
            try {
              saved = await context.read<MenuCubit>().upload();
            } catch (_) {
              saved = false;
            }
            if (!mounted) return;
            if (!saved) {
              ToastUtils.showErrorToast(context.tr("upload_failed_signout_cancelled"));
              return;
            }
            await _finishSignOut();
          },
          onNegativePressed: () async {
            Navigator.of(context).pop();
            if (!mounted) return;
            showCustomAlertDialog(
              context,
              message: context.tr("signout_discard_warning"),
              positiveText: context.tr("delete"),
              onPositivePressed: () async {
                Navigator.of(context).pop();
                if (!mounted) return;
                await _finishSignOut();
              },
            );
          },
        );
      },
    );
  }
}
