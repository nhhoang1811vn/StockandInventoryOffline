// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get home_title => 'Home';

  @override
  String get goods_title => 'Goods';

  @override
  String get goods_select_title => 'Select A Good';

  @override
  String get expenses_title => 'Expenses';

  @override
  String get empty_goods => 'No goods';

  @override
  String get good => 'Good';

  @override
  String get folder => 'Group';

  @override
  String get save_goods_title => 'Save Good';

  @override
  String get documents_title => 'Documents';

  @override
  String get save_expense_title => 'Save Expense';

  @override
  String get empty_expense => 'No Expenses';

  @override
  String get empty_document => 'No documents';

  @override
  String get empty_incoming_document => 'No incoming document';

  @override
  String get empty_outgoing_document => 'No outgoing document';

  @override
  String get document_list_tab_all => 'All';

  @override
  String get incoming_document_text => 'Incoming';

  @override
  String get outgoing_document_text => 'Outgoing';

  @override
  String get select_document_type => 'Select document type';

  @override
  String get document_information => 'Document information';

  @override
  String get goods_information => 'Goods information';

  @override
  String get save_document_batch_scan => 'Batch scan';

  @override
  String get save_document_sort_by => 'Sort by';

  @override
  String get save_document_help => 'Help';

  @override
  String get more_title => 'More';

  @override
  String get stores_title => 'Stores';

  @override
  String get stores_description => 'Stores Information';

  @override
  String get stores_select_title => 'Select A Store';

  @override
  String get save_store_title => 'Save Store';

  @override
  String get empty_stores => 'No Store';

  @override
  String get delete_store_error =>
      'This is your only store, can not perform this action';

  @override
  String get suppliers_title => 'Suppliers';

  @override
  String get suppliers_select_title => 'Select a Supplier';

  @override
  String get save_supplier_title => 'Save Supplier';

  @override
  String get empty_suppliers => 'No Supplier';

  @override
  String get customers_title => 'Customers';

  @override
  String get customers_select_title => 'Select a Customer';

  @override
  String get save_customer_title => 'Save Customer';

  @override
  String get empty_customers => 'No Customers';

  @override
  String get save_group_title => 'Save Group';

  @override
  String get field_name => 'Name';

  @override
  String get error_field_name_empty =>
      'Please ensure the name entered is valid';

  @override
  String get field_bar_code => 'Barcode';

  @override
  String get field_quantity => 'Quantity';

  @override
  String get field_quantity_short_form => 'Quan';

  @override
  String get field_min_quantity => 'Minimum quantity';

  @override
  String get field_min_quantity_short_form => 'Min.';

  @override
  String get field_total_short_form => 'Total';

  @override
  String get field_supplier => 'Supplier';

  @override
  String get field_customer => 'Customer';

  @override
  String get field_date => 'Date';

  @override
  String get field_date_time => 'Date & Time';

  @override
  String get field_amount => 'Amount';

  @override
  String get field_paid => 'Paid';

  @override
  String get field_remaining => 'Remain';

  @override
  String get field_images => 'Images';

  @override
  String get field_document_type => 'Type';

  @override
  String get field_person_name => 'Customer/Supplier';

  @override
  String get field_total => 'Total';

  @override
  String get field_purchase_price => 'Purchase price';

  @override
  String get field_sale_price => 'Sale price';

  @override
  String get field_price => 'Price';

  @override
  String get field_revenue => 'Revenue';

  @override
  String get field_document_no => 'Document No';

  @override
  String get home_menu_item_goods => 'Goods';

  @override
  String get home_menu_item_documents => 'Documents';

  @override
  String get home_menu_item_more => 'More';

  @override
  String get message_error_negative_quantity_save_document =>
      'Can\'t perform this action, %s \'s quantity is negative';

  @override
  String get action_send_email => 'Send E-mail';

  @override
  String get action_send_sms => 'Send SMS';

  @override
  String get action_phone_call => 'Phone Call';

  @override
  String get action_view_transaction => 'View Transactions';

  @override
  String get action_edit => 'Edit';

  @override
  String get action_delete => 'Delete';

  @override
  String get action_view_document => 'View documents';

  @override
  String get message_name_blank => 'Name can not be blank';

  @override
  String get notification_dialog_title => 'Notification';

  @override
  String get question_push_data => 'Would you like to save the data to Server?';

  @override
  String get title_store_selecting => 'Selection store';

  @override
  String get message_delete_supplier_error_having_document =>
      'You have documents attached to the supplier, can not perform this action';

  @override
  String get message_delete_customer_error_having_document =>
      'You have documents attached to the supplier, can not perform this action';

  @override
  String get action_ok => 'OK';

  @override
  String get action_cancel => 'Cancel';

  @override
  String get search_by_customer_supplier => 'By customer/supplier';

  @override
  String get action_move_to_group => 'Move to group';

  @override
  String get action_edit_group => 'Edit group';

  @override
  String get action_add_attachment => 'Tap to add files';

  @override
  String get action_take_picture => 'Take a picture';

  @override
  String get dialog_title_sort_by => 'Sort by';

  @override
  String get sort_by_option_no_sort_text => 'No sort';

  @override
  String get sort_by_option_a_to_z_text => 'A to Z';

  @override
  String get sort_by_option_z_to_a_text => 'Z to A';

  @override
  String get sort_by_option_ascending_text => 'Ascending';

  @override
  String get sort_by_option_descending_text => 'Descending';

  @override
  String get in_stock_text => 'In Stock: %s';

  @override
  String get menu_item_invite_friend_header => 'Invite friends';

  @override
  String get send_mail_invite_friend_subject => 'Invitation using App';

  @override
  String get send_mail_invite_friend_content =>
      'This is a good application, I use it everyday and recommend it for you. Download for Android: https://play.google.com/store/apps/details?id=com.steam.goodmanagerflutter. Download for iOS: https://apps.apple.com/us/app/stock-and-inventory/id6670546293';

  @override
  String get menu_item_write_review_header => 'Write a review';

  @override
  String get menu_item_write_review_description =>
      'Share your review to everyone';

  @override
  String get menu_item_feedback_header => 'Feedback';

  @override
  String get menu_item_feedback_description =>
      'Share your feedback to improve the app';

  @override
  String get menu_item_community_header => 'Community';

  @override
  String get menu_item_community_description => 'Join our app community';

  @override
  String get menu_item_donation => 'Donation!';

  @override
  String get menu_item_delete_account => 'Delete my account';

  @override
  String get menu_item_upgrade_account => 'Upgrade account';

  @override
  String get menu_item_upgrade_account_subtitle =>
      'You are on guest mode, upgrade to normal account to sync progress';

  @override
  String get menu_item_sign_out => 'Sign out';

  @override
  String get menu_item_whats_new_header => 'What\'s new';

  @override
  String get menu_item_whats_new_description => 'What\'s new information';

  @override
  String get on_boarding_title_1 => 'Stores Manage';

  @override
  String get on_boarding_content_1 =>
      'You can create a lot of stores to manage your goods and tracking their information. eg: Fruit Store, Vegetable Stores....';

  @override
  String get on_boarding_title_2 => 'Goods Manage';

  @override
  String get on_boarding_content_2 =>
      'It\'s contains list(catalog) of all your goods including information about quantity in stock. eg: Light bulb, todo';

  @override
  String get on_boarding_title_3 => 'Documents Manage';

  @override
  String get on_boarding_content_3 =>
      'You can create incoming/outgoing documents to increase/decrease your goods quantity in stock';

  @override
  String get on_boarding_title_4 => 'Start now';

  @override
  String get on_boarding_header_4 => 'Input your first store name';

  @override
  String get action_done => 'Done';

  @override
  String get action_skip => 'Skip';

  @override
  String get message_confirm_delete_no_args => 'Are you sure to delete it?';

  @override
  String get message_confirm_delete => 'Are you sure to delete %s?';

  @override
  String get message_confirm_delete_account =>
      'Are you sure to delete your account ?';

  @override
  String get delete_account_successful => 'Your account has been deleted';

  @override
  String get menu_item_settings_title => 'Settings';

  @override
  String get menu_item_settings_desc => 'Settings Information';

  @override
  String get menu_item_general => 'General';

  @override
  String get menu_item_view => 'Display';

  @override
  String get menu_item_barcode_scanner => 'Barcode scanner';

  @override
  String get menu_item_minimum_quantity => 'Minimum quantity';

  @override
  String get menu_item_show_min_quantity_items_page_title =>
      'Show minimum quantity in item\'s page';

  @override
  String get menu_item_show_min_quantity_list_page_title =>
      'Show minimum quantity in list page';

  @override
  String get menu_item_min_quantity_color_title =>
      'Color for goods needing reorder';

  @override
  String get menu_item_show_low_stock_alert_title => 'Show Low Stock Alerts';

  @override
  String get menu_item_show_low_stock_alert_desc =>
      'When you open the app, we will send you the notification to warning you';

  @override
  String get menu_item_my_company => 'Company Information';

  @override
  String get menu_item_backup_and_restore => 'Back up and restore';

  @override
  String get menu_item_language_title => 'Language';

  @override
  String get menu_item_language_desc => 'Change Language';

  @override
  String get menu_item_passcode_title => 'Pass code lock';

  @override
  String get menu_item_passcode_desc => 'Desc';

  @override
  String get menu_item_reset_numeration_documents_title =>
      'Reset numeration of documents';

  @override
  String get settings_title => 'Settings';

  @override
  String get subscriptions_title => 'Subscriptions';

  @override
  String get dialog_title_change_language => 'Select language';

  @override
  String get english_text => 'English';

  @override
  String get vietnamese_text => 'Vietnamese';

  @override
  String get incoming_goods => 'Incoming Goods';

  @override
  String get outgoing_goods => 'Outgoing Goods';

  @override
  String get report_title => 'Report';

  @override
  String get select_store_title => 'Select store';

  @override
  String get select_group_title => 'Select group';

  @override
  String get select_message_type => 'Select Message Type';

  @override
  String get message_type_bug_report => 'Bug report';

  @override
  String get message_type_feedback => 'Feedback';

  @override
  String get message_type_suggestion => 'Suggestion';

  @override
  String get message_type_question => 'Question';

  @override
  String get send_mail_bug_report_subject => 'Stock and inventory - Bug Report';

  @override
  String get send_mail_feedback_subject => 'Stock and inventory - Feedback';

  @override
  String get send_mail_suggestion_subject => 'Stock and inventory - Suggestion';

  @override
  String get send_mail_question_subject => 'Stock and inventory - Question';

  @override
  String get dialog_title_data_not_save => 'Attention!';

  @override
  String get dialog_content_data_not_save => 'Close without saving';

  @override
  String get batch_mode_scan => 'Batch mode scan';

  @override
  String get after_each_scan => 'After each scan';

  @override
  String get after_each_scan_auto => 'Auto increment quantity by 1';

  @override
  String get after_each_scan_manually => 'Set quantity manually';

  @override
  String get when_a_barcode_is_found => 'When a barcode is found';

  @override
  String get beep => 'Beep';

  @override
  String get vibrate => 'Vibrate';

  @override
  String get question_or_suggestion_title => 'Question or suggestion';

  @override
  String get review_the_app_title => 'Review the app';

  @override
  String get help_title => 'Help';

  @override
  String get whats_new_title => 'What\'s New';

  @override
  String get terms_of_use_title => 'Terms of Use';

  @override
  String get privacy_policy_title => 'Privacy Policy';

  @override
  String get your_subscriptions_title => 'Your subscriptions';

  @override
  String get document_name_no => 'No.';

  @override
  String get insert_transaction_success => 'Added item successful!';

  @override
  String get insert_transaction_fail => 'Added item failed!';

  @override
  String get success => 'Success!';

  @override
  String get error => 'Error!';

  @override
  String get error_same_barcode => 'Error: same bar code';

  @override
  String get action_search => 'Search';

  @override
  String get action_sort_by => 'Sort by';

  @override
  String get action_export_csv => 'Export CSV';

  @override
  String get action_export_pdf => 'Export PDF';

  @override
  String get action_batch_scan => 'Batch scan';

  @override
  String get action_help => 'Help';

  @override
  String get report_type_goods => 'List of Goods';

  @override
  String get report_type_expenses => 'Expenses';

  @override
  String get report_type_list_of_documents => 'List of documents';

  @override
  String get report_type_debt_by_supplier => 'Debt of Supplier';

  @override
  String get report_type_debt_by_customer => 'Debt of Customer';

  @override
  String get report_type_inbound_payments => 'Inbound payments';

  @override
  String get report_type_outbound_payments => 'Outbound payments';

  @override
  String get report_type_list_of_supplier_payments => 'Payments by Suppliers';

  @override
  String get report_type_list_of_customer_payments => 'Payments by Customer';

  @override
  String get report_type_reorder => 'Reorder';

  @override
  String get select_date_range => 'Select date range';

  @override
  String get report_type_current_month => 'Current month';

  @override
  String get report_type_last_30_days => 'Last 30 days';

  @override
  String get report_type_last_90_days => 'Last 90 days';

  @override
  String get report_type_current_year => 'Current year';

  @override
  String get report_type_custom => 'Custom';

  @override
  String get report_detail_period_time => 'From %s to %s';

  @override
  String get report_detail_store => 'Store %s';

  @override
  String get select_payment_status => 'Select payment status';

  @override
  String get payment_status_unpaid => 'Unpaid';

  @override
  String get payment_status_partial => 'Partial';

  @override
  String get payment_status_paid => 'Paid';

  @override
  String get payments_title => 'Payments';

  @override
  String get payment_invoiced => 'Invoiced';

  @override
  String get payment_due_pending => 'Due/pending';

  @override
  String get payment_paid => 'Paid';

  @override
  String get empty_payment => 'No Payment';

  @override
  String get title_outbound_payment => 'Outbound';

  @override
  String get title_inbound_payment => 'Inbound';

  @override
  String get save_outbound_payment_title => 'Save Outbound Payment';

  @override
  String get save_inbound_payment_title => 'Save Inbound Payment';

  @override
  String get menu_back_up => 'Back up data';

  @override
  String get menu_back_up_desc => 'Export database file to the phone';

  @override
  String get menu_restore => 'Restore data';

  @override
  String get menu_restore_desc => 'Import database file';

  @override
  String get backup_successful => 'Back up data successful';

  @override
  String get backup_error => 'Back up data failed!!';

  @override
  String get error_wrong_email_password =>
      'Wrong email or password, please try again';

  @override
  String get menu_push_data_to_cloud => 'Save the data to cloud';

  @override
  String get menu_quick_sync_title => 'Quick sync';

  @override
  String get menu_quick_sync_desc =>
      'It will restart the app, and sync the latest app data';

  @override
  String get login => 'LOGIN';

  @override
  String get email => 'Email';

  @override
  String get error_email => 'Please input valid email';

  @override
  String get password => 'Password';

  @override
  String get error_password => 'Please input valid password';

  @override
  String get forgot_your_password => 'Forgot your password ?';

  @override
  String get or_sign_in_with => 'or Sign in with';

  @override
  String get dont_have_an_account_yet => 'Don\'t have an account yet ?';

  @override
  String get sign_up_text => 'Sign up';

  @override
  String get sign_up => 'SIGN UP';

  @override
  String get name => 'Name';

  @override
  String get reset_password => 'RESET PASSWORD';

  @override
  String get email_not_verified_title => 'Email Not Verified';

  @override
  String get email_not_verified_desc =>
      'Please check your email and verify your email.';

  @override
  String get sign_up_successful => 'Sign up success';

  @override
  String get reset_password_successful => 'Reset password Success';

  @override
  String get cloud_file_no_updated => 'Not updated yet';

  @override
  String get signout_message => 'Are you sure want to log out ?';

  @override
  String get item_history_title => 'Item History';

  @override
  String get list_settings => 'List Settings';

  @override
  String get good_settings_hide_zero_entries => 'Hide zero entries';

  @override
  String get good_setting_show_bar_code => 'Show barcode';

  @override
  String get good_setting_show_description => 'Show description';

  @override
  String get version => 'Version: %s';

  @override
  String get change_tracking_store => 'Change tracking store';

  @override
  String get loading_data => 'Loading data...';

  @override
  String get title_good_count => 'Number of items';

  @override
  String get title_total_quantity => 'Total Quantity';

  @override
  String get title_select_document => 'Select document';

  @override
  String get title_chart_sale_report => 'Sale Report in last 6 months';

  @override
  String get label_select_payment_category => 'Select category';

  @override
  String get label_select_wallet => 'Select wallet';

  @override
  String get label_select_object => 'Select object';

  @override
  String get label_select_outbound_object => 'Select outbound object';

  @override
  String get label_select_inbound_object => 'Select inbound object';

  @override
  String get label_description => 'Description';

  @override
  String get hint_description => 'Input description';

  @override
  String get label_select_document_no => 'Document No';

  @override
  String get label_supplier_name => 'Supplier name';

  @override
  String get label_customer_name => 'Customer name';

  @override
  String get label_group_name => 'Group name';

  @override
  String get label_good_name => 'Good name';

  @override
  String get label_category_name => 'Category name';

  @override
  String get label_wallet_name => 'Wallet name';

  @override
  String get hint_name => 'Input name';

  @override
  String get label_address => 'Address';

  @override
  String get hint_address => 'Input address';

  @override
  String get label_email => 'Email';

  @override
  String get hint_email => 'Input email';

  @override
  String get label_phone_number => 'Phone number';

  @override
  String get hint_phone_number => 'Input phone number';

  @override
  String get label_tax_id => 'Tax ID';

  @override
  String get hint_tax_id => 'Input tax id';

  @override
  String get label_bank_details => 'Bank details';

  @override
  String get hint_bank_details => 'Input bank details';

  @override
  String get label_bar_code => 'Barcode';

  @override
  String get hint_bar_code => 'Input bar code';

  @override
  String get action_save => 'Save';

  @override
  String get hint_select => 'Select';

  @override
  String get action_add_payment_category => 'Add category';

  @override
  String get title_pick_color => 'Pick color';

  @override
  String get action_add_group => 'Add group';

  @override
  String get action_add_good => 'Add good';

  @override
  String get no_category => 'No category';

  @override
  String get field_start_period => 'Start Period';

  @override
  String get field_in => 'In';

  @override
  String get field_out => 'Out';

  @override
  String get field_end_period => 'End Period';

  @override
  String get action_document_created_withname => 'Document %s was created';

  @override
  String get good_information => 'Good information';

  @override
  String get images_information => 'Images information';

  @override
  String get change_color => 'Change color';

  @override
  String get change_icon => 'Change icon';

  @override
  String get save_file_successful => 'Save file successful at %s';

  @override
  String get save_file_failed => 'Save file failed at %s';

  @override
  String get no_group => 'No group';

  @override
  String get save_wallet_title => 'Save Wallet';

  @override
  String get action_add_wallet => 'Add Wallet';

  @override
  String get total_balance => 'Total Balance';

  @override
  String get title_wallet => 'Wallets';

  @override
  String get categories => 'Categories';

  @override
  String get title_save_category => 'Save Category';

  @override
  String get inbound_categories => 'Inbound Categories';

  @override
  String get outbound_categories => 'Outbound Categories';

  @override
  String get select_object_type => 'Select object types';

  @override
  String get pro_benefits_description =>
      'All premium features of the app (Unlimited stores, customers, suppliers, wallets)';

  @override
  String get pro_lifetime_benefits_description =>
      'With one-time purchase you will be able to use all advanced features forever';

  @override
  String get monthly => 'Monthly';

  @override
  String get yearly => 'Yearly';

  @override
  String get payonce => 'Pay once use forever';

  @override
  String get title_report_list_of_wallet => 'List of wallets';

  @override
  String get hint_search_by => 'Search...';

  @override
  String get field_my_company_name => 'Company name';

  @override
  String get field_reorder => 'Reorder';

  @override
  String get title_filter => 'Filter';

  @override
  String get action_reset_all => 'Reset all';

  @override
  String get action_apply => 'Apply';

  @override
  String get by_category => 'By category';

  @override
  String get by_wallet => 'By wallet';

  @override
  String get by_customer => 'By customer';

  @override
  String get by_supplier => 'By supplier';

  @override
  String get by_date => 'By date';

  @override
  String get show_all => 'Show all';

  @override
  String get start_date => 'Start date';

  @override
  String get end_date => 'End date';

  @override
  String get hint_tap_first_column =>
      'Tap items in the first column to see details';

  @override
  String get by_status => 'By status';

  @override
  String get status_paid => 'Paid';

  @override
  String get status_unpaid => 'Unpaid';

  @override
  String get action_yes => 'Yes';

  @override
  String get action_no => 'No';

  @override
  String get buy_subscription_to_add_more_entity =>
      'Without the subscription you can add only %s entities. Upgrade to the premium version and unlock unlimited access!';

  @override
  String get sort_by_date => 'Sort by date';

  @override
  String get newest_to_oldest => 'Newest first';

  @override
  String get oldest_to_newest => 'Oldest first';

  @override
  String get sort_by_name => 'Sort by name';

  @override
  String get sort_by_barcode => 'Sort by barcode';

  @override
  String get sort_by_quantity => 'Sort by quantity';

  @override
  String get action_create_payment => 'Create a payment';

  @override
  String get action_view_payments => 'View linked payments';

  @override
  String get action_back => 'Back';

  @override
  String get select_payment_type => 'Select payment type';

  @override
  String get notification_low_stock_alert_title => 'Low Stock Alert';

  @override
  String get notification_low_stock_alert_message =>
      'Some items are low in stock. Please review them.';

  @override
  String get text_cancel => 'Cancel';

  @override
  String get scan_bar_code_title => 'Scan Bar code';

  @override
  String get enter_pin_to_unlock => 'Enter PIN to unlock';

  @override
  String get notification_permission => 'Notification Permission';

  @override
  String get notification_permission_content =>
      'Please enable notifications in system settings.';

  @override
  String get open_settings => 'Open settings';

  @override
  String get notification_permission_required_message =>
      'Notification permission is required to enable alerts.';

  @override
  String get company_info_message =>
      'This data will be displayed in printed form (invoices, sales, receipts, etc...';

  @override
  String get theme => 'Themes';

  @override
  String get app_theme => 'App Theme';

  @override
  String get documents_colors => 'Documents colors';

  @override
  String get choose_theme => 'Choose theme';

  @override
  String get theme_system => 'System';

  @override
  String get theme_light => 'Light';

  @override
  String get theme_dark => 'Dark';
}
