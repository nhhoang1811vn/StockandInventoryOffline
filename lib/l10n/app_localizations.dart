import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('ja'),
    Locale('pt'),
    Locale('ru'),
    Locale('vi'),
    Locale('zh')
  ];

  /// No description provided for @home_title.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home_title;

  /// No description provided for @goods_title.
  ///
  /// In en, this message translates to:
  /// **'Goods'**
  String get goods_title;

  /// No description provided for @goods_select_title.
  ///
  /// In en, this message translates to:
  /// **'Select A Good'**
  String get goods_select_title;

  /// No description provided for @expenses_title.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenses_title;

  /// No description provided for @empty_goods.
  ///
  /// In en, this message translates to:
  /// **'No goods'**
  String get empty_goods;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// No description provided for @folder.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get folder;

  /// No description provided for @save_goods_title.
  ///
  /// In en, this message translates to:
  /// **'Save Good'**
  String get save_goods_title;

  /// No description provided for @documents_title.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documents_title;

  /// No description provided for @save_expense_title.
  ///
  /// In en, this message translates to:
  /// **'Save Expense'**
  String get save_expense_title;

  /// No description provided for @empty_expense.
  ///
  /// In en, this message translates to:
  /// **'No Expenses'**
  String get empty_expense;

  /// No description provided for @empty_document.
  ///
  /// In en, this message translates to:
  /// **'No documents'**
  String get empty_document;

  /// No description provided for @empty_incoming_document.
  ///
  /// In en, this message translates to:
  /// **'No incoming document'**
  String get empty_incoming_document;

  /// No description provided for @empty_outgoing_document.
  ///
  /// In en, this message translates to:
  /// **'No outgoing document'**
  String get empty_outgoing_document;

  /// No description provided for @document_list_tab_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get document_list_tab_all;

  /// No description provided for @incoming_document_text.
  ///
  /// In en, this message translates to:
  /// **'Incoming'**
  String get incoming_document_text;

  /// No description provided for @outgoing_document_text.
  ///
  /// In en, this message translates to:
  /// **'Outgoing'**
  String get outgoing_document_text;

  /// No description provided for @select_document_type.
  ///
  /// In en, this message translates to:
  /// **'Select document type'**
  String get select_document_type;

  /// No description provided for @document_information.
  ///
  /// In en, this message translates to:
  /// **'Document information'**
  String get document_information;

  /// No description provided for @goods_information.
  ///
  /// In en, this message translates to:
  /// **'Goods information'**
  String get goods_information;

  /// No description provided for @save_document_batch_scan.
  ///
  /// In en, this message translates to:
  /// **'Batch scan'**
  String get save_document_batch_scan;

  /// No description provided for @save_document_sort_by.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get save_document_sort_by;

  /// No description provided for @save_document_help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get save_document_help;

  /// No description provided for @more_title.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more_title;

  /// No description provided for @stores_title.
  ///
  /// In en, this message translates to:
  /// **'Stores'**
  String get stores_title;

  /// No description provided for @stores_description.
  ///
  /// In en, this message translates to:
  /// **'Stores Information'**
  String get stores_description;

  /// No description provided for @stores_select_title.
  ///
  /// In en, this message translates to:
  /// **'Select A Store'**
  String get stores_select_title;

  /// No description provided for @save_store_title.
  ///
  /// In en, this message translates to:
  /// **'Save Store'**
  String get save_store_title;

  /// No description provided for @empty_stores.
  ///
  /// In en, this message translates to:
  /// **'No Store'**
  String get empty_stores;

  /// No description provided for @delete_store_error.
  ///
  /// In en, this message translates to:
  /// **'This is your only store, can not perform this action'**
  String get delete_store_error;

  /// No description provided for @suppliers_title.
  ///
  /// In en, this message translates to:
  /// **'Suppliers'**
  String get suppliers_title;

  /// No description provided for @suppliers_select_title.
  ///
  /// In en, this message translates to:
  /// **'Select a Supplier'**
  String get suppliers_select_title;

  /// No description provided for @save_supplier_title.
  ///
  /// In en, this message translates to:
  /// **'Save Supplier'**
  String get save_supplier_title;

  /// No description provided for @empty_suppliers.
  ///
  /// In en, this message translates to:
  /// **'No Supplier'**
  String get empty_suppliers;

  /// No description provided for @customers_title.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customers_title;

  /// No description provided for @customers_select_title.
  ///
  /// In en, this message translates to:
  /// **'Select a Customer'**
  String get customers_select_title;

  /// No description provided for @save_customer_title.
  ///
  /// In en, this message translates to:
  /// **'Save Customer'**
  String get save_customer_title;

  /// No description provided for @empty_customers.
  ///
  /// In en, this message translates to:
  /// **'No Customers'**
  String get empty_customers;

  /// No description provided for @save_group_title.
  ///
  /// In en, this message translates to:
  /// **'Save Group'**
  String get save_group_title;

  /// No description provided for @field_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get field_name;

  /// No description provided for @error_field_name_empty.
  ///
  /// In en, this message translates to:
  /// **'Please ensure the name entered is valid'**
  String get error_field_name_empty;

  /// No description provided for @field_bar_code.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get field_bar_code;

  /// No description provided for @field_quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get field_quantity;

  /// No description provided for @field_quantity_short_form.
  ///
  /// In en, this message translates to:
  /// **'Quan'**
  String get field_quantity_short_form;

  /// No description provided for @field_min_quantity.
  ///
  /// In en, this message translates to:
  /// **'Minimum quantity'**
  String get field_min_quantity;

  /// No description provided for @field_min_quantity_short_form.
  ///
  /// In en, this message translates to:
  /// **'Min.'**
  String get field_min_quantity_short_form;

  /// No description provided for @field_total_short_form.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get field_total_short_form;

  /// No description provided for @field_supplier.
  ///
  /// In en, this message translates to:
  /// **'Supplier'**
  String get field_supplier;

  /// No description provided for @field_customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get field_customer;

  /// No description provided for @field_date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get field_date;

  /// No description provided for @field_date_time.
  ///
  /// In en, this message translates to:
  /// **'Date & Time'**
  String get field_date_time;

  /// No description provided for @field_amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get field_amount;

  /// No description provided for @field_paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get field_paid;

  /// No description provided for @field_remaining.
  ///
  /// In en, this message translates to:
  /// **'Remain'**
  String get field_remaining;

  /// No description provided for @field_images.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get field_images;

  /// No description provided for @field_document_type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get field_document_type;

  /// No description provided for @field_person_name.
  ///
  /// In en, this message translates to:
  /// **'Customer/Supplier'**
  String get field_person_name;

  /// No description provided for @field_total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get field_total;

  /// No description provided for @field_purchase_price.
  ///
  /// In en, this message translates to:
  /// **'Purchase price'**
  String get field_purchase_price;

  /// No description provided for @field_sale_price.
  ///
  /// In en, this message translates to:
  /// **'Sale price'**
  String get field_sale_price;

  /// No description provided for @field_price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get field_price;

  /// No description provided for @field_revenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get field_revenue;

  /// No description provided for @field_document_no.
  ///
  /// In en, this message translates to:
  /// **'Document No'**
  String get field_document_no;

  /// No description provided for @home_menu_item_goods.
  ///
  /// In en, this message translates to:
  /// **'Goods'**
  String get home_menu_item_goods;

  /// No description provided for @home_menu_item_documents.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get home_menu_item_documents;

  /// No description provided for @home_menu_item_more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get home_menu_item_more;

  /// No description provided for @message_error_negative_quantity_save_document.
  ///
  /// In en, this message translates to:
  /// **'Can\'t perform this action, %s \'s quantity is negative'**
  String get message_error_negative_quantity_save_document;

  /// No description provided for @action_send_email.
  ///
  /// In en, this message translates to:
  /// **'Send E-mail'**
  String get action_send_email;

  /// No description provided for @action_send_sms.
  ///
  /// In en, this message translates to:
  /// **'Send SMS'**
  String get action_send_sms;

  /// No description provided for @action_phone_call.
  ///
  /// In en, this message translates to:
  /// **'Phone Call'**
  String get action_phone_call;

  /// No description provided for @action_view_transaction.
  ///
  /// In en, this message translates to:
  /// **'View Transactions'**
  String get action_view_transaction;

  /// No description provided for @action_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get action_edit;

  /// No description provided for @action_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get action_delete;

  /// No description provided for @action_view_document.
  ///
  /// In en, this message translates to:
  /// **'View documents'**
  String get action_view_document;

  /// No description provided for @message_name_blank.
  ///
  /// In en, this message translates to:
  /// **'Name can not be blank'**
  String get message_name_blank;

  /// No description provided for @notification_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification_dialog_title;

  /// No description provided for @question_push_data.
  ///
  /// In en, this message translates to:
  /// **'Would you like to save the data to Server?'**
  String get question_push_data;

  /// No description provided for @title_store_selecting.
  ///
  /// In en, this message translates to:
  /// **'Selection store'**
  String get title_store_selecting;

  /// No description provided for @message_delete_supplier_error_having_document.
  ///
  /// In en, this message translates to:
  /// **'You have documents attached to the supplier, can not perform this action'**
  String get message_delete_supplier_error_having_document;

  /// No description provided for @message_delete_customer_error_having_document.
  ///
  /// In en, this message translates to:
  /// **'You have documents attached to the supplier, can not perform this action'**
  String get message_delete_customer_error_having_document;

  /// No description provided for @action_ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get action_ok;

  /// No description provided for @action_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get action_cancel;

  /// No description provided for @search_by_customer_supplier.
  ///
  /// In en, this message translates to:
  /// **'By customer/supplier'**
  String get search_by_customer_supplier;

  /// No description provided for @action_move_to_group.
  ///
  /// In en, this message translates to:
  /// **'Move to group'**
  String get action_move_to_group;

  /// No description provided for @action_edit_group.
  ///
  /// In en, this message translates to:
  /// **'Edit group'**
  String get action_edit_group;

  /// No description provided for @action_add_attachment.
  ///
  /// In en, this message translates to:
  /// **'Tap to add files'**
  String get action_add_attachment;

  /// No description provided for @action_take_picture.
  ///
  /// In en, this message translates to:
  /// **'Take a picture'**
  String get action_take_picture;

  /// No description provided for @dialog_title_sort_by.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get dialog_title_sort_by;

  /// No description provided for @sort_by_option_no_sort_text.
  ///
  /// In en, this message translates to:
  /// **'No sort'**
  String get sort_by_option_no_sort_text;

  /// No description provided for @sort_by_option_a_to_z_text.
  ///
  /// In en, this message translates to:
  /// **'A to Z'**
  String get sort_by_option_a_to_z_text;

  /// No description provided for @sort_by_option_z_to_a_text.
  ///
  /// In en, this message translates to:
  /// **'Z to A'**
  String get sort_by_option_z_to_a_text;

  /// No description provided for @sort_by_option_ascending_text.
  ///
  /// In en, this message translates to:
  /// **'Ascending'**
  String get sort_by_option_ascending_text;

  /// No description provided for @sort_by_option_descending_text.
  ///
  /// In en, this message translates to:
  /// **'Descending'**
  String get sort_by_option_descending_text;

  /// No description provided for @in_stock_text.
  ///
  /// In en, this message translates to:
  /// **'In Stock: %s'**
  String get in_stock_text;

  /// No description provided for @menu_item_invite_friend_header.
  ///
  /// In en, this message translates to:
  /// **'Invite friends'**
  String get menu_item_invite_friend_header;

  /// No description provided for @send_mail_invite_friend_subject.
  ///
  /// In en, this message translates to:
  /// **'Invitation using App'**
  String get send_mail_invite_friend_subject;

  /// No description provided for @send_mail_invite_friend_content.
  ///
  /// In en, this message translates to:
  /// **'This is a good application, I use it everyday and recommend it for you. Download for Android: https://play.google.com/store/apps/details?id=com.steam.goodmanagerflutter. Download for iOS: https://apps.apple.com/us/app/stock-and-inventory/id6670546293'**
  String get send_mail_invite_friend_content;

  /// No description provided for @menu_item_write_review_header.
  ///
  /// In en, this message translates to:
  /// **'Write a review'**
  String get menu_item_write_review_header;

  /// No description provided for @menu_item_write_review_description.
  ///
  /// In en, this message translates to:
  /// **'Share your review to everyone'**
  String get menu_item_write_review_description;

  /// No description provided for @menu_item_feedback_header.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get menu_item_feedback_header;

  /// No description provided for @menu_item_feedback_description.
  ///
  /// In en, this message translates to:
  /// **'Share your feedback to improve the app'**
  String get menu_item_feedback_description;

  /// No description provided for @menu_item_community_header.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get menu_item_community_header;

  /// No description provided for @menu_item_community_description.
  ///
  /// In en, this message translates to:
  /// **'Join our app community'**
  String get menu_item_community_description;

  /// No description provided for @menu_item_donation.
  ///
  /// In en, this message translates to:
  /// **'Donation!'**
  String get menu_item_donation;

  /// No description provided for @menu_item_delete_account.
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get menu_item_delete_account;

  /// No description provided for @menu_item_upgrade_account.
  ///
  /// In en, this message translates to:
  /// **'Upgrade account'**
  String get menu_item_upgrade_account;

  /// No description provided for @menu_item_upgrade_account_subtitle.
  ///
  /// In en, this message translates to:
  /// **'You are on guest mode, upgrade to normal account to sync progress'**
  String get menu_item_upgrade_account_subtitle;

  /// No description provided for @menu_item_sign_out.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get menu_item_sign_out;

  /// No description provided for @menu_item_whats_new_header.
  ///
  /// In en, this message translates to:
  /// **'What\'s new'**
  String get menu_item_whats_new_header;

  /// No description provided for @menu_item_whats_new_description.
  ///
  /// In en, this message translates to:
  /// **'What\'s new information'**
  String get menu_item_whats_new_description;

  /// No description provided for @on_boarding_title_1.
  ///
  /// In en, this message translates to:
  /// **'Stores Manage'**
  String get on_boarding_title_1;

  /// No description provided for @on_boarding_content_1.
  ///
  /// In en, this message translates to:
  /// **'You can create a lot of stores to manage your goods and tracking their information. eg: Fruit Store, Vegetable Stores....'**
  String get on_boarding_content_1;

  /// No description provided for @on_boarding_title_2.
  ///
  /// In en, this message translates to:
  /// **'Goods Manage'**
  String get on_boarding_title_2;

  /// No description provided for @on_boarding_content_2.
  ///
  /// In en, this message translates to:
  /// **'It\'s contains list(catalog) of all your goods including information about quantity in stock. eg: Light bulb, todo'**
  String get on_boarding_content_2;

  /// No description provided for @on_boarding_title_3.
  ///
  /// In en, this message translates to:
  /// **'Documents Manage'**
  String get on_boarding_title_3;

  /// No description provided for @on_boarding_content_3.
  ///
  /// In en, this message translates to:
  /// **'You can create incoming/outgoing documents to increase/decrease your goods quantity in stock'**
  String get on_boarding_content_3;

  /// No description provided for @on_boarding_title_4.
  ///
  /// In en, this message translates to:
  /// **'Start now'**
  String get on_boarding_title_4;

  /// No description provided for @on_boarding_header_4.
  ///
  /// In en, this message translates to:
  /// **'Input your first store name'**
  String get on_boarding_header_4;

  /// No description provided for @action_done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get action_done;

  /// No description provided for @action_skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get action_skip;

  /// No description provided for @message_confirm_delete_no_args.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to delete it?'**
  String get message_confirm_delete_no_args;

  /// No description provided for @message_confirm_delete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to delete %s?'**
  String get message_confirm_delete;

  /// No description provided for @message_confirm_delete_account.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to delete your account ?'**
  String get message_confirm_delete_account;

  /// No description provided for @delete_account_successful.
  ///
  /// In en, this message translates to:
  /// **'Your account has been deleted'**
  String get delete_account_successful;

  /// No description provided for @menu_item_settings_title.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get menu_item_settings_title;

  /// No description provided for @menu_item_settings_desc.
  ///
  /// In en, this message translates to:
  /// **'Settings Information'**
  String get menu_item_settings_desc;

  /// No description provided for @menu_item_general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get menu_item_general;

  /// No description provided for @menu_item_view.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get menu_item_view;

  /// No description provided for @menu_item_barcode_scanner.
  ///
  /// In en, this message translates to:
  /// **'Barcode scanner'**
  String get menu_item_barcode_scanner;

  /// No description provided for @menu_item_minimum_quantity.
  ///
  /// In en, this message translates to:
  /// **'Minimum quantity'**
  String get menu_item_minimum_quantity;

  /// No description provided for @menu_item_show_min_quantity_items_page_title.
  ///
  /// In en, this message translates to:
  /// **'Show minimum quantity in item\'s page'**
  String get menu_item_show_min_quantity_items_page_title;

  /// No description provided for @menu_item_show_min_quantity_list_page_title.
  ///
  /// In en, this message translates to:
  /// **'Show minimum quantity in list page'**
  String get menu_item_show_min_quantity_list_page_title;

  /// No description provided for @menu_item_min_quantity_color_title.
  ///
  /// In en, this message translates to:
  /// **'Color for goods needing reorder'**
  String get menu_item_min_quantity_color_title;

  /// No description provided for @menu_item_show_low_stock_alert_title.
  ///
  /// In en, this message translates to:
  /// **'Show Low Stock Alerts'**
  String get menu_item_show_low_stock_alert_title;

  /// No description provided for @menu_item_show_low_stock_alert_desc.
  ///
  /// In en, this message translates to:
  /// **'When you open the app, we will send you the notification to warning you'**
  String get menu_item_show_low_stock_alert_desc;

  /// No description provided for @menu_item_my_company.
  ///
  /// In en, this message translates to:
  /// **'Company Information'**
  String get menu_item_my_company;

  /// No description provided for @menu_item_backup_and_restore.
  ///
  /// In en, this message translates to:
  /// **'Back up and restore'**
  String get menu_item_backup_and_restore;

  /// No description provided for @menu_item_language_title.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get menu_item_language_title;

  /// No description provided for @menu_item_language_desc.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get menu_item_language_desc;

  /// No description provided for @menu_item_passcode_title.
  ///
  /// In en, this message translates to:
  /// **'Pass code lock'**
  String get menu_item_passcode_title;

  /// No description provided for @menu_item_passcode_desc.
  ///
  /// In en, this message translates to:
  /// **'Desc'**
  String get menu_item_passcode_desc;

  /// No description provided for @menu_item_reset_numeration_documents_title.
  ///
  /// In en, this message translates to:
  /// **'Reset numeration of documents'**
  String get menu_item_reset_numeration_documents_title;

  /// No description provided for @settings_title.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings_title;

  /// No description provided for @subscriptions_title.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get subscriptions_title;

  /// No description provided for @dialog_title_change_language.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get dialog_title_change_language;

  /// No description provided for @english_text.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english_text;

  /// No description provided for @vietnamese_text.
  ///
  /// In en, this message translates to:
  /// **'Vietnamese'**
  String get vietnamese_text;

  /// No description provided for @incoming_goods.
  ///
  /// In en, this message translates to:
  /// **'Incoming Goods'**
  String get incoming_goods;

  /// No description provided for @outgoing_goods.
  ///
  /// In en, this message translates to:
  /// **'Outgoing Goods'**
  String get outgoing_goods;

  /// No description provided for @report_title.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report_title;

  /// No description provided for @select_store_title.
  ///
  /// In en, this message translates to:
  /// **'Select store'**
  String get select_store_title;

  /// No description provided for @select_group_title.
  ///
  /// In en, this message translates to:
  /// **'Select group'**
  String get select_group_title;

  /// No description provided for @select_message_type.
  ///
  /// In en, this message translates to:
  /// **'Select Message Type'**
  String get select_message_type;

  /// No description provided for @message_type_bug_report.
  ///
  /// In en, this message translates to:
  /// **'Bug report'**
  String get message_type_bug_report;

  /// No description provided for @message_type_feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get message_type_feedback;

  /// No description provided for @message_type_suggestion.
  ///
  /// In en, this message translates to:
  /// **'Suggestion'**
  String get message_type_suggestion;

  /// No description provided for @message_type_question.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get message_type_question;

  /// No description provided for @send_mail_bug_report_subject.
  ///
  /// In en, this message translates to:
  /// **'Stock and inventory - Bug Report'**
  String get send_mail_bug_report_subject;

  /// No description provided for @send_mail_feedback_subject.
  ///
  /// In en, this message translates to:
  /// **'Stock and inventory - Feedback'**
  String get send_mail_feedback_subject;

  /// No description provided for @send_mail_suggestion_subject.
  ///
  /// In en, this message translates to:
  /// **'Stock and inventory - Suggestion'**
  String get send_mail_suggestion_subject;

  /// No description provided for @send_mail_question_subject.
  ///
  /// In en, this message translates to:
  /// **'Stock and inventory - Question'**
  String get send_mail_question_subject;

  /// No description provided for @dialog_title_data_not_save.
  ///
  /// In en, this message translates to:
  /// **'Attention!'**
  String get dialog_title_data_not_save;

  /// No description provided for @dialog_content_data_not_save.
  ///
  /// In en, this message translates to:
  /// **'Close without saving'**
  String get dialog_content_data_not_save;

  /// No description provided for @batch_mode_scan.
  ///
  /// In en, this message translates to:
  /// **'Batch mode scan'**
  String get batch_mode_scan;

  /// No description provided for @after_each_scan.
  ///
  /// In en, this message translates to:
  /// **'After each scan'**
  String get after_each_scan;

  /// No description provided for @after_each_scan_auto.
  ///
  /// In en, this message translates to:
  /// **'Auto increment quantity by 1'**
  String get after_each_scan_auto;

  /// No description provided for @after_each_scan_manually.
  ///
  /// In en, this message translates to:
  /// **'Set quantity manually'**
  String get after_each_scan_manually;

  /// No description provided for @when_a_barcode_is_found.
  ///
  /// In en, this message translates to:
  /// **'When a barcode is found'**
  String get when_a_barcode_is_found;

  /// No description provided for @beep.
  ///
  /// In en, this message translates to:
  /// **'Beep'**
  String get beep;

  /// No description provided for @vibrate.
  ///
  /// In en, this message translates to:
  /// **'Vibrate'**
  String get vibrate;

  /// No description provided for @question_or_suggestion_title.
  ///
  /// In en, this message translates to:
  /// **'Question or suggestion'**
  String get question_or_suggestion_title;

  /// No description provided for @review_the_app_title.
  ///
  /// In en, this message translates to:
  /// **'Review the app'**
  String get review_the_app_title;

  /// No description provided for @help_title.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help_title;

  /// No description provided for @whats_new_title.
  ///
  /// In en, this message translates to:
  /// **'What\'s New'**
  String get whats_new_title;

  /// No description provided for @terms_of_use_title.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get terms_of_use_title;

  /// No description provided for @privacy_policy_title.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy_policy_title;

  /// No description provided for @your_subscriptions_title.
  ///
  /// In en, this message translates to:
  /// **'Your subscriptions'**
  String get your_subscriptions_title;

  /// No description provided for @document_name_no.
  ///
  /// In en, this message translates to:
  /// **'No.'**
  String get document_name_no;

  /// No description provided for @insert_transaction_success.
  ///
  /// In en, this message translates to:
  /// **'Added item successful!'**
  String get insert_transaction_success;

  /// No description provided for @insert_transaction_fail.
  ///
  /// In en, this message translates to:
  /// **'Added item failed!'**
  String get insert_transaction_fail;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success!'**
  String get success;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error!'**
  String get error;

  /// No description provided for @error_same_barcode.
  ///
  /// In en, this message translates to:
  /// **'Error: same bar code'**
  String get error_same_barcode;

  /// No description provided for @action_search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get action_search;

  /// No description provided for @action_sort_by.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get action_sort_by;

  /// No description provided for @action_export_csv.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get action_export_csv;

  /// No description provided for @action_export_pdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get action_export_pdf;

  /// No description provided for @action_batch_scan.
  ///
  /// In en, this message translates to:
  /// **'Batch scan'**
  String get action_batch_scan;

  /// No description provided for @action_help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get action_help;

  /// No description provided for @report_type_goods.
  ///
  /// In en, this message translates to:
  /// **'List of Goods'**
  String get report_type_goods;

  /// No description provided for @report_type_expenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get report_type_expenses;

  /// No description provided for @report_type_list_of_documents.
  ///
  /// In en, this message translates to:
  /// **'List of documents'**
  String get report_type_list_of_documents;

  /// No description provided for @report_type_debt_by_supplier.
  ///
  /// In en, this message translates to:
  /// **'Debt of Supplier'**
  String get report_type_debt_by_supplier;

  /// No description provided for @report_type_debt_by_customer.
  ///
  /// In en, this message translates to:
  /// **'Debt of Customer'**
  String get report_type_debt_by_customer;

  /// No description provided for @report_type_inbound_payments.
  ///
  /// In en, this message translates to:
  /// **'Inbound payments'**
  String get report_type_inbound_payments;

  /// No description provided for @report_type_outbound_payments.
  ///
  /// In en, this message translates to:
  /// **'Outbound payments'**
  String get report_type_outbound_payments;

  /// No description provided for @report_type_list_of_supplier_payments.
  ///
  /// In en, this message translates to:
  /// **'Payments by Suppliers'**
  String get report_type_list_of_supplier_payments;

  /// No description provided for @report_type_list_of_customer_payments.
  ///
  /// In en, this message translates to:
  /// **'Payments by Customer'**
  String get report_type_list_of_customer_payments;

  /// No description provided for @report_type_reorder.
  ///
  /// In en, this message translates to:
  /// **'Reorder'**
  String get report_type_reorder;

  /// No description provided for @select_date_range.
  ///
  /// In en, this message translates to:
  /// **'Select date range'**
  String get select_date_range;

  /// No description provided for @report_type_current_month.
  ///
  /// In en, this message translates to:
  /// **'Current month'**
  String get report_type_current_month;

  /// No description provided for @report_type_last_30_days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get report_type_last_30_days;

  /// No description provided for @report_type_last_90_days.
  ///
  /// In en, this message translates to:
  /// **'Last 90 days'**
  String get report_type_last_90_days;

  /// No description provided for @report_type_current_year.
  ///
  /// In en, this message translates to:
  /// **'Current year'**
  String get report_type_current_year;

  /// No description provided for @report_type_custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get report_type_custom;

  /// No description provided for @report_detail_period_time.
  ///
  /// In en, this message translates to:
  /// **'From %s to %s'**
  String get report_detail_period_time;

  /// No description provided for @report_detail_store.
  ///
  /// In en, this message translates to:
  /// **'Store %s'**
  String get report_detail_store;

  /// No description provided for @select_payment_status.
  ///
  /// In en, this message translates to:
  /// **'Select payment status'**
  String get select_payment_status;

  /// No description provided for @payment_status_unpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get payment_status_unpaid;

  /// No description provided for @payment_status_partial.
  ///
  /// In en, this message translates to:
  /// **'Partial'**
  String get payment_status_partial;

  /// No description provided for @payment_status_paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get payment_status_paid;

  /// No description provided for @payments_title.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get payments_title;

  /// No description provided for @payment_invoiced.
  ///
  /// In en, this message translates to:
  /// **'Invoiced'**
  String get payment_invoiced;

  /// No description provided for @payment_due_pending.
  ///
  /// In en, this message translates to:
  /// **'Due/pending'**
  String get payment_due_pending;

  /// No description provided for @payment_paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get payment_paid;

  /// No description provided for @empty_payment.
  ///
  /// In en, this message translates to:
  /// **'No Payment'**
  String get empty_payment;

  /// No description provided for @title_outbound_payment.
  ///
  /// In en, this message translates to:
  /// **'Outbound'**
  String get title_outbound_payment;

  /// No description provided for @title_inbound_payment.
  ///
  /// In en, this message translates to:
  /// **'Inbound'**
  String get title_inbound_payment;

  /// No description provided for @save_outbound_payment_title.
  ///
  /// In en, this message translates to:
  /// **'Save Outbound Payment'**
  String get save_outbound_payment_title;

  /// No description provided for @save_inbound_payment_title.
  ///
  /// In en, this message translates to:
  /// **'Save Inbound Payment'**
  String get save_inbound_payment_title;

  /// No description provided for @menu_back_up.
  ///
  /// In en, this message translates to:
  /// **'Back up data'**
  String get menu_back_up;

  /// No description provided for @menu_back_up_desc.
  ///
  /// In en, this message translates to:
  /// **'Export database file to the phone'**
  String get menu_back_up_desc;

  /// No description provided for @menu_restore.
  ///
  /// In en, this message translates to:
  /// **'Restore data'**
  String get menu_restore;

  /// No description provided for @menu_restore_desc.
  ///
  /// In en, this message translates to:
  /// **'Import database file'**
  String get menu_restore_desc;

  /// No description provided for @backup_successful.
  ///
  /// In en, this message translates to:
  /// **'Back up data successful'**
  String get backup_successful;

  /// No description provided for @backup_error.
  ///
  /// In en, this message translates to:
  /// **'Back up data failed!!'**
  String get backup_error;

  /// No description provided for @error_wrong_email_password.
  ///
  /// In en, this message translates to:
  /// **'Wrong email or password, please try again'**
  String get error_wrong_email_password;

  /// No description provided for @menu_push_data_to_cloud.
  ///
  /// In en, this message translates to:
  /// **'Save the data to cloud'**
  String get menu_push_data_to_cloud;

  /// No description provided for @menu_quick_sync_title.
  ///
  /// In en, this message translates to:
  /// **'Quick sync'**
  String get menu_quick_sync_title;

  /// No description provided for @menu_quick_sync_desc.
  ///
  /// In en, this message translates to:
  /// **'It will restart the app, and sync the latest app data'**
  String get menu_quick_sync_desc;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'LOGIN'**
  String get login;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @error_email.
  ///
  /// In en, this message translates to:
  /// **'Please input valid email'**
  String get error_email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @error_password.
  ///
  /// In en, this message translates to:
  /// **'Please input valid password'**
  String get error_password;

  /// No description provided for @forgot_your_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password ?'**
  String get forgot_your_password;

  /// No description provided for @or_sign_in_with.
  ///
  /// In en, this message translates to:
  /// **'or Sign in with'**
  String get or_sign_in_with;

  /// No description provided for @dont_have_an_account_yet.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account yet ?'**
  String get dont_have_an_account_yet;

  /// No description provided for @sign_up_text.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get sign_up_text;

  /// No description provided for @sign_up.
  ///
  /// In en, this message translates to:
  /// **'SIGN UP'**
  String get sign_up;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @reset_password.
  ///
  /// In en, this message translates to:
  /// **'RESET PASSWORD'**
  String get reset_password;

  /// No description provided for @email_not_verified_title.
  ///
  /// In en, this message translates to:
  /// **'Email Not Verified'**
  String get email_not_verified_title;

  /// No description provided for @email_not_verified_desc.
  ///
  /// In en, this message translates to:
  /// **'Please check your email and verify your email.'**
  String get email_not_verified_desc;

  /// No description provided for @sign_up_successful.
  ///
  /// In en, this message translates to:
  /// **'Sign up success'**
  String get sign_up_successful;

  /// No description provided for @reset_password_successful.
  ///
  /// In en, this message translates to:
  /// **'Reset password Success'**
  String get reset_password_successful;

  /// No description provided for @cloud_file_no_updated.
  ///
  /// In en, this message translates to:
  /// **'Not updated yet'**
  String get cloud_file_no_updated;

  /// No description provided for @signout_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure want to log out ?'**
  String get signout_message;

  /// No description provided for @item_history_title.
  ///
  /// In en, this message translates to:
  /// **'Item History'**
  String get item_history_title;

  /// No description provided for @list_settings.
  ///
  /// In en, this message translates to:
  /// **'List Settings'**
  String get list_settings;

  /// No description provided for @good_settings_hide_zero_entries.
  ///
  /// In en, this message translates to:
  /// **'Hide zero entries'**
  String get good_settings_hide_zero_entries;

  /// No description provided for @good_setting_show_bar_code.
  ///
  /// In en, this message translates to:
  /// **'Show barcode'**
  String get good_setting_show_bar_code;

  /// No description provided for @good_setting_show_description.
  ///
  /// In en, this message translates to:
  /// **'Show description'**
  String get good_setting_show_description;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version: %s'**
  String get version;

  /// No description provided for @change_tracking_store.
  ///
  /// In en, this message translates to:
  /// **'Change tracking store'**
  String get change_tracking_store;

  /// No description provided for @loading_data.
  ///
  /// In en, this message translates to:
  /// **'Loading data...'**
  String get loading_data;

  /// No description provided for @title_good_count.
  ///
  /// In en, this message translates to:
  /// **'Number of items'**
  String get title_good_count;

  /// No description provided for @title_total_quantity.
  ///
  /// In en, this message translates to:
  /// **'Total Quantity'**
  String get title_total_quantity;

  /// No description provided for @title_select_document.
  ///
  /// In en, this message translates to:
  /// **'Select document'**
  String get title_select_document;

  /// No description provided for @title_chart_sale_report.
  ///
  /// In en, this message translates to:
  /// **'Sale Report in last 6 months'**
  String get title_chart_sale_report;

  /// No description provided for @label_select_payment_category.
  ///
  /// In en, this message translates to:
  /// **'Select category'**
  String get label_select_payment_category;

  /// No description provided for @label_select_wallet.
  ///
  /// In en, this message translates to:
  /// **'Select wallet'**
  String get label_select_wallet;

  /// No description provided for @label_select_object.
  ///
  /// In en, this message translates to:
  /// **'Select object'**
  String get label_select_object;

  /// No description provided for @label_select_outbound_object.
  ///
  /// In en, this message translates to:
  /// **'Select outbound object'**
  String get label_select_outbound_object;

  /// No description provided for @label_select_inbound_object.
  ///
  /// In en, this message translates to:
  /// **'Select inbound object'**
  String get label_select_inbound_object;

  /// No description provided for @label_description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get label_description;

  /// No description provided for @hint_description.
  ///
  /// In en, this message translates to:
  /// **'Input description'**
  String get hint_description;

  /// No description provided for @label_select_document_no.
  ///
  /// In en, this message translates to:
  /// **'Document No'**
  String get label_select_document_no;

  /// No description provided for @label_supplier_name.
  ///
  /// In en, this message translates to:
  /// **'Supplier name'**
  String get label_supplier_name;

  /// No description provided for @label_customer_name.
  ///
  /// In en, this message translates to:
  /// **'Customer name'**
  String get label_customer_name;

  /// No description provided for @label_group_name.
  ///
  /// In en, this message translates to:
  /// **'Group name'**
  String get label_group_name;

  /// No description provided for @label_good_name.
  ///
  /// In en, this message translates to:
  /// **'Good name'**
  String get label_good_name;

  /// No description provided for @label_category_name.
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get label_category_name;

  /// No description provided for @label_wallet_name.
  ///
  /// In en, this message translates to:
  /// **'Wallet name'**
  String get label_wallet_name;

  /// No description provided for @hint_name.
  ///
  /// In en, this message translates to:
  /// **'Input name'**
  String get hint_name;

  /// No description provided for @label_address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get label_address;

  /// No description provided for @hint_address.
  ///
  /// In en, this message translates to:
  /// **'Input address'**
  String get hint_address;

  /// No description provided for @label_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get label_email;

  /// No description provided for @hint_email.
  ///
  /// In en, this message translates to:
  /// **'Input email'**
  String get hint_email;

  /// No description provided for @label_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get label_phone_number;

  /// No description provided for @hint_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Input phone number'**
  String get hint_phone_number;

  /// No description provided for @label_tax_id.
  ///
  /// In en, this message translates to:
  /// **'Tax ID'**
  String get label_tax_id;

  /// No description provided for @hint_tax_id.
  ///
  /// In en, this message translates to:
  /// **'Input tax id'**
  String get hint_tax_id;

  /// No description provided for @label_bank_details.
  ///
  /// In en, this message translates to:
  /// **'Bank details'**
  String get label_bank_details;

  /// No description provided for @hint_bank_details.
  ///
  /// In en, this message translates to:
  /// **'Input bank details'**
  String get hint_bank_details;

  /// No description provided for @label_bar_code.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get label_bar_code;

  /// No description provided for @hint_bar_code.
  ///
  /// In en, this message translates to:
  /// **'Input bar code'**
  String get hint_bar_code;

  /// No description provided for @action_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get action_save;

  /// No description provided for @hint_select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get hint_select;

  /// No description provided for @action_add_payment_category.
  ///
  /// In en, this message translates to:
  /// **'Add category'**
  String get action_add_payment_category;

  /// No description provided for @title_pick_color.
  ///
  /// In en, this message translates to:
  /// **'Pick color'**
  String get title_pick_color;

  /// No description provided for @action_add_group.
  ///
  /// In en, this message translates to:
  /// **'Add group'**
  String get action_add_group;

  /// No description provided for @action_add_good.
  ///
  /// In en, this message translates to:
  /// **'Add good'**
  String get action_add_good;

  /// No description provided for @no_category.
  ///
  /// In en, this message translates to:
  /// **'No category'**
  String get no_category;

  /// No description provided for @field_start_period.
  ///
  /// In en, this message translates to:
  /// **'Start Period'**
  String get field_start_period;

  /// No description provided for @field_in.
  ///
  /// In en, this message translates to:
  /// **'In'**
  String get field_in;

  /// No description provided for @field_out.
  ///
  /// In en, this message translates to:
  /// **'Out'**
  String get field_out;

  /// No description provided for @field_end_period.
  ///
  /// In en, this message translates to:
  /// **'End Period'**
  String get field_end_period;

  /// No description provided for @action_document_created_withname.
  ///
  /// In en, this message translates to:
  /// **'Document %s was created'**
  String get action_document_created_withname;

  /// No description provided for @good_information.
  ///
  /// In en, this message translates to:
  /// **'Good information'**
  String get good_information;

  /// No description provided for @images_information.
  ///
  /// In en, this message translates to:
  /// **'Images information'**
  String get images_information;

  /// No description provided for @change_color.
  ///
  /// In en, this message translates to:
  /// **'Change color'**
  String get change_color;

  /// No description provided for @change_icon.
  ///
  /// In en, this message translates to:
  /// **'Change icon'**
  String get change_icon;

  /// No description provided for @save_file_successful.
  ///
  /// In en, this message translates to:
  /// **'Save file successful at %s'**
  String get save_file_successful;

  /// No description provided for @save_file_failed.
  ///
  /// In en, this message translates to:
  /// **'Save file failed at %s'**
  String get save_file_failed;

  /// No description provided for @no_group.
  ///
  /// In en, this message translates to:
  /// **'No group'**
  String get no_group;

  /// No description provided for @save_wallet_title.
  ///
  /// In en, this message translates to:
  /// **'Save Wallet'**
  String get save_wallet_title;

  /// No description provided for @action_add_wallet.
  ///
  /// In en, this message translates to:
  /// **'Add Wallet'**
  String get action_add_wallet;

  /// No description provided for @total_balance.
  ///
  /// In en, this message translates to:
  /// **'Total Balance'**
  String get total_balance;

  /// No description provided for @title_wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallets'**
  String get title_wallet;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @title_save_category.
  ///
  /// In en, this message translates to:
  /// **'Save Category'**
  String get title_save_category;

  /// No description provided for @inbound_categories.
  ///
  /// In en, this message translates to:
  /// **'Inbound Categories'**
  String get inbound_categories;

  /// No description provided for @outbound_categories.
  ///
  /// In en, this message translates to:
  /// **'Outbound Categories'**
  String get outbound_categories;

  /// No description provided for @select_object_type.
  ///
  /// In en, this message translates to:
  /// **'Select object types'**
  String get select_object_type;

  /// No description provided for @pro_benefits_description.
  ///
  /// In en, this message translates to:
  /// **'All premium features of the app (Unlimited stores, customers, suppliers, wallets)'**
  String get pro_benefits_description;

  /// No description provided for @pro_lifetime_benefits_description.
  ///
  /// In en, this message translates to:
  /// **'With one-time purchase you will be able to use all advanced features forever'**
  String get pro_lifetime_benefits_description;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// No description provided for @payonce.
  ///
  /// In en, this message translates to:
  /// **'Pay once use forever'**
  String get payonce;

  /// No description provided for @title_report_list_of_wallet.
  ///
  /// In en, this message translates to:
  /// **'List of wallets'**
  String get title_report_list_of_wallet;

  /// No description provided for @hint_search_by.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get hint_search_by;

  /// No description provided for @field_my_company_name.
  ///
  /// In en, this message translates to:
  /// **'Company name'**
  String get field_my_company_name;

  /// No description provided for @field_reorder.
  ///
  /// In en, this message translates to:
  /// **'Reorder'**
  String get field_reorder;

  /// No description provided for @title_filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get title_filter;

  /// No description provided for @action_reset_all.
  ///
  /// In en, this message translates to:
  /// **'Reset all'**
  String get action_reset_all;

  /// No description provided for @action_apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get action_apply;

  /// No description provided for @by_category.
  ///
  /// In en, this message translates to:
  /// **'By category'**
  String get by_category;

  /// No description provided for @by_wallet.
  ///
  /// In en, this message translates to:
  /// **'By wallet'**
  String get by_wallet;

  /// No description provided for @by_customer.
  ///
  /// In en, this message translates to:
  /// **'By customer'**
  String get by_customer;

  /// No description provided for @by_supplier.
  ///
  /// In en, this message translates to:
  /// **'By supplier'**
  String get by_supplier;

  /// No description provided for @by_date.
  ///
  /// In en, this message translates to:
  /// **'By date'**
  String get by_date;

  /// No description provided for @show_all.
  ///
  /// In en, this message translates to:
  /// **'Show all'**
  String get show_all;

  /// No description provided for @start_date.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get start_date;

  /// No description provided for @end_date.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get end_date;

  /// No description provided for @hint_tap_first_column.
  ///
  /// In en, this message translates to:
  /// **'Tap items in the first column to see details'**
  String get hint_tap_first_column;

  /// No description provided for @by_status.
  ///
  /// In en, this message translates to:
  /// **'By status'**
  String get by_status;

  /// No description provided for @status_paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get status_paid;

  /// No description provided for @status_unpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get status_unpaid;

  /// No description provided for @action_yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get action_yes;

  /// No description provided for @action_no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get action_no;

  /// No description provided for @buy_subscription_to_add_more_entity.
  ///
  /// In en, this message translates to:
  /// **'Without the subscription you can add only %s entities. Upgrade to the premium version and unlock unlimited access!'**
  String get buy_subscription_to_add_more_entity;

  /// No description provided for @sort_by_date.
  ///
  /// In en, this message translates to:
  /// **'Sort by date'**
  String get sort_by_date;

  /// No description provided for @newest_to_oldest.
  ///
  /// In en, this message translates to:
  /// **'Newest first'**
  String get newest_to_oldest;

  /// No description provided for @oldest_to_newest.
  ///
  /// In en, this message translates to:
  /// **'Oldest first'**
  String get oldest_to_newest;

  /// No description provided for @sort_by_name.
  ///
  /// In en, this message translates to:
  /// **'Sort by name'**
  String get sort_by_name;

  /// No description provided for @sort_by_barcode.
  ///
  /// In en, this message translates to:
  /// **'Sort by barcode'**
  String get sort_by_barcode;

  /// No description provided for @sort_by_quantity.
  ///
  /// In en, this message translates to:
  /// **'Sort by quantity'**
  String get sort_by_quantity;

  /// No description provided for @action_create_payment.
  ///
  /// In en, this message translates to:
  /// **'Create a payment'**
  String get action_create_payment;

  /// No description provided for @action_view_payments.
  ///
  /// In en, this message translates to:
  /// **'View linked payments'**
  String get action_view_payments;

  /// No description provided for @action_back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get action_back;

  /// No description provided for @select_payment_type.
  ///
  /// In en, this message translates to:
  /// **'Select payment type'**
  String get select_payment_type;

  /// No description provided for @notification_low_stock_alert_title.
  ///
  /// In en, this message translates to:
  /// **'Low Stock Alert'**
  String get notification_low_stock_alert_title;

  /// No description provided for @notification_low_stock_alert_message.
  ///
  /// In en, this message translates to:
  /// **'Some items are low in stock. Please review them.'**
  String get notification_low_stock_alert_message;

  /// No description provided for @text_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get text_cancel;

  /// No description provided for @scan_bar_code_title.
  ///
  /// In en, this message translates to:
  /// **'Scan Bar code'**
  String get scan_bar_code_title;

  /// No description provided for @enter_pin_to_unlock.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN to unlock'**
  String get enter_pin_to_unlock;

  /// No description provided for @notification_permission.
  ///
  /// In en, this message translates to:
  /// **'Notification Permission'**
  String get notification_permission;

  /// No description provided for @notification_permission_content.
  ///
  /// In en, this message translates to:
  /// **'Please enable notifications in system settings.'**
  String get notification_permission_content;

  /// No description provided for @open_settings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get open_settings;

  /// No description provided for @notification_permission_required_message.
  ///
  /// In en, this message translates to:
  /// **'Notification permission is required to enable alerts.'**
  String get notification_permission_required_message;

  /// No description provided for @company_info_message.
  ///
  /// In en, this message translates to:
  /// **'This data will be displayed in printed form (invoices, sales, receipts, etc...'**
  String get company_info_message;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Themes'**
  String get theme;

  /// No description provided for @app_theme.
  ///
  /// In en, this message translates to:
  /// **'App Theme'**
  String get app_theme;

  /// No description provided for @documents_colors.
  ///
  /// In en, this message translates to:
  /// **'Documents colors'**
  String get documents_colors;

  /// No description provided for @choose_theme.
  ///
  /// In en, this message translates to:
  /// **'Choose theme'**
  String get choose_theme;

  /// No description provided for @theme_system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get theme_system;

  /// No description provided for @theme_light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get theme_light;

  /// No description provided for @theme_dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get theme_dark;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'de', 'en', 'es', 'fr', 'hi', 'ja', 'pt', 'ru', 'vi', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fr': return AppLocalizationsFr();
    case 'hi': return AppLocalizationsHi();
    case 'ja': return AppLocalizationsJa();
    case 'pt': return AppLocalizationsPt();
    case 'ru': return AppLocalizationsRu();
    case 'vi': return AppLocalizationsVi();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
