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

  Widget _buildPremiumBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber.shade700, Colors.amber.shade400],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, color: Colors.white, size: 14),
          SizedBox(width: 4),
          Text(
            "Premium",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isAnonymous = FirebaseAuth.instance.currentUser?.isAnonymous ?? false;

    return BlocConsumer<MenuCubit, MenuState>(
      listener: (context, state) async {},
      builder: (context, state) => Scaffold(
        appBar: LogoAppBar(),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          children: [
            _buildProfileHeader(isAnonymous),
            const SizedBox(height: 24),
            
            _buildSectionHeader(context.tr("workspace")),
            _buildMenuCard([
              _buildMenuItem(
                icon: UIConstants.settingIconData,
                title: context.tr("settings"),
                onTap: () => onSettingsItemPressed(context),
              ),
              _buildMenuItem(
                icon: UIConstants.storeIconData,
                title: context.tr("stores"),
                onTap: () => onStoresItemPressed(context),
              ),
              _buildMenuItem(
                icon: Icons.subscriptions_outlined,
                title: context.tr("subscriptions_title"),
                onTap: () async => await RevenueCatUI.presentPaywall(),
              ),
            ]),

            _buildSectionHeader(context.tr("support")),
            _buildMenuCard([
              _buildMenuItem(
                icon: Icons.person_add_outlined,
                title: context.tr("invite_friend"),
                onTap: () => onInviteFriend(context),
              ),
              _buildMenuItem(
                icon: Icons.chat_bubble_outline,
                title: context.tr("question_or_suggestion_title"),
                onTap: () => onSelectMessageType(context),
              ),
              _buildMenuItem(
                icon: Icons.star_outline,
                title: context.tr("review_the_app_title"),
                onTap: () async {
                  final InAppReview inAppReview = InAppReview.instance;
                  if (await inAppReview.isAvailable()) {
                    inAppReview.requestReview();
                  } else {
                    await inAppReview.openStoreListing();
                  }
                },
              ),
            ]),

            _buildSectionHeader(context.tr("about")),
            _buildMenuCard([
              _buildMenuItem(
                icon: Icons.help_outline,
                title: context.tr("help_title"),
                onTap: () => onHelp(context),
              ),
              _buildMenuItem(
                icon: Icons.new_releases_outlined,
                title: context.tr("whats_new_title"),
                onTap: () => onWhatsNew(context),
              ),
              _buildMenuItem(
                icon: Icons.description_outlined,
                title: context.tr("terms_of_use_title"),
                onTap: () => onTermsOfUse(),
              ),
              _buildMenuItem(
                icon: Icons.privacy_tip_outlined,
                title: context.tr("privacy_policy_title"),
                onTap: () => onPrivacyPolicy(),
              ),
            ]),

            if (!isAnonymous) ...[
              _buildSectionHeader(context.tr("account")),
              _buildMenuCard([
                _buildMenuItem(
                  icon: Icons.no_accounts_outlined,
                  title: context.tr("delete_account"),
                  textColor: Colors.red,
                  iconColor: Colors.red,
                  onTap: () => onDeleteAccountItemPressed(),
                ),
                _buildMenuItem(
                  icon: Icons.logout,
                  title: context.tr("sign_out"),
                  onTap: () => onLogoutItemPressed(),
                ),
              ]),
            ],
            
            const SizedBox(height: 32),
            Center(
              child: Text(
                "version".tr(args: [_packageInfo.version]),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8, top: 12),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildMenuCard(List<Widget> items) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.1)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: List.generate(items.length, (index) {
          return Column(
            children: [
              items[index],
              if (index < items.length - 1) buildDivider(indent: 56),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? Theme.of(context).colorScheme.onSurfaceVariant),
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }

  Widget _buildProfileHeader(bool isAnonymous) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: isAnonymous ? _buildAnonymousInfo() : _buildUserInfo(),
    );
  }

  Widget _buildAnonymousInfo() {
    return Column(
      children: [
        const CircleAvatar(
          radius: 35,
          backgroundColor: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Image(image: AssetImage('assets/images/user.png')),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo() {
    final user = FirebaseAuth.instance.currentUser;
    String? photoUrl;
    String? displayName;
    String? email;

    if (user?.providerData.isNotEmpty == true) {
      var first = user!.providerData.first;
      email = first.email;
      photoUrl = first.photoURL;
      displayName = first.displayName;
    }

    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 42,
              backgroundColor: Colors.white,
              backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
              child: photoUrl == null 
                  ? const Padding(
                      padding: EdgeInsets.all(10),
                      child: Image(image: AssetImage('assets/images/user.png')),
                    )
                  : null,
            ),
            if (_isPro)
              Container(
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                padding: const EdgeInsets.all(2),
                child: const Icon(Icons.verified, color: Colors.blue, size: 24),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          displayName ?? "User",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (email != null) ...[
          const SizedBox(height: 2),
          Text(
            email,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).hintColor,
            ),
          ),
        ],
        if (_isPro) ...[
          const SizedBox(height: 12),
          _buildPremiumBadge(),
        ],
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
        Navigator.of(context).pushNamedAndRemoveUntil(Pages.loading_data, (Route<dynamic> route) => false);
      },
    );
  }

  void onStoresItemPressed(BuildContext context) {
    Navigator.of(context).pushNamed(Pages.store_list, arguments: {"isSelection": false});
  }

  void onSettingsItemPressed(BuildContext context) {
    Navigator.of(context).pushNamed(Pages.settings);
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
      String subject = "${Config.appName} - ${type.getText(context)} - ${Platform.operatingSystem}";
      onSendMail(subject, "", Config.supportEmail);
    }
  }

  Future<MessageType?> showSelectMessageType(BuildContext context) async {
    return await showModalBottomSheet<MessageType>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Text(
                  context.tr("select_message_type"),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
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
    return params.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');
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
  void onHelp(BuildContext context) => Navigator.of(context).pushNamed(Pages.helps, arguments: {});

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
