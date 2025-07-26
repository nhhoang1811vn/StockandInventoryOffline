// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get home_title => 'Дом';

  @override
  String get goods_title => 'Товары';

  @override
  String get goods_select_title => 'Выберите хороший';

  @override
  String get expenses_title => 'Затраты';

  @override
  String get empty_goods => 'Нет товаров';

  @override
  String get good => 'Хороший';

  @override
  String get folder => 'Группа';

  @override
  String get save_goods_title => 'Сохранить Хорошо';

  @override
  String get documents_title => 'Документы';

  @override
  String get save_expense_title => 'Экономьте расходы';

  @override
  String get empty_expense => 'Никаких расходов';

  @override
  String get empty_document => 'Нет документов';

  @override
  String get empty_incoming_document => 'Нет входящего документа';

  @override
  String get empty_outgoing_document => 'Нет исходящего документа';

  @override
  String get document_list_tab_all => 'Все';

  @override
  String get incoming_document_text => 'Входящий';

  @override
  String get outgoing_document_text => 'Исходящий';

  @override
  String get select_document_type => 'Выберите тип документа';

  @override
  String get document_information => 'Информация о документе';

  @override
  String get goods_information => 'Информация о товаре';

  @override
  String get save_document_batch_scan => 'Пакетное сканирование';

  @override
  String get save_document_sort_by => 'Сортировать по';

  @override
  String get save_document_help => 'Помощь';

  @override
  String get more_title => 'Более';

  @override
  String get stores_title => 'Магазины';

  @override
  String get stores_description => 'Информация о магазинах';

  @override
  String get stores_select_title => 'Выберите магазин';

  @override
  String get save_store_title => 'Сохранить магазин';

  @override
  String get empty_stores => 'Нет магазина';

  @override
  String get delete_store_error => 'Это ваш единственный магазин, не могу выполнить это действие';

  @override
  String get suppliers_title => 'Поставщики';

  @override
  String get suppliers_select_title => 'Выберите поставщика';

  @override
  String get save_supplier_title => 'Сохранить поставщика';

  @override
  String get empty_suppliers => 'Нет поставщика';

  @override
  String get customers_title => 'Клиенты';

  @override
  String get customers_select_title => 'Выберите клиента';

  @override
  String get save_customer_title => 'Сохранить клиента';

  @override
  String get empty_customers => 'Нет клиентов';

  @override
  String get save_group_title => 'Сохранить группу';

  @override
  String get field_name => 'Имя';

  @override
  String get error_field_name_empty => 'Пожалуйста, убедитесь, что введенное имя является действительным.';

  @override
  String get field_bar_code => 'Штрихкод';

  @override
  String get field_quantity => 'Количество';

  @override
  String get field_quantity_short_form => 'Куан';

  @override
  String get field_min_quantity => 'Минимальное количество';

  @override
  String get field_min_quantity_short_form => 'Мин.';

  @override
  String get field_total_short_form => 'Общий';

  @override
  String get field_supplier => 'Поставщик';

  @override
  String get field_customer => 'Клиент';

  @override
  String get field_date => 'Дата';

  @override
  String get field_date_time => 'Дата и время';

  @override
  String get field_amount => 'Количество';

  @override
  String get field_paid => 'Оплаченный';

  @override
  String get field_remaining => 'Оставаться';

  @override
  String get field_images => 'Изображения';

  @override
  String get field_document_type => 'Тип';

  @override
  String get field_person_name => 'Клиент/Поставщик';

  @override
  String get field_total => 'Общий';

  @override
  String get field_purchase_price => 'Цена покупки';

  @override
  String get field_sale_price => 'Цена продажи';

  @override
  String get field_price => 'Цена';

  @override
  String get field_revenue => 'Доход';

  @override
  String get field_document_no => 'Номер документа';

  @override
  String get home_menu_item_goods => 'Товары';

  @override
  String get home_menu_item_documents => 'Документы';

  @override
  String get home_menu_item_more => 'Более';

  @override
  String get message_error_negative_quantity_save_document => 'Невозможно выполнить это действие, количество %s отрицательное';

  @override
  String get action_send_email => 'Отправить электронное письмо';

  @override
  String get action_send_sms => 'Отправить СМС';

  @override
  String get action_phone_call => 'Телефонный звонок';

  @override
  String get action_view_transaction => 'Просмотр транзакций';

  @override
  String get action_edit => 'Редактировать';

  @override
  String get action_delete => 'Удалить';

  @override
  String get action_view_document => 'Просмотреть документы';

  @override
  String get message_name_blank => 'Имя не может быть пустым';

  @override
  String get notification_dialog_title => 'Уведомление';

  @override
  String get question_push_data => 'Хотите ли вы сохранить данные на сервере?';

  @override
  String get title_store_selecting => 'Магазин выбора';

  @override
  String get message_delete_supplier_error_having_document => 'У вас есть документы, прикрепленные к поставщику, не можете выполнить это действие';

  @override
  String get message_delete_customer_error_having_document => 'У вас есть документы, прикрепленные к поставщику, не можете выполнить это действие';

  @override
  String get action_ok => 'ХОРОШО';

  @override
  String get action_cancel => 'Отмена';

  @override
  String get search_by_customer_supplier => 'По заказчику/поставщику';

  @override
  String get action_move_to_group => 'Переместить в группу';

  @override
  String get action_edit_group => 'Редактировать группу';

  @override
  String get action_add_attachment => 'Нажмите, чтобы добавить файлы';

  @override
  String get action_take_picture => 'Сделай снимок';

  @override
  String get dialog_title_sort_by => 'Сортировать по';

  @override
  String get sort_by_option_no_sort_text => 'Нет сортировки';

  @override
  String get sort_by_option_a_to_z_text => 'От А до Я';

  @override
  String get sort_by_option_z_to_a_text => 'От Я до А';

  @override
  String get sort_by_option_ascending_text => 'По возрастанию';

  @override
  String get sort_by_option_descending_text => 'По убыванию';

  @override
  String get in_stock_text => 'В наличии: %s';

  @override
  String get menu_item_invite_friend_header => 'Пригласить друзей';

  @override
  String get send_mail_invite_friend_subject => 'Приглашение через приложение';

  @override
  String get send_mail_invite_friend_content => 'Это хорошее приложение, я пользуюсь им каждый день и рекомендую его вам. Скачать для Android: https://play.google.com/store/apps/details?id=com.steam.goodmanagerflutter. Скачать для iOS: https://apps.apple.com/us/app/stock-and-inventory/id6670546293';

  @override
  String get menu_item_write_review_header => 'Написать отзыв';

  @override
  String get menu_item_write_review_description => 'Поделитесь своим отзывом со всеми';

  @override
  String get menu_item_feedback_header => 'Обратная связь';

  @override
  String get menu_item_feedback_description => 'Поделитесь своим мнением, чтобы улучшить приложение';

  @override
  String get menu_item_community_header => 'Сообщество';

  @override
  String get menu_item_community_description => 'Присоединяйтесь к нашему сообществу приложений';

  @override
  String get menu_item_donation => 'Пожертвование!';

  @override
  String get menu_item_delete_account => 'Удалить мою учетную запись';

  @override
  String get menu_item_upgrade_account => 'Обновить аккаунт';

  @override
  String get menu_item_upgrade_account_subtitle => 'Вы находитесь в гостевом режиме. Перейдите на обычную учетную запись, чтобы синхронизировать прогресс.';

  @override
  String get menu_item_sign_out => 'выход';

  @override
  String get menu_item_whats_new_header => 'Что нового';

  @override
  String get menu_item_whats_new_description => 'Какая новая информация?';

  @override
  String get on_boarding_title_1 => 'Управление магазинами';

  @override
  String get on_boarding_content_1 => 'Вы можете создать множество магазинов для управления своими товарами и отслеживания информации о них. Например: Фруктовый магазин, Овощной магазин....';

  @override
  String get on_boarding_title_2 => 'Управление товарами';

  @override
  String get on_boarding_content_2 => 'Он содержит список (каталог) всех ваших товаров, включая информацию об их количестве на складе. Например: лампочки, список дел.';

  @override
  String get on_boarding_title_3 => 'Управление документами';

  @override
  String get on_boarding_content_3 => 'Вы можете создавать входящие/исходящие документы для увеличения/уменьшения количества товара на складе.';

  @override
  String get on_boarding_title_4 => 'Начните сейчас';

  @override
  String get on_boarding_header_4 => 'Введите название вашего первого магазина';

  @override
  String get action_done => 'Сделанный';

  @override
  String get action_skip => 'Пропускать';

  @override
  String get message_confirm_delete_no_args => 'Вы уверены, что хотите его удалить?';

  @override
  String get message_confirm_delete => 'Вы уверены, что хотите удалить %s?';

  @override
  String get message_confirm_delete_account => 'Вы уверены, что хотите удалить свою учетную запись?';

  @override
  String get delete_account_successful => 'Ваш аккаунт был удален';

  @override
  String get menu_item_settings_title => 'Настройки';

  @override
  String get menu_item_settings_desc => 'Информация о настройках';

  @override
  String get menu_item_general => 'Общий';

  @override
  String get menu_item_view => 'Отображать';

  @override
  String get menu_item_barcode_scanner => 'Сканер штрих-кода';

  @override
  String get menu_item_minimum_quantity => 'Минимальное количество';

  @override
  String get menu_item_show_min_quantity_items_page_title => 'Показывать минимальное количество на странице товара';

  @override
  String get menu_item_show_min_quantity_list_page_title => 'Показать минимальное количество на странице списка';

  @override
  String get menu_item_min_quantity_color_title => 'Цвет для товаров, требующих повторного заказа';

  @override
  String get menu_item_show_low_stock_alert_title => 'Показывать оповещения о низком уровне запасов';

  @override
  String get menu_item_show_low_stock_alert_desc => 'Когда вы откроете приложение, мы отправим вам уведомление с предупреждением.';

  @override
  String get menu_item_my_company => 'Информация о компании';

  @override
  String get menu_item_backup_and_restore => 'Резервное копирование и восстановление';

  @override
  String get menu_item_language_title => 'Язык';

  @override
  String get menu_item_language_desc => 'Изменить язык';

  @override
  String get menu_item_passcode_title => 'Кодовый замок';

  @override
  String get menu_item_passcode_desc => 'Описание';

  @override
  String get menu_item_reset_numeration_documents_title => 'Сбросить нумерацию документов';

  @override
  String get settings_title => 'Настройки';

  @override
  String get subscriptions_title => 'Подписки';

  @override
  String get dialog_title_change_language => 'Выберите язык';

  @override
  String get english_text => 'Английский';

  @override
  String get vietnamese_text => 'вьетнамский';

  @override
  String get incoming_goods => 'Поступающие товары';

  @override
  String get outgoing_goods => 'Исходящие товары';

  @override
  String get report_title => 'Отчет';

  @override
  String get select_store_title => 'Выбрать магазин';

  @override
  String get select_group_title => 'Выбрать группу';

  @override
  String get select_message_type => 'Выберите тип сообщения';

  @override
  String get message_type_bug_report => 'Отчет об ошибке';

  @override
  String get message_type_feedback => 'Обратная связь';

  @override
  String get message_type_suggestion => 'Предположение';

  @override
  String get message_type_question => 'Вопрос';

  @override
  String get send_mail_bug_report_subject => 'Запасы и инвентарь — отчет об ошибках';

  @override
  String get send_mail_feedback_subject => 'Запасы и инвентарь - Обратная связь';

  @override
  String get send_mail_suggestion_subject => 'Запасы и инвентарь - Предложение';

  @override
  String get send_mail_question_subject => 'Запасы и инвентарь - Вопрос';

  @override
  String get dialog_title_data_not_save => 'Внимание!';

  @override
  String get dialog_content_data_not_save => 'Закрыть без сохранения';

  @override
  String get batch_mode_scan => 'Пакетное сканирование';

  @override
  String get after_each_scan => 'После каждого сканирования';

  @override
  String get after_each_scan_auto => 'Автоматическое увеличение количества на 1';

  @override
  String get after_each_scan_manually => 'Установить количество вручную';

  @override
  String get when_a_barcode_is_found => 'При обнаружении штрихкода';

  @override
  String get beep => 'Бип';

  @override
  String get vibrate => 'Вибрация';

  @override
  String get question_or_suggestion_title => 'Вопрос или предложение';

  @override
  String get review_the_app_title => 'Оценить приложение';

  @override
  String get help_title => 'Помощь';

  @override
  String get whats_new_title => 'Что нового';

  @override
  String get terms_of_use_title => 'Условия эксплуатации';

  @override
  String get privacy_policy_title => 'политика конфиденциальности';

  @override
  String get your_subscriptions_title => 'Ваши подписки';

  @override
  String get document_name_no => 'Нет.';

  @override
  String get insert_transaction_success => 'Элемент успешно добавлен!';

  @override
  String get insert_transaction_fail => 'Добавленный элемент не удалось!';

  @override
  String get success => 'Успех!';

  @override
  String get error => 'Ошибка!';

  @override
  String get error_same_barcode => 'Ошибка: тот же штрих-код';

  @override
  String get action_search => 'Поиск';

  @override
  String get action_sort_by => 'Сортировать по';

  @override
  String get action_export_csv => 'Экспорт CSV';

  @override
  String get action_export_pdf => 'Экспорт PDF';

  @override
  String get action_batch_scan => 'Пакетное сканирование';

  @override
  String get action_help => 'Помощь';

  @override
  String get report_type_goods => 'Список товаров';

  @override
  String get report_type_expenses => 'Затраты';

  @override
  String get report_type_list_of_documents => 'Список документов';

  @override
  String get report_type_debt_by_supplier => 'Долг Поставщика';

  @override
  String get report_type_debt_by_customer => 'Долг клиента';

  @override
  String get report_type_inbound_payments => 'Входящие платежи';

  @override
  String get report_type_outbound_payments => 'Исходящие платежи';

  @override
  String get report_type_list_of_supplier_payments => 'Платежи от поставщиков';

  @override
  String get report_type_list_of_customer_payments => 'Платежи клиентов';

  @override
  String get report_type_reorder => 'Изменить порядок';

  @override
  String get select_date_range => 'Выберите диапазон дат';

  @override
  String get report_type_current_month => 'Текущий месяц';

  @override
  String get report_type_last_30_days => 'Последние 30 дней';

  @override
  String get report_type_last_90_days => 'Последние 90 дней';

  @override
  String get report_type_current_year => 'Текущий год';

  @override
  String get report_type_custom => 'Обычай';

  @override
  String get report_detail_period_time => 'От %s до %s';

  @override
  String get report_detail_store => 'Магазин %s';

  @override
  String get select_payment_status => 'Выберите статус платежа';

  @override
  String get payment_status_unpaid => 'Неоплаченный';

  @override
  String get payment_status_partial => 'Частичный';

  @override
  String get payment_status_paid => 'Оплаченный';

  @override
  String get payments_title => 'Платежи';

  @override
  String get payment_invoiced => 'Выставлен счет';

  @override
  String get payment_due_pending => 'Ожидается/ожидается';

  @override
  String get payment_paid => 'Оплаченный';

  @override
  String get empty_payment => 'Нет оплаты';

  @override
  String get title_outbound_payment => 'Исходящий';

  @override
  String get title_inbound_payment => 'Входящий';

  @override
  String get save_outbound_payment_title => 'Сохранить исходящий платеж';

  @override
  String get save_inbound_payment_title => 'Сохранить входящий платеж';

  @override
  String get menu_back_up => 'Резервное копирование данных';

  @override
  String get menu_back_up_desc => 'Экспорт файла базы данных на телефон';

  @override
  String get menu_restore => 'Восстановить данные';

  @override
  String get menu_restore_desc => 'Импорт файла базы данных';

  @override
  String get backup_successful => 'Резервное копирование данных успешно завершено';

  @override
  String get backup_error => 'Резервное копирование данных не удалось!!';

  @override
  String get error_wrong_email_password => 'Неправильный адрес электронной почты или пароль, попробуйте еще раз.';

  @override
  String get menu_push_data_to_cloud => 'Сохраните данные в облаке';

  @override
  String get menu_quick_sync_title => 'Быстрая синхронизация';

  @override
  String get menu_quick_sync_desc => 'Приложение перезапустится и синхронизируется с последними данными.';

  @override
  String get login => 'АВТОРИЗОВАТЬСЯ';

  @override
  String get email => 'Электронная почта';

  @override
  String get error_email => 'Пожалуйста, введите действительный адрес электронной почты';

  @override
  String get password => 'Пароль';

  @override
  String get error_password => 'Пожалуйста, введите действительный пароль';

  @override
  String get forgot_your_password => 'Забыли пароль ?';

  @override
  String get or_sign_in_with => 'или Войти через';

  @override
  String get dont_have_an_account_yet => 'У вас еще нет учетной записи?';

  @override
  String get sign_up_text => 'Зарегистрироваться';

  @override
  String get sign_up => 'ЗАРЕГИСТРИРОВАТЬСЯ';

  @override
  String get name => 'Имя';

  @override
  String get reset_password => 'СБРОС ПАРОЛЯ';

  @override
  String get email_not_verified_title => 'Электронная почта не подтверждена';

  @override
  String get email_not_verified_desc => 'Пожалуйста, проверьте свою электронную почту и подтвердите ее.';

  @override
  String get sign_up_successful => 'Успешная регистрация';

  @override
  String get reset_password_successful => 'Сброс пароля Успешно';

  @override
  String get cloud_file_no_updated => 'Пока не обновлено';

  @override
  String get signout_message => 'Вы уверены, что хотите выйти?';

  @override
  String get item_history_title => 'История предмета';

  @override
  String get list_settings => 'Настройки списка';

  @override
  String get good_settings_hide_zero_entries => 'Скрыть ноль записей';

  @override
  String get good_setting_show_bar_code => 'Показать штрих-код';

  @override
  String get good_setting_show_description => 'Показать описание';

  @override
  String get version => 'Версия: %s';

  @override
  String get change_tracking_store => 'Магазин отслеживания изменений';

  @override
  String get loading_data => 'Загрузка данных...';

  @override
  String get title_good_count => 'Количество предметов';

  @override
  String get title_total_quantity => 'Общее количество';

  @override
  String get title_select_document => 'Выбрать документ';

  @override
  String get title_chart_sale_report => 'Отчет о продажах за последние 6 месяцев';

  @override
  String get label_select_payment_category => 'Выберите категорию';

  @override
  String get label_select_wallet => 'Выбрать кошелек';

  @override
  String get label_select_object => 'Выбрать объект';

  @override
  String get label_select_outbound_object => 'Выбрать исходящий объект';

  @override
  String get label_select_inbound_object => 'Выберите входящий объект';

  @override
  String get label_description => 'Описание';

  @override
  String get hint_description => 'Описание ввода';

  @override
  String get label_select_document_no => 'Номер документа';

  @override
  String get label_supplier_name => 'Имя поставщика';

  @override
  String get label_customer_name => 'Имя клиента';

  @override
  String get label_group_name => 'Название группы';

  @override
  String get label_good_name => 'Доброе имя';

  @override
  String get label_category_name => 'Название категории';

  @override
  String get label_wallet_name => 'Имя кошелька';

  @override
  String get hint_name => 'Введите имя';

  @override
  String get label_address => 'Адрес';

  @override
  String get hint_address => 'Входной адрес';

  @override
  String get label_email => 'Электронная почта';

  @override
  String get hint_email => 'Введите адрес электронной почты';

  @override
  String get label_phone_number => 'Номер телефона';

  @override
  String get hint_phone_number => 'Введите номер телефона';

  @override
  String get label_tax_id => 'Налоговый идентификатор';

  @override
  String get hint_tax_id => 'Идентификатор входящего налога';

  @override
  String get label_bank_details => 'Банковские реквизиты';

  @override
  String get hint_bank_details => 'Введите банковские реквизиты';

  @override
  String get label_bar_code => 'Штрихкод';

  @override
  String get hint_bar_code => 'Введите штрих-код';

  @override
  String get action_save => 'Сохранять';

  @override
  String get hint_select => 'Выбирать';

  @override
  String get action_add_payment_category => 'Добавить категорию';

  @override
  String get title_pick_color => 'Выберите цвет';

  @override
  String get action_add_group => 'Добавить группу';

  @override
  String get action_add_good => 'Добавить хорошо';

  @override
  String get no_category => 'Нет категории';

  @override
  String get field_start_period => 'Начальный период';

  @override
  String get field_in => 'В';

  @override
  String get field_out => 'Вне';

  @override
  String get field_end_period => 'Конечный период';

  @override
  String get action_document_created_withname => 'Документ %s был создан';

  @override
  String get good_information => 'Хорошая информация';

  @override
  String get images_information => 'Информация об изображениях';

  @override
  String get change_color => 'Изменить цвет';

  @override
  String get change_icon => 'Изменить значок';

  @override
  String get save_file_successful => 'Файл успешно сохранен в %s';

  @override
  String get save_file_failed => 'Сохранение файла не удалось в %s';

  @override
  String get no_group => 'Нет группы';

  @override
  String get save_wallet_title => 'Сохранить кошелек';

  @override
  String get action_add_wallet => 'Добавить кошелек';

  @override
  String get total_balance => 'Общий баланс';

  @override
  String get title_wallet => 'Кошельки';

  @override
  String get categories => 'Категории';

  @override
  String get title_save_category => 'Сохранить категорию';

  @override
  String get inbound_categories => 'Входящие категории';

  @override
  String get outbound_categories => 'Исходящие категории';

  @override
  String get select_object_type => 'Выберите типы объектов';

  @override
  String get pro_benefits_description => 'Все премиум-функции приложения (неограниченное количество магазинов, клиентов, поставщиков, кошельков)';

  @override
  String get pro_lifetime_benefits_description => 'При единовременной покупке вы сможете пользоваться всеми расширенными функциями навсегда.';

  @override
  String get monthly => 'Ежемесячно';

  @override
  String get yearly => 'Ежегодно';

  @override
  String get payonce => 'Платите один раз, пользуйтесь вечно';

  @override
  String get title_report_list_of_wallet => 'Список кошельков';

  @override
  String get hint_search_by => 'Поиск...';

  @override
  String get field_my_company_name => 'Название компании';

  @override
  String get field_reorder => 'Изменить порядок';

  @override
  String get title_filter => 'Фильтр';

  @override
  String get action_reset_all => 'Сбросить все';

  @override
  String get action_apply => 'Применять';

  @override
  String get by_category => 'По категориям';

  @override
  String get by_wallet => 'По кошельку';

  @override
  String get by_customer => 'Клиентом';

  @override
  String get by_supplier => 'Поставщиком';

  @override
  String get by_date => 'По дате';

  @override
  String get show_all => 'Показать все';

  @override
  String get start_date => 'Дата начала';

  @override
  String get end_date => 'Дата окончания';

  @override
  String get hint_tap_first_column => 'Нажмите на элементы в первом столбце, чтобы увидеть подробности.';

  @override
  String get by_status => 'По статусу';

  @override
  String get status_paid => 'Оплаченный';

  @override
  String get status_unpaid => 'Неоплаченный';

  @override
  String get action_yes => 'Да';

  @override
  String get action_no => 'Нет';

  @override
  String get buy_subscription_to_add_more_entity => 'Без подписки вы сможете добавить только %s сущностей. Перейдите на премиум-версию и получите неограниченный доступ!';

  @override
  String get sort_by_date => 'Сортировать по дате';

  @override
  String get newest_to_oldest => 'Сначала самые новые';

  @override
  String get oldest_to_newest => 'Сначала самые старые';

  @override
  String get sort_by_name => 'Сортировать по имени';

  @override
  String get sort_by_barcode => 'Сортировать по штрихкоду';

  @override
  String get sort_by_quantity => 'Сортировать по количеству';

  @override
  String get action_create_payment => 'Создать платеж';

  @override
  String get action_view_payments => 'Просмотреть связанные платежи';

  @override
  String get action_back => 'Назад';

  @override
  String get select_payment_type => 'Выберите тип оплаты';

  @override
  String get notification_low_stock_alert_title => 'Оповещение о низком уровне запасов';

  @override
  String get notification_low_stock_alert_message => 'Некоторых товаров мало на складе. Пожалуйста, проверьте наличие.';

  @override
  String get text_cancel => 'Отмена';

  @override
  String get scan_bar_code_title => 'Сканировать штрих-код';

  @override
  String get enter_pin_to_unlock => 'Введите PIN-код для разблокировки';

  @override
  String get notification_permission => 'Разрешение на уведомление';

  @override
  String get notification_permission_content => 'Пожалуйста, включите уведомления в настройках системы.';

  @override
  String get open_settings => 'Открыть настройки';

  @override
  String get notification_permission_required_message => 'Для включения оповещений требуется разрешение на отправку уведомлений.';

  @override
  String get company_info_message => 'Эти данные будут отображаться в печатном виде (счета-фактуры, продажи, квитанции и т. д.).';

  @override
  String get theme => 'Темы';

  @override
  String get app_theme => 'Тема приложения';

  @override
  String get documents_colors => 'Цвета документов';

  @override
  String get choose_theme => 'Выберите тему';

  @override
  String get theme_system => 'Система';

  @override
  String get theme_light => 'Свет';

  @override
  String get theme_dark => 'Темный';
}
