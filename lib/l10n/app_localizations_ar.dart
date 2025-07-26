// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get home_title => 'بيت';

  @override
  String get goods_title => 'بضائع';

  @override
  String get goods_select_title => 'اختر جيدا';

  @override
  String get expenses_title => 'نفقات';

  @override
  String get empty_goods => 'لا يوجد بضائع';

  @override
  String get good => 'جيد';

  @override
  String get folder => 'مجموعة';

  @override
  String get save_goods_title => 'حفظ جيد';

  @override
  String get documents_title => 'وثائق';

  @override
  String get save_expense_title => 'توفير النفقات';

  @override
  String get empty_expense => 'لا توجد نفقات';

  @override
  String get empty_document => 'لا يوجد مستندات';

  @override
  String get empty_incoming_document => 'لا يوجد مستند وارد';

  @override
  String get empty_outgoing_document => 'لا يوجد مستند صادر';

  @override
  String get document_list_tab_all => 'الجميع';

  @override
  String get incoming_document_text => 'وارد';

  @override
  String get outgoing_document_text => 'صادر';

  @override
  String get select_document_type => 'حدد نوع المستند';

  @override
  String get document_information => 'معلومات الوثيقة';

  @override
  String get goods_information => 'معلومات البضائع';

  @override
  String get save_document_batch_scan => 'مسح الدفعة';

  @override
  String get save_document_sort_by => 'فرز حسب';

  @override
  String get save_document_help => 'يساعد';

  @override
  String get more_title => 'أكثر';

  @override
  String get stores_title => 'المتاجر';

  @override
  String get stores_description => 'معلومات المتاجر';

  @override
  String get stores_select_title => 'اختر متجرًا';

  @override
  String get save_store_title => 'حفظ المتجر';

  @override
  String get empty_stores => 'لا يوجد متجر';

  @override
  String get delete_store_error => 'هذا هو متجرك الوحيد، لا يمكنك تنفيذ هذا الإجراء';

  @override
  String get suppliers_title => 'الموردين';

  @override
  String get suppliers_select_title => 'اختر المورد';

  @override
  String get save_supplier_title => 'حفظ المورد';

  @override
  String get empty_suppliers => 'لا يوجد مورد';

  @override
  String get customers_title => 'عملاء';

  @override
  String get customers_select_title => 'حدد العميل';

  @override
  String get save_customer_title => 'حفظ العميل';

  @override
  String get empty_customers => 'لا يوجد عملاء';

  @override
  String get save_group_title => 'حفظ المجموعة';

  @override
  String get field_name => 'اسم';

  @override
  String get error_field_name_empty => 'يرجى التأكد من أن الاسم المدخل صالح';

  @override
  String get field_bar_code => 'الباركود';

  @override
  String get field_quantity => 'كمية';

  @override
  String get field_quantity_short_form => 'كوان';

  @override
  String get field_min_quantity => 'الحد الأدنى للكمية';

  @override
  String get field_min_quantity_short_form => 'الحد الأدنى';

  @override
  String get field_total_short_form => 'المجموع';

  @override
  String get field_supplier => 'مزود';

  @override
  String get field_customer => 'عميل';

  @override
  String get field_date => 'تاريخ';

  @override
  String get field_date_time => 'التاريخ والوقت';

  @override
  String get field_amount => 'كمية';

  @override
  String get field_paid => 'مدفوع';

  @override
  String get field_remaining => 'يبقى';

  @override
  String get field_images => 'الصور';

  @override
  String get field_document_type => 'يكتب';

  @override
  String get field_person_name => 'العميل/المورد';

  @override
  String get field_total => 'المجموع';

  @override
  String get field_purchase_price => 'سعر الشراء';

  @override
  String get field_sale_price => 'سعر البيع';

  @override
  String get field_price => 'سعر';

  @override
  String get field_revenue => 'ربح';

  @override
  String get field_document_no => 'رقم الوثيقة';

  @override
  String get home_menu_item_goods => 'بضائع';

  @override
  String get home_menu_item_documents => 'وثائق';

  @override
  String get home_menu_item_more => 'أكثر';

  @override
  String get message_error_negative_quantity_save_document => 'لا يمكن تنفيذ هذا الإجراء، كمية %s سلبية';

  @override
  String get action_send_email => 'إرسال بريد إلكتروني';

  @override
  String get action_send_sms => 'إرسال رسالة نصية قصيرة';

  @override
  String get action_phone_call => 'مكالمة هاتفية';

  @override
  String get action_view_transaction => 'عرض المعاملات';

  @override
  String get action_edit => 'يحرر';

  @override
  String get action_delete => 'يمسح';

  @override
  String get action_view_document => 'عرض المستندات';

  @override
  String get message_name_blank => 'لا يمكن أن يكون الاسم فارغًا';

  @override
  String get notification_dialog_title => 'إشعار';

  @override
  String get question_push_data => 'هل ترغب في حفظ البيانات على الخادم؟';

  @override
  String get title_store_selecting => 'متجر الاختيار';

  @override
  String get message_delete_supplier_error_having_document => 'لديك مستندات مرفقة بالمورد، لا يمكنك تنفيذ هذا الإجراء';

  @override
  String get message_delete_customer_error_having_document => 'لديك مستندات مرفقة بالمورد، لا يمكنك تنفيذ هذا الإجراء';

  @override
  String get action_ok => 'نعم';

  @override
  String get action_cancel => 'يلغي';

  @override
  String get search_by_customer_supplier => 'حسب العميل/المورد';

  @override
  String get action_move_to_group => 'انتقل إلى المجموعة';

  @override
  String get action_edit_group => 'تحرير المجموعة';

  @override
  String get action_add_attachment => 'انقر لإضافة الملفات';

  @override
  String get action_take_picture => 'التقط صورة';

  @override
  String get dialog_title_sort_by => 'فرز حسب';

  @override
  String get sort_by_option_no_sort_text => 'لا يوجد نوع';

  @override
  String get sort_by_option_a_to_z_text => 'من الألف إلى الياء';

  @override
  String get sort_by_option_z_to_a_text => 'من الياء إلى الألف';

  @override
  String get sort_by_option_ascending_text => 'تصاعدي';

  @override
  String get sort_by_option_descending_text => 'تنازلي';

  @override
  String get in_stock_text => 'في المخزون: %s';

  @override
  String get menu_item_invite_friend_header => 'دعوة الأصدقاء';

  @override
  String get send_mail_invite_friend_subject => 'دعوة باستخدام التطبيق';

  @override
  String get send_mail_invite_friend_content => 'هذا تطبيق جيد، أستخدمه يوميًا وأوصي به. حمّله لأجهزة أندرويد: https://play.google.com/store/apps/details?id=com.steam.goodmanagerflutter. حمّله لأجهزة iOS: https://apps.apple.com/us/app/stock-and-inventory/id6670546293';

  @override
  String get menu_item_write_review_header => 'اكتب مراجعة';

  @override
  String get menu_item_write_review_description => 'شارك بمراجعتك مع الجميع';

  @override
  String get menu_item_feedback_header => 'تعليق';

  @override
  String get menu_item_feedback_description => 'شارك بتعليقاتك لتحسين التطبيق';

  @override
  String get menu_item_community_header => 'مجتمع';

  @override
  String get menu_item_community_description => 'انضم إلى مجتمع التطبيقات لدينا';

  @override
  String get menu_item_donation => 'هبة!';

  @override
  String get menu_item_delete_account => 'حذف حسابي';

  @override
  String get menu_item_upgrade_account => 'ترقية الحساب';

  @override
  String get menu_item_upgrade_account_subtitle => 'أنت في وضع الضيف، قم بالترقية إلى الحساب العادي لمزامنة التقدم';

  @override
  String get menu_item_sign_out => 'تسجيل الخروج';

  @override
  String get menu_item_whats_new_header => 'ما الجديد';

  @override
  String get menu_item_whats_new_description => 'ما هي المعلومات الجديدة';

  @override
  String get on_boarding_title_1 => 'إدارة المتاجر';

  @override
  String get on_boarding_content_1 => 'يمكنك إنشاء العديد من المتاجر لإدارة بضائعك وتتبع معلوماتها. على سبيل المثال: متجر الفاكهة، متاجر الخضار....';

  @override
  String get on_boarding_title_2 => 'إدارة البضائع';

  @override
  String get on_boarding_content_2 => 'يحتوي على قائمة (كتالوج) لجميع البضائع لديك بما في ذلك معلومات حول الكمية الموجودة في المخزون. على سبيل المثال: المصباح الكهربائي، المهام';

  @override
  String get on_boarding_title_3 => 'إدارة المستندات';

  @override
  String get on_boarding_content_3 => 'يمكنك إنشاء مستندات واردة/صادرة لزيادة/تقليل كمية البضائع الموجودة في المخزون';

  @override
  String get on_boarding_title_4 => 'ابدأ الآن';

  @override
  String get on_boarding_header_4 => 'أدخل اسم متجرك الأول';

  @override
  String get action_done => 'منتهي';

  @override
  String get action_skip => 'يتخطى';

  @override
  String get message_confirm_delete_no_args => 'هل أنت متأكد من حذفه؟';

  @override
  String get message_confirm_delete => 'هل أنت متأكد من حذف %s؟';

  @override
  String get message_confirm_delete_account => 'هل أنت متأكد من حذف حسابك؟';

  @override
  String get delete_account_successful => 'لقد تم حذف حسابك';

  @override
  String get menu_item_settings_title => 'إعدادات';

  @override
  String get menu_item_settings_desc => 'معلومات الإعدادات';

  @override
  String get menu_item_general => 'عام';

  @override
  String get menu_item_view => 'عرض';

  @override
  String get menu_item_barcode_scanner => 'ماسح الباركود';

  @override
  String get menu_item_minimum_quantity => 'الحد الأدنى للكمية';

  @override
  String get menu_item_show_min_quantity_items_page_title => 'إظهار الحد الأدنى للكمية في صفحة العنصر';

  @override
  String get menu_item_show_min_quantity_list_page_title => 'إظهار الحد الأدنى للكمية في صفحة القائمة';

  @override
  String get menu_item_min_quantity_color_title => 'لون البضائع التي تحتاج إلى إعادة الطلب';

  @override
  String get menu_item_show_low_stock_alert_title => 'إظهار تنبيهات انخفاض المخزون';

  @override
  String get menu_item_show_low_stock_alert_desc => 'عند فتح التطبيق، سنرسل إليك إشعارًا لتحذيرك';

  @override
  String get menu_item_my_company => 'معلومات الشركة';

  @override
  String get menu_item_backup_and_restore => 'النسخ الاحتياطي والاستعادة';

  @override
  String get menu_item_language_title => 'لغة';

  @override
  String get menu_item_language_desc => 'تغيير اللغة';

  @override
  String get menu_item_passcode_title => 'قفل رمز المرور';

  @override
  String get menu_item_passcode_desc => 'الوصف';

  @override
  String get menu_item_reset_numeration_documents_title => 'إعادة تعيين ترقيم المستندات';

  @override
  String get settings_title => 'إعدادات';

  @override
  String get subscriptions_title => 'الاشتراكات';

  @override
  String get dialog_title_change_language => 'اختر اللغة';

  @override
  String get english_text => 'إنجليزي';

  @override
  String get vietnamese_text => 'الفيتنامية';

  @override
  String get incoming_goods => 'البضائع الواردة';

  @override
  String get outgoing_goods => 'البضائع الصادرة';

  @override
  String get report_title => 'تقرير';

  @override
  String get select_store_title => 'اختر المتجر';

  @override
  String get select_group_title => 'اختر المجموعة';

  @override
  String get select_message_type => 'حدد نوع الرسالة';

  @override
  String get message_type_bug_report => 'تقرير الأخطاء';

  @override
  String get message_type_feedback => 'تعليق';

  @override
  String get message_type_suggestion => 'اقتراح';

  @override
  String get message_type_question => 'سؤال';

  @override
  String get send_mail_bug_report_subject => 'المخزون والمخزون - تقرير الخطأ';

  @override
  String get send_mail_feedback_subject => 'المخزون والمخزون - ردود الفعل';

  @override
  String get send_mail_suggestion_subject => 'المخزون والمخزون - اقتراح';

  @override
  String get send_mail_question_subject => 'المخزون والمخزون - سؤال';

  @override
  String get dialog_title_data_not_save => 'انتباه!';

  @override
  String get dialog_content_data_not_save => 'إغلاق بدون حفظ';

  @override
  String get batch_mode_scan => 'مسح الوضع الدفعي';

  @override
  String get after_each_scan => 'بعد كل مسح';

  @override
  String get after_each_scan_auto => 'زيادة الكمية تلقائيًا بمقدار 1';

  @override
  String get after_each_scan_manually => 'ضبط الكمية يدويًا';

  @override
  String get when_a_barcode_is_found => 'عندما يتم العثور على الباركود';

  @override
  String get beep => 'زمارة';

  @override
  String get vibrate => 'تذبذب';

  @override
  String get question_or_suggestion_title => 'سؤال أو اقتراح';

  @override
  String get review_the_app_title => 'مراجعة التطبيق';

  @override
  String get help_title => 'يساعد';

  @override
  String get whats_new_title => 'ما الجديد';

  @override
  String get terms_of_use_title => 'شروط الاستخدام';

  @override
  String get privacy_policy_title => 'سياسة الخصوصية';

  @override
  String get your_subscriptions_title => 'اشتراكاتك';

  @override
  String get document_name_no => 'لا.';

  @override
  String get insert_transaction_success => 'تمت إضافة العنصر بنجاح!';

  @override
  String get insert_transaction_fail => 'فشل إضافة العنصر!';

  @override
  String get success => 'نجاح!';

  @override
  String get error => 'خطأ!';

  @override
  String get error_same_barcode => 'خطأ: نفس الرمز الشريطي';

  @override
  String get action_search => 'يبحث';

  @override
  String get action_sort_by => 'فرز حسب';

  @override
  String get action_export_csv => 'تصدير ملف CSV';

  @override
  String get action_export_pdf => 'تصدير ملف PDF';

  @override
  String get action_batch_scan => 'مسح الدفعة';

  @override
  String get action_help => 'يساعد';

  @override
  String get report_type_goods => 'قائمة البضائع';

  @override
  String get report_type_expenses => 'نفقات';

  @override
  String get report_type_list_of_documents => 'قائمة الوثائق';

  @override
  String get report_type_debt_by_supplier => 'دين المورد';

  @override
  String get report_type_debt_by_customer => 'دين العميل';

  @override
  String get report_type_inbound_payments => 'المدفوعات الواردة';

  @override
  String get report_type_outbound_payments => 'المدفوعات الصادرة';

  @override
  String get report_type_list_of_supplier_payments => 'المدفوعات من قبل الموردين';

  @override
  String get report_type_list_of_customer_payments => 'المدفوعات من قبل العميل';

  @override
  String get report_type_reorder => 'إعادة ترتيب';

  @override
  String get select_date_range => 'حدد نطاق التاريخ';

  @override
  String get report_type_current_month => 'الشهر الحالي';

  @override
  String get report_type_last_30_days => 'آخر 30 يومًا';

  @override
  String get report_type_last_90_days => 'آخر 90 يومًا';

  @override
  String get report_type_current_year => 'السنة الحالية';

  @override
  String get report_type_custom => 'مخصص';

  @override
  String get report_detail_period_time => 'من %s إلى %s';

  @override
  String get report_detail_store => 'متجر %s';

  @override
  String get select_payment_status => 'حدد حالة الدفع';

  @override
  String get payment_status_unpaid => 'غير مدفوع الأجر';

  @override
  String get payment_status_partial => 'جزئي';

  @override
  String get payment_status_paid => 'مدفوع';

  @override
  String get payments_title => 'المدفوعات';

  @override
  String get payment_invoiced => 'تم إصدار الفاتورة';

  @override
  String get payment_due_pending => 'مستحق/معلق';

  @override
  String get payment_paid => 'مدفوع';

  @override
  String get empty_payment => 'لا يوجد دفع';

  @override
  String get title_outbound_payment => 'الصادر';

  @override
  String get title_inbound_payment => 'وارد';

  @override
  String get save_outbound_payment_title => 'حفظ الدفع الصادر';

  @override
  String get save_inbound_payment_title => 'حفظ الدفع الوارد';

  @override
  String get menu_back_up => 'نسخ البيانات احتياطيًا';

  @override
  String get menu_back_up_desc => 'تصدير ملف قاعدة البيانات إلى الهاتف';

  @override
  String get menu_restore => 'استعادة البيانات';

  @override
  String get menu_restore_desc => 'استيراد ملف قاعدة البيانات';

  @override
  String get backup_successful => 'تم نسخ البيانات احتياطيًا بنجاح';

  @override
  String get backup_error => 'فشل النسخ الاحتياطي للبيانات!!';

  @override
  String get error_wrong_email_password => 'البريد الإلكتروني أو كلمة المرور خاطئة، يرجى المحاولة مرة أخرى';

  @override
  String get menu_push_data_to_cloud => 'حفظ البيانات في السحابة';

  @override
  String get menu_quick_sync_title => 'المزامنة السريعة';

  @override
  String get menu_quick_sync_desc => 'سيتم إعادة تشغيل التطبيق ومزامنة أحدث بيانات التطبيق';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get email => 'بريد إلكتروني';

  @override
  String get error_email => 'الرجاء إدخال بريد إلكتروني صالح';

  @override
  String get password => 'كلمة المرور';

  @override
  String get error_password => 'الرجاء إدخال كلمة مرور صالحة';

  @override
  String get forgot_your_password => 'نسيت كلمة السر ؟';

  @override
  String get or_sign_in_with => 'أو قم بتسجيل الدخول باستخدام';

  @override
  String get dont_have_an_account_yet => 'ليس لديك حساب حتى الآن؟';

  @override
  String get sign_up_text => 'اشتراك';

  @override
  String get sign_up => 'اشتراك';

  @override
  String get name => 'اسم';

  @override
  String get reset_password => 'إعادة تعيين كلمة المرور';

  @override
  String get email_not_verified_title => 'البريد الإلكتروني غير مُتحقق';

  @override
  String get email_not_verified_desc => 'يرجى التحقق من بريدك الإلكتروني والتحقق من بريدك الإلكتروني.';

  @override
  String get sign_up_successful => 'تم التسجيل بنجاح';

  @override
  String get reset_password_successful => 'إعادة تعيين كلمة المرور بنجاح';

  @override
  String get cloud_file_no_updated => 'لم يتم التحديث بعد';

  @override
  String get signout_message => 'هل أنت متأكد من أنك تريد تسجيل الخروج؟';

  @override
  String get item_history_title => 'تاريخ العنصر';

  @override
  String get list_settings => 'إعدادات القائمة';

  @override
  String get good_settings_hide_zero_entries => 'إخفاء الإدخالات الصفرية';

  @override
  String get good_setting_show_bar_code => 'إظهار الباركود';

  @override
  String get good_setting_show_description => 'إظهار الوصف';

  @override
  String get version => 'الإصدار: %s';

  @override
  String get change_tracking_store => 'متجر تتبع التغييرات';

  @override
  String get loading_data => 'جاري تحميل البيانات...';

  @override
  String get title_good_count => 'عدد العناصر';

  @override
  String get title_total_quantity => 'الكمية الإجمالية';

  @override
  String get title_select_document => 'حدد المستند';

  @override
  String get title_chart_sale_report => 'تقرير المبيعات في الأشهر الستة الماضية';

  @override
  String get label_select_payment_category => 'اختر الفئة';

  @override
  String get label_select_wallet => 'اختر المحفظة';

  @override
  String get label_select_object => 'حدد الكائن';

  @override
  String get label_select_outbound_object => 'تحديد الكائن الصادر';

  @override
  String get label_select_inbound_object => 'تحديد الكائن الوارد';

  @override
  String get label_description => 'وصف';

  @override
  String get hint_description => 'وصف الإدخال';

  @override
  String get label_select_document_no => 'رقم الوثيقة';

  @override
  String get label_supplier_name => 'اسم المورد';

  @override
  String get label_customer_name => 'اسم العميل';

  @override
  String get label_group_name => 'اسم المجموعة';

  @override
  String get label_good_name => 'اسم جيد';

  @override
  String get label_category_name => 'اسم الفئة';

  @override
  String get label_wallet_name => 'اسم المحفظة';

  @override
  String get hint_name => 'اسم الإدخال';

  @override
  String get label_address => 'عنوان';

  @override
  String get hint_address => 'عنوان الإدخال';

  @override
  String get label_email => 'بريد إلكتروني';

  @override
  String get hint_email => 'إدخال البريد الإلكتروني';

  @override
  String get label_phone_number => 'رقم التليفون';

  @override
  String get hint_phone_number => 'أدخل رقم الهاتف';

  @override
  String get label_tax_id => 'رقم التعريف الضريبي';

  @override
  String get hint_tax_id => 'معرف ضريبة المدخلات';

  @override
  String get label_bank_details => 'تفاصيل البنك';

  @override
  String get hint_bank_details => 'أدخل تفاصيل البنك';

  @override
  String get label_bar_code => 'الباركود';

  @override
  String get hint_bar_code => 'إدخال الرمز الشريطي';

  @override
  String get action_save => 'يحفظ';

  @override
  String get hint_select => 'يختار';

  @override
  String get action_add_payment_category => 'إضافة فئة';

  @override
  String get title_pick_color => 'اختر اللون';

  @override
  String get action_add_group => 'إضافة مجموعة';

  @override
  String get action_add_good => 'أضف جيدًا';

  @override
  String get no_category => 'لا يوجد فئة';

  @override
  String get field_start_period => 'فترة البدء';

  @override
  String get field_in => 'في';

  @override
  String get field_out => 'خارج';

  @override
  String get field_end_period => 'نهاية الفترة';

  @override
  String get action_document_created_withname => 'تم إنشاء المستند %s';

  @override
  String get good_information => 'معلومات جيدة';

  @override
  String get images_information => 'معلومات الصور';

  @override
  String get change_color => 'تغيير اللون';

  @override
  String get change_icon => 'تغيير الرمز';

  @override
  String get save_file_successful => 'تم حفظ الملف بنجاح في %s';

  @override
  String get save_file_failed => 'فشل حفظ الملف في %s';

  @override
  String get no_group => 'لا يوجد مجموعة';

  @override
  String get save_wallet_title => 'حفظ المحفظة';

  @override
  String get action_add_wallet => 'إضافة المحفظة';

  @override
  String get total_balance => 'الرصيد الإجمالي';

  @override
  String get title_wallet => 'المحافظ';

  @override
  String get categories => 'فئات';

  @override
  String get title_save_category => 'حفظ الفئة';

  @override
  String get inbound_categories => 'الفئات الواردة';

  @override
  String get outbound_categories => 'فئات الصادرة';

  @override
  String get select_object_type => 'تحديد أنواع الكائنات';

  @override
  String get pro_benefits_description => 'جميع الميزات المميزة للتطبيق (متاجر غير محدودة، عملاء، موردين، محافظ)';

  @override
  String get pro_lifetime_benefits_description => 'من خلال الشراء لمرة واحدة، ستتمكن من استخدام جميع الميزات المتقدمة إلى الأبد';

  @override
  String get monthly => 'شهريا';

  @override
  String get yearly => 'سنوي';

  @override
  String get payonce => 'ادفع مرة واحدة واستخدم للأبد';

  @override
  String get title_report_list_of_wallet => 'قائمة المحافظ';

  @override
  String get hint_search_by => 'يبحث...';

  @override
  String get field_my_company_name => 'اسم الشركة';

  @override
  String get field_reorder => 'إعادة ترتيب';

  @override
  String get title_filter => 'فلتر';

  @override
  String get action_reset_all => 'إعادة تعيين الكل';

  @override
  String get action_apply => 'يتقدم';

  @override
  String get by_category => 'حسب الفئة';

  @override
  String get by_wallet => 'بالمحفظة';

  @override
  String get by_customer => 'حسب العميل';

  @override
  String get by_supplier => 'حسب المورد';

  @override
  String get by_date => 'حسب التاريخ';

  @override
  String get show_all => 'إظهار الكل';

  @override
  String get start_date => 'تاريخ البدء';

  @override
  String get end_date => 'تاريخ الانتهاء';

  @override
  String get hint_tap_first_column => 'انقر على العناصر في العمود الأول لرؤية التفاصيل';

  @override
  String get by_status => 'حسب الحالة';

  @override
  String get status_paid => 'مدفوع';

  @override
  String get status_unpaid => 'غير مدفوع الأجر';

  @override
  String get action_yes => 'نعم';

  @override
  String get action_no => 'لا';

  @override
  String get buy_subscription_to_add_more_entity => 'بدون الاشتراك، يمكنك إضافة %s كيان فقط. ارتقِ إلى الإصدار المميز واحصل على وصول غير محدود!';

  @override
  String get sort_by_date => 'فرز حسب التاريخ';

  @override
  String get newest_to_oldest => 'الأحدث أولاً';

  @override
  String get oldest_to_newest => 'الأقدم أولاً';

  @override
  String get sort_by_name => 'فرز حسب الاسم';

  @override
  String get sort_by_barcode => 'فرز حسب الباركود';

  @override
  String get sort_by_quantity => 'فرز حسب الكمية';

  @override
  String get action_create_payment => 'إنشاء الدفع';

  @override
  String get action_view_payments => 'عرض المدفوعات المرتبطة';

  @override
  String get action_back => 'خلف';

  @override
  String get select_payment_type => 'حدد نوع الدفع';

  @override
  String get notification_low_stock_alert_title => 'تنبيه انخفاض المخزون';

  @override
  String get notification_low_stock_alert_message => 'بعض المنتجات متوفرة بكميات قليلة. يُرجى مراجعتها.';

  @override
  String get text_cancel => 'يلغي';

  @override
  String get scan_bar_code_title => 'مسح الرمز الشريطي';

  @override
  String get enter_pin_to_unlock => 'أدخل رقم التعريف الشخصي (PIN) لفتح القفل';

  @override
  String get notification_permission => 'إذن الإشعار';

  @override
  String get notification_permission_content => 'يرجى تفعيل الإشعارات في إعدادات النظام.';

  @override
  String get open_settings => 'افتح الإعدادات';

  @override
  String get notification_permission_required_message => 'مطلوب إذن الإشعار لتمكين التنبيهات.';

  @override
  String get company_info_message => 'سيتم عرض هذه البيانات في شكل مطبوع (الفواتير، المبيعات، الإيصالات، الخ...)';

  @override
  String get theme => 'المواضيع';

  @override
  String get app_theme => 'موضوع التطبيق';

  @override
  String get documents_colors => 'ألوان المستندات';

  @override
  String get choose_theme => 'اختر الموضوع';

  @override
  String get theme_system => 'نظام';

  @override
  String get theme_light => 'ضوء';

  @override
  String get theme_dark => 'مظلم';
}
