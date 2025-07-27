// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get home_title => '家';

  @override
  String get goods_title => '品';

  @override
  String get goods_select_title => '良いものを選ぶ';

  @override
  String get expenses_title => '経費';

  @override
  String get empty_goods => '商品なし';

  @override
  String get good => '良い';

  @override
  String get folder => 'グループ';

  @override
  String get save_goods_title => '良いものを保存する';

  @override
  String get documents_title => '文書';

  @override
  String get save_expense_title => '経費を節約';

  @override
  String get empty_expense => '費用はかかりません';

  @override
  String get empty_document => '書類なし';

  @override
  String get empty_incoming_document => '受信文書はありません';

  @override
  String get empty_outgoing_document => '送信文書はありません';

  @override
  String get document_list_tab_all => '全て';

  @override
  String get incoming_document_text => '着信';

  @override
  String get outgoing_document_text => '発信';

  @override
  String get select_document_type => 'ドキュメントの種類を選択';

  @override
  String get document_information => '文書情報';

  @override
  String get goods_information => '商品情報';

  @override
  String get save_document_batch_scan => 'バッチスキャン';

  @override
  String get save_document_sort_by => '並べ替え';

  @override
  String get save_document_help => 'ヘルプ';

  @override
  String get more_title => 'もっと';

  @override
  String get stores_title => '店舗';

  @override
  String get stores_description => '店舗情報';

  @override
  String get stores_select_title => '店舗を選択';

  @override
  String get save_store_title => '保存ストア';

  @override
  String get empty_stores => '店舗なし';

  @override
  String get delete_store_error => 'これはあなたの唯一のストアです。このアクションは実行できません';

  @override
  String get suppliers_title => 'サプライヤー';

  @override
  String get suppliers_select_title => 'サプライヤーを選択';

  @override
  String get save_supplier_title => 'サプライヤーを保存';

  @override
  String get empty_suppliers => 'サプライヤーなし';

  @override
  String get customers_title => '顧客';

  @override
  String get customers_select_title => '顧客を選択';

  @override
  String get save_customer_title => '顧客を保存';

  @override
  String get empty_customers => '顧客なし';

  @override
  String get save_group_title => 'グループを保存';

  @override
  String get field_name => '名前';

  @override
  String get error_field_name_empty => '入力した名前が有効であることを確認してください';

  @override
  String get field_bar_code => 'バーコード';

  @override
  String get field_quantity => '量';

  @override
  String get field_quantity_short_form => 'クアン';

  @override
  String get field_min_quantity => '最小数量';

  @override
  String get field_min_quantity_short_form => '分。';

  @override
  String get field_total_short_form => '合計';

  @override
  String get field_supplier => 'サプライヤー';

  @override
  String get field_customer => 'お客様';

  @override
  String get field_date => '日付';

  @override
  String get field_date_time => '日付と時刻';

  @override
  String get field_amount => '額';

  @override
  String get field_paid => '有料';

  @override
  String get field_remaining => '残る';

  @override
  String get field_images => '画像';

  @override
  String get field_document_type => 'タイプ';

  @override
  String get field_person_name => '顧客/サプライヤー';

  @override
  String get field_total => '合計';

  @override
  String get field_purchase_price => '購入価格';

  @override
  String get field_sale_price => '販売価格';

  @override
  String get field_price => '価格';

  @override
  String get field_revenue => '収益';

  @override
  String get field_document_no => '文書番号';

  @override
  String get home_menu_item_goods => '品';

  @override
  String get home_menu_item_documents => '文書';

  @override
  String get home_menu_item_more => 'もっと';

  @override
  String get message_error_negative_quantity_save_document =>
      'このアクションを実行できません。%s の数量が負です';

  @override
  String get action_send_email => 'メールを送信';

  @override
  String get action_send_sms => 'SMSを送信';

  @override
  String get action_phone_call => '電話';

  @override
  String get action_view_transaction => '取引を表示';

  @override
  String get action_edit => '編集';

  @override
  String get action_delete => '消去';

  @override
  String get action_view_document => 'ドキュメントを表示';

  @override
  String get message_name_blank => '名前は空欄にできません';

  @override
  String get notification_dialog_title => '通知';

  @override
  String get question_push_data => 'データをサーバーに保存しますか?';

  @override
  String get title_store_selecting => 'セレクションストア';

  @override
  String get message_delete_supplier_error_having_document =>
      'サプライヤーに文書が添付されているため、このアクションを実行できません';

  @override
  String get message_delete_customer_error_having_document =>
      'サプライヤーに文書が添付されているため、このアクションを実行できません';

  @override
  String get action_ok => 'わかりました';

  @override
  String get action_cancel => 'キャンセル';

  @override
  String get search_by_customer_supplier => '顧客/サプライヤー別';

  @override
  String get action_move_to_group => 'グループに移動';

  @override
  String get action_edit_group => 'グループを編集';

  @override
  String get action_add_attachment => 'タップしてファイルを追加';

  @override
  String get action_take_picture => '写真を撮る';

  @override
  String get dialog_title_sort_by => '並べ替え';

  @override
  String get sort_by_option_no_sort_text => '並べ替えなし';

  @override
  String get sort_by_option_a_to_z_text => 'AからZまで';

  @override
  String get sort_by_option_z_to_a_text => 'ZからA';

  @override
  String get sort_by_option_ascending_text => '上昇';

  @override
  String get sort_by_option_descending_text => '降順';

  @override
  String get in_stock_text => '在庫あり: %s';

  @override
  String get menu_item_invite_friend_header => '友達を招待する';

  @override
  String get send_mail_invite_friend_subject => 'アプリを使った招待';

  @override
  String get send_mail_invite_friend_content =>
      'これは良いアプリです。毎日使っていますし、皆さんにもお勧めします。Android版のダウンロード：https://play.google.com/store/apps/details?id=com.steam.goodmanagerflutter。iOS版のダウンロード：https://apps.apple.com/us/app/stock-and-inventory/id6670546293';

  @override
  String get menu_item_write_review_header => 'レビューを書く';

  @override
  String get menu_item_write_review_description => 'あなたのレビューをみんなにシェアしましょう';

  @override
  String get menu_item_feedback_header => 'フィードバック';

  @override
  String get menu_item_feedback_description => 'アプリを改善するためにフィードバックを共有してください';

  @override
  String get menu_item_community_header => 'コミュニティ';

  @override
  String get menu_item_community_description => 'アプリコミュニティに参加する';

  @override
  String get menu_item_donation => '寄付！';

  @override
  String get menu_item_delete_account => 'アカウントを削除する';

  @override
  String get menu_item_upgrade_account => 'アカウントをアップグレード';

  @override
  String get menu_item_upgrade_account_subtitle =>
      'ゲストモードになっています。進行状況を同期するには、通常のアカウントにアップグレードしてください。';

  @override
  String get menu_item_sign_out => 'サインアウト';

  @override
  String get menu_item_whats_new_header => '新着情報';

  @override
  String get menu_item_whats_new_description => '最新情報';

  @override
  String get on_boarding_title_1 => '店舗管理';

  @override
  String get on_boarding_content_1 =>
      '商品を管理し、その情報を追跡するために、多数のストアを作成できます。例: 果物店、野菜店...';

  @override
  String get on_boarding_title_2 => '商品管理';

  @override
  String get on_boarding_content_2 =>
      '在庫数量の情報を含むすべての商品のリスト（カタログ）が含まれています。例：電球、todo';

  @override
  String get on_boarding_title_3 => 'ドキュメント管理';

  @override
  String get on_boarding_content_3 => '入庫/出庫伝票を作成して、在庫の商品数量を増減することができます。';

  @override
  String get on_boarding_title_4 => '今すぐ始める';

  @override
  String get on_boarding_header_4 => '最初の店舗名を入力してください';

  @override
  String get action_done => '終わり';

  @override
  String get action_skip => 'スキップ';

  @override
  String get message_confirm_delete_no_args => '本当に削除しますか?';

  @override
  String get message_confirm_delete => '%s を削除してもよろしいですか?';

  @override
  String get message_confirm_delete_account => 'アカウントを削除してもよろしいですか?';

  @override
  String get delete_account_successful => 'アカウントは削除されました';

  @override
  String get menu_item_settings_title => '設定';

  @override
  String get menu_item_settings_desc => '設定情報';

  @override
  String get menu_item_general => '一般的な';

  @override
  String get menu_item_view => '画面';

  @override
  String get menu_item_barcode_scanner => 'バーコードスキャナー';

  @override
  String get menu_item_minimum_quantity => '最小数量';

  @override
  String get menu_item_show_min_quantity_items_page_title => '商品ページに最小数量を表示する';

  @override
  String get menu_item_show_min_quantity_list_page_title => 'リストページに最小数量を表示する';

  @override
  String get menu_item_min_quantity_color_title => '再注文が必要な商品の色';

  @override
  String get menu_item_show_low_stock_alert_title => '在庫不足アラートを表示';

  @override
  String get menu_item_show_low_stock_alert_desc => 'アプリを開くと、警告の通知が送信されます';

  @override
  String get menu_item_my_company => '会社情報';

  @override
  String get menu_item_backup_and_restore => 'バックアップと復元';

  @override
  String get menu_item_language_title => '言語';

  @override
  String get menu_item_language_desc => '言語を変更';

  @override
  String get menu_item_passcode_title => 'パスコードロック';

  @override
  String get menu_item_passcode_desc => '説明';

  @override
  String get menu_item_reset_numeration_documents_title => '文書の番号をリセットする';

  @override
  String get settings_title => '設定';

  @override
  String get subscriptions_title => 'サブスクリプション';

  @override
  String get dialog_title_change_language => '言語を選択';

  @override
  String get english_text => '英語';

  @override
  String get vietnamese_text => 'ベトナム語';

  @override
  String get incoming_goods => '入荷品';

  @override
  String get outgoing_goods => '出荷品';

  @override
  String get report_title => '報告';

  @override
  String get select_store_title => '店舗を選択';

  @override
  String get select_group_title => 'グループを選択';

  @override
  String get select_message_type => 'メッセージの種類を選択';

  @override
  String get message_type_bug_report => 'バグレポート';

  @override
  String get message_type_feedback => 'フィードバック';

  @override
  String get message_type_suggestion => '提案';

  @override
  String get message_type_question => '質問';

  @override
  String get send_mail_bug_report_subject => '在庫と在庫 - バグレポート';

  @override
  String get send_mail_feedback_subject => '在庫と在庫 - フィードバック';

  @override
  String get send_mail_suggestion_subject => '在庫と在庫 - 提案';

  @override
  String get send_mail_question_subject => '在庫と在庫品 - 質問';

  @override
  String get dialog_title_data_not_save => '注意！';

  @override
  String get dialog_content_data_not_save => '保存せずに閉じる';

  @override
  String get batch_mode_scan => 'バッチモードスキャン';

  @override
  String get after_each_scan => '各スキャン後';

  @override
  String get after_each_scan_auto => '数量を1ずつ自動増加';

  @override
  String get after_each_scan_manually => '数量を手動で設定';

  @override
  String get when_a_barcode_is_found => 'バーコードが見つかったとき';

  @override
  String get beep => 'ビープ';

  @override
  String get vibrate => '振動';

  @override
  String get question_or_suggestion_title => '質問または提案';

  @override
  String get review_the_app_title => 'アプリをレビューする';

  @override
  String get help_title => 'ヘルプ';

  @override
  String get whats_new_title => '新着情報';

  @override
  String get terms_of_use_title => '利用規約';

  @override
  String get privacy_policy_title => 'プライバシーポリシー';

  @override
  String get your_subscriptions_title => 'あなたの購読';

  @override
  String get document_name_no => 'いいえ。';

  @override
  String get insert_transaction_success => 'アイテムの追加に成功しました!';

  @override
  String get insert_transaction_fail => 'アイテムの追加に失敗しました。';

  @override
  String get success => '成功！';

  @override
  String get error => 'エラー！';

  @override
  String get error_same_barcode => 'エラー: 同じバーコード';

  @override
  String get action_search => '検索';

  @override
  String get action_sort_by => '並べ替え';

  @override
  String get action_export_csv => 'CSVエクスポート';

  @override
  String get action_export_pdf => 'PDFをエクスポート';

  @override
  String get action_batch_scan => 'バッチスキャン';

  @override
  String get action_help => 'ヘルプ';

  @override
  String get report_type_goods => '商品リスト';

  @override
  String get report_type_expenses => '経費';

  @override
  String get report_type_list_of_documents => '文書リスト';

  @override
  String get report_type_debt_by_supplier => 'サプライヤーの負債';

  @override
  String get report_type_debt_by_customer => '顧客の債務';

  @override
  String get report_type_inbound_payments => '入金';

  @override
  String get report_type_outbound_payments => '送金';

  @override
  String get report_type_list_of_supplier_payments => 'サプライヤーによる支払い';

  @override
  String get report_type_list_of_customer_payments => '顧客による支払い';

  @override
  String get report_type_reorder => '再注文';

  @override
  String get select_date_range => '日付範囲を選択';

  @override
  String get report_type_current_month => '現在の月';

  @override
  String get report_type_last_30_days => '過去30日間';

  @override
  String get report_type_last_90_days => '過去90日間';

  @override
  String get report_type_current_year => '今年';

  @override
  String get report_type_custom => 'カスタム';

  @override
  String get report_detail_period_time => '%sから%sまで';

  @override
  String get report_detail_store => 'ストア %s';

  @override
  String get select_payment_status => '支払いステータスを選択';

  @override
  String get payment_status_unpaid => '未払い';

  @override
  String get payment_status_partial => '部分的';

  @override
  String get payment_status_paid => '有料';

  @override
  String get payments_title => '支払い';

  @override
  String get payment_invoiced => '請求書発行済み';

  @override
  String get payment_due_pending => '期限/保留中';

  @override
  String get payment_paid => '有料';

  @override
  String get empty_payment => '支払いなし';

  @override
  String get title_outbound_payment => 'アウトバウンド';

  @override
  String get title_inbound_payment => 'インバウンド';

  @override
  String get save_outbound_payment_title => '送金支払いを節約';

  @override
  String get save_inbound_payment_title => '入金を節約';

  @override
  String get menu_back_up => 'データのバックアップ';

  @override
  String get menu_back_up_desc => 'データベースファイルを携帯電話にエクスポートする';

  @override
  String get menu_restore => 'データを復元する';

  @override
  String get menu_restore_desc => 'データベースファイルをインポートする';

  @override
  String get backup_successful => 'データのバックアップに成功しました';

  @override
  String get backup_error => 'データのバックアップに失敗しました!!';

  @override
  String get error_wrong_email_password =>
      'メールアドレスまたはパスワードが間違っています。もう一度お試しください。';

  @override
  String get menu_push_data_to_cloud => 'データをクラウドに保存する';

  @override
  String get menu_quick_sync_title => 'クイック同期';

  @override
  String get menu_quick_sync_desc => 'アプリを再起動し、最新のアプリデータを同期します';

  @override
  String get login => 'ログイン';

  @override
  String get email => 'メール';

  @override
  String get error_email => '有効なメールアドレスを入力してください';

  @override
  String get password => 'パスワード';

  @override
  String get error_password => '有効なパスワードを入力してください';

  @override
  String get forgot_your_password => 'パスワードをお忘れですか ？';

  @override
  String get or_sign_in_with => 'またはサインイン';

  @override
  String get dont_have_an_account_yet => 'まだアカウントをお持ちではありませんか?';

  @override
  String get sign_up_text => 'サインアップ';

  @override
  String get sign_up => 'サインアップ';

  @override
  String get name => '名前';

  @override
  String get reset_password => 'パスワードをリセット';

  @override
  String get email_not_verified_title => 'メールが確認されていません';

  @override
  String get email_not_verified_desc => 'メールを確認してメールを確認してください。';

  @override
  String get sign_up_successful => 'サインアップ成功';

  @override
  String get reset_password_successful => 'パスワードのリセット成功';

  @override
  String get cloud_file_no_updated => 'まだ更新されていません';

  @override
  String get signout_message => '本当にログアウトしますか?';

  @override
  String get item_history_title => 'アイテム履歴';

  @override
  String get list_settings => 'リスト設定';

  @override
  String get good_settings_hide_zero_entries => 'ゼロエントリを非表示';

  @override
  String get good_setting_show_bar_code => 'バーコードを表示';

  @override
  String get good_setting_show_description => '説明を表示';

  @override
  String get version => 'バージョン: %s';

  @override
  String get change_tracking_store => '変更追跡ストア';

  @override
  String get loading_data => 'データを読み込んでいます...';

  @override
  String get title_good_count => 'アイテム数';

  @override
  String get title_total_quantity => '合計数量';

  @override
  String get title_select_document => 'ドキュメントを選択';

  @override
  String get title_chart_sale_report => '過去6か月間の販売レポート';

  @override
  String get label_select_payment_category => 'カテゴリーを選択';

  @override
  String get label_select_wallet => 'ウォレットを選択';

  @override
  String get label_select_object => 'オブジェクトを選択';

  @override
  String get label_select_outbound_object => '送信オブジェクトを選択';

  @override
  String get label_select_inbound_object => '受信オブジェクトを選択';

  @override
  String get label_description => '説明';

  @override
  String get hint_description => '入力説明';

  @override
  String get label_select_document_no => '文書番号';

  @override
  String get label_supplier_name => 'サプライヤー名';

  @override
  String get label_customer_name => '顧客名';

  @override
  String get label_group_name => 'グループ名';

  @override
  String get label_good_name => '良い名前';

  @override
  String get label_category_name => 'カテゴリ名';

  @override
  String get label_wallet_name => 'ウォレット名';

  @override
  String get hint_name => '名前を入力';

  @override
  String get label_address => '住所';

  @override
  String get hint_address => '入力アドレス';

  @override
  String get label_email => 'メール';

  @override
  String get hint_email => 'メールアドレスを入力';

  @override
  String get label_phone_number => '電話番号';

  @override
  String get hint_phone_number => '電話番号を入力してください';

  @override
  String get label_tax_id => '納税者番号';

  @override
  String get hint_tax_id => '入力税ID';

  @override
  String get label_bank_details => '銀行口座情報';

  @override
  String get hint_bank_details => '銀行の詳細を入力してください';

  @override
  String get label_bar_code => 'バーコード';

  @override
  String get hint_bar_code => 'バーコード入力';

  @override
  String get action_save => '保存';

  @override
  String get hint_select => '選択';

  @override
  String get action_add_payment_category => 'カテゴリを追加';

  @override
  String get title_pick_color => '色を選択';

  @override
  String get action_add_group => 'グループを追加';

  @override
  String get action_add_good => '良いものを追加';

  @override
  String get no_category => 'カテゴリーなし';

  @override
  String get field_start_period => '開始期間';

  @override
  String get field_in => 'で';

  @override
  String get field_out => '外';

  @override
  String get field_end_period => '終了期間';

  @override
  String get action_document_created_withname => 'ドキュメント %s が作成されました';

  @override
  String get good_information => '良い情報';

  @override
  String get images_information => '画像情報';

  @override
  String get change_color => '色を変える';

  @override
  String get change_icon => 'アイコンを変更';

  @override
  String get save_file_successful => '%s でファイルの保存に成功しました';

  @override
  String get save_file_failed => '%s でファイルの保存に失敗しました';

  @override
  String get no_group => 'グループなし';

  @override
  String get save_wallet_title => 'ウォレットを保存';

  @override
  String get action_add_wallet => 'ウォレットを追加';

  @override
  String get total_balance => '合計残高';

  @override
  String get title_wallet => 'ウォレット';

  @override
  String get categories => 'カテゴリー';

  @override
  String get title_save_category => 'カテゴリを保存';

  @override
  String get inbound_categories => 'インバウンドカテゴリー';

  @override
  String get outbound_categories => 'アウトバウンドカテゴリー';

  @override
  String get select_object_type => 'オブジェクトの種類を選択';

  @override
  String get pro_benefits_description =>
      'アプリのすべてのプレミアム機能（無制限のストア、顧客、サプライヤー、ウォレット）';

  @override
  String get pro_lifetime_benefits_description =>
      '一度購入すれば、すべての高度な機能を永久に利用できるようになります';

  @override
  String get monthly => '月次';

  @override
  String get yearly => '年間';

  @override
  String get payonce => '一度支払えば永久に使用可能';

  @override
  String get title_report_list_of_wallet => 'ウォレットのリスト';

  @override
  String get hint_search_by => '検索...';

  @override
  String get field_my_company_name => '会社名';

  @override
  String get field_reorder => '再注文';

  @override
  String get title_filter => 'フィルター';

  @override
  String get action_reset_all => 'すべてリセット';

  @override
  String get action_apply => '適用する';

  @override
  String get by_category => 'カテゴリー別';

  @override
  String get by_wallet => 'ウォレット別';

  @override
  String get by_customer => '顧客別';

  @override
  String get by_supplier => 'サプライヤー別';

  @override
  String get by_date => '日付順';

  @override
  String get show_all => 'すべて表示';

  @override
  String get start_date => '開始日';

  @override
  String get end_date => '終了日';

  @override
  String get hint_tap_first_column => '最初の列の項目をタップすると詳細が表示されます';

  @override
  String get by_status => 'ステータス別';

  @override
  String get status_paid => '有料';

  @override
  String get status_unpaid => '未払い';

  @override
  String get action_yes => 'はい';

  @override
  String get action_no => 'いいえ';

  @override
  String get buy_subscription_to_add_more_entity =>
      'サブスクリプションをお持ちでない場合、追加できるエンティティは%s個のみです。プレミアム版にアップグレードすると、無制限にアクセスできます！';

  @override
  String get sort_by_date => '日付で並べ替え';

  @override
  String get newest_to_oldest => '新着順';

  @override
  String get oldest_to_newest => '古い順';

  @override
  String get sort_by_name => '名前で並べ替え';

  @override
  String get sort_by_barcode => 'バーコードで並べ替え';

  @override
  String get sort_by_quantity => '数量で並べ替え';

  @override
  String get action_create_payment => '支払いを作成する';

  @override
  String get action_view_payments => 'リンクされた支払いを表示';

  @override
  String get action_back => '戻る';

  @override
  String get select_payment_type => '支払い方法を選択';

  @override
  String get notification_low_stock_alert_title => '在庫不足アラート';

  @override
  String get notification_low_stock_alert_message =>
      '在庫が少なくなっている商品がございます。ご確認ください。';

  @override
  String get text_cancel => 'キャンセル';

  @override
  String get scan_bar_code_title => 'バーコードをスキャン';

  @override
  String get enter_pin_to_unlock => 'PINを入力してロックを解除してください';

  @override
  String get notification_permission => '通知許可';

  @override
  String get notification_permission_content => 'システム設定で通知を有効にしてください。';

  @override
  String get open_settings => '設定を開く';

  @override
  String get notification_permission_required_message =>
      'アラートを有効にするには通知権限が必要です。';

  @override
  String get company_info_message => 'このデータは印刷された形式（請求書、売上、領収書など）で表示されます。';

  @override
  String get theme => 'テーマ';

  @override
  String get app_theme => 'アプリテーマ';

  @override
  String get documents_colors => 'ドキュメントの色';

  @override
  String get choose_theme => 'テーマを選択';

  @override
  String get theme_system => 'システム';

  @override
  String get theme_light => 'ライト';

  @override
  String get theme_dark => '暗い';
}
