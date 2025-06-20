// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get home_title => 'Trang chủ';

  @override
  String get goods_title => 'Hàng hoá';

  @override
  String get goods_select_title => 'Chọn 1 Hàng Hoá';

  @override
  String get expenses_title => 'Chi tiêu';

  @override
  String get empty_goods => 'Chưa có hàng hoá';

  @override
  String get good => 'Hàng hoá';

  @override
  String get folder => 'Nhóm';

  @override
  String get save_goods_title => 'Lưu hàng hoá';

  @override
  String get documents_title => 'Hoá đơn';

  @override
  String get save_expense_title => 'Lưu chi tiêu';

  @override
  String get empty_expense => 'Chưa có chi tiêu';

  @override
  String get empty_document => 'Chưa có hoá đơn';

  @override
  String get empty_incoming_document => 'Chưa có dữ liệu';

  @override
  String get empty_outgoing_document => 'Chưa có dữ liệu';

  @override
  String get document_list_tab_all => 'TẤT CẢ';

  @override
  String get incoming_document_text => 'Nhập hàng';

  @override
  String get outgoing_document_text => 'Bán hàng';

  @override
  String get add_document_title => 'Thêm Hoá đơn';

  @override
  String get document_information => 'Thông tin hoá đơn';

  @override
  String get goods_information => 'Thông tin hàng hoá';

  @override
  String get save_document_batch_scan => 'Quét trùm';

  @override
  String get save_document_sort_by => 'Sắp xếp';

  @override
  String get save_document_help => 'Trợ giúp';

  @override
  String get more_title => 'Khác';

  @override
  String get stores_title => 'Cửa hàng';

  @override
  String get stores_description => 'Thông tin các cửa hàng';

  @override
  String get stores_select_title => 'Chọn 1 cửa hàng';

  @override
  String get save_store_title => 'Lưu cửa hàng';

  @override
  String get empty_stores => 'Chưa có cửa hàng';

  @override
  String get delete_store_error => 'Đây là cửa hàng duy nhất của bạn, không thể thực hiện hành động này';

  @override
  String get suppliers_title => 'Nhà cung cấp';

  @override
  String get suppliers_select_title => 'Chọn 1 NCC';

  @override
  String get save_supplier_title => 'Lưu nhà cung cấp';

  @override
  String get empty_suppliers => 'Chưa có nhà cung cấp';

  @override
  String get customers_title => 'Khách hàng';

  @override
  String get customers_select_title => 'Chọn 1 KH';

  @override
  String get save_customer_title => 'Lưu khách hàng';

  @override
  String get empty_customers => 'Chưa có khách hàng';

  @override
  String get save_group_title => 'Lưu nhóm';

  @override
  String get field_name => 'Tên';

  @override
  String get error_field_name_empty => 'Tên không được bỏ trống';

  @override
  String get field_bar_code => 'Mã vạch';

  @override
  String get field_quantity => 'Số lượng';

  @override
  String get field_quantity_short_form => 'SL';

  @override
  String get field_min_quantity => 'Số lượng tối thiểu';

  @override
  String get field_min_quantity_short_form => 'SLTT.';

  @override
  String get field_total_short_form => 'TC';

  @override
  String get field_supplier => 'Nhà cung cấp';

  @override
  String get field_customer => 'Khách hàng';

  @override
  String get field_date => 'Ngày';

  @override
  String get field_date_time => 'Ngày';

  @override
  String get field_amount => 'Thành tiền';

  @override
  String get field_paid => 'Đã thanh toán';

  @override
  String get field_remaining => 'Còn lại';

  @override
  String get field_images => 'Hình ảnh';

  @override
  String get field_document_type => 'Loại';

  @override
  String get field_person_name => 'KH/NCC';

  @override
  String get field_total => 'Tổng';

  @override
  String get field_purchase_price => 'Giá mua';

  @override
  String get field_sale_price => 'Giá bán';

  @override
  String get field_price => 'Giá';

  @override
  String get field_revenue => 'Doanh thu';

  @override
  String get field_document_no => 'Hoá đơn số';

  @override
  String get home_menu_item_goods => 'Hàng hoá';

  @override
  String get home_menu_item_documents => 'Bản ghi';

  @override
  String get home_menu_item_more => 'Khác';

  @override
  String get message_error_negative_quantity_save_document => 'Không thể thực hiên, vì số lượng của %s bị âm';

  @override
  String get action_send_email => 'Gửi E-mail';

  @override
  String get action_send_sms => 'Gửi Tin Nhắn';

  @override
  String get action_phone_call => 'Gọi Điện Thoại';

  @override
  String get action_view_transaction => 'Xem hoá đơn';

  @override
  String get action_edit => 'Sửa';

  @override
  String get action_delete => 'Xoá';

  @override
  String get message_name_blank => 'Tên không được để trống';

  @override
  String get notification_dialog_title => 'Thông báo';

  @override
  String get question_push_data => 'Bạn có muốn lưu dữ liệu lên máy chủ không?';

  @override
  String get title_store_selecting => 'Cửa hàng đang xem';

  @override
  String get message_delete_supplier_error_having_document => 'Bạn có hoá đơn liên kết với Nhà Cung Cấp này, không thể thực hiện hành động này.';

  @override
  String get message_delete_customer_error_having_document => 'Bạn có hoá đơn liên kết với khách hàng này, không thể thực hiện hành động này.';

  @override
  String get action_ok => 'Đồng ý';

  @override
  String get action_cancel => 'Huỷ';

  @override
  String get search_by_customer_supplier => 'Theo tên KH, NCC';

  @override
  String get action_move_to_group => 'Di chuyển nhóm';

  @override
  String get action_edit_group => 'Sửa nhóm';

  @override
  String get action_add_attachment => 'Nhấn để thêm file';

  @override
  String get action_take_picture => 'Chụp hình';

  @override
  String get dialog_title_sort_by => 'Sắp xếp';

  @override
  String get sort_by_option_no_sort_text => 'Không sắp xếp';

  @override
  String get sort_by_option_a_to_z_text => 'Từ A đến Z';

  @override
  String get sort_by_option_z_to_a_text => 'Từ Z đến A';

  @override
  String get sort_by_option_ascending_text => 'Tăng dần';

  @override
  String get sort_by_option_descending_text => 'Giảm dần';

  @override
  String get in_stock_text => 'Tồn kho: %s';

  @override
  String get menu_item_invite_friend_header => 'Mời bạn bè';

  @override
  String get send_mail_invite_friend_subject => 'Lời mời sử dụng ứng dụng';

  @override
  String get send_mail_invite_friend_content => 'Đây là ứng dụng rất tuyệt vời mà mình sử dụng thường xuyên để quản lý kho, mình muốn giới thiệu nó cho bạn. \nAndroid: https://play.google.com/store/apps/details?id=com.steam.goodmanagerflutter, iOS: https://apps.apple.com/us/app/stock-and-inventory/id6670546293';

  @override
  String get menu_item_write_review_header => 'Viết đánh giá';

  @override
  String get menu_item_write_review_description => 'Chia sẻ cảm nghĩ về ứng dụng của bạn với mọi người';

  @override
  String get menu_item_feedback_header => 'Gửi phản hồi';

  @override
  String get menu_item_feedback_description => 'Chia sẻ phản hồi để cải thiện ứng dụng';

  @override
  String get menu_item_community_header => 'Cộng đồng';

  @override
  String get menu_item_community_description => 'Tham gia cộng đồng ứng dụng để theo dõi tin tức';

  @override
  String get menu_item_donation => 'Ủng hộ';

  @override
  String get menu_item_delete_account => 'Xoá tài khoản';

  @override
  String get menu_item_sign_out => 'Đăng xuất';

  @override
  String get menu_item_whats_new_header => 'Thông tin cập nhật mới';

  @override
  String get menu_item_whats_new_description => 'Các thay đổi của ứng dụng';

  @override
  String get on_boarding_title_1 => 'Quản lý cửa hàng';

  @override
  String get on_boarding_content_1 => 'Bạn có thể tạo ra nhiều cửa hàng để quản lý các hàng hoá của mình theo phân loại. Ví dụ: Cửa hàng trái cây, cửa hàng điện tử,...';

  @override
  String get on_boarding_title_2 => 'Quản lý hàng hoá';

  @override
  String get on_boarding_content_2 => 'Bạn có thể tạo ra nhiều hàng hoá để theo dõi các thông tin của chúng. Ví du: Trái sầu riêng, bóng đèn';

  @override
  String get on_boarding_title_3 => 'Quản lý hoá đơn';

  @override
  String get on_boarding_content_3 => 'Bạn có thể tạo ra các hoá đơn nhập/xuất hàng, từ đó sẽ biết được các hàng hoá còn bao nhiêu trong cửa hàng';

  @override
  String get on_boarding_title_4 => 'Bắt đầu ngay';

  @override
  String get on_boarding_header_4 => 'Nhập tên cửa hàng đầu tiên';

  @override
  String get action_done => 'Hoàn thành';

  @override
  String get action_skip => 'Bỏ qua';

  @override
  String get message_confirm_delete_no_args => 'Bạn có chắc muốn xoá nó ?';

  @override
  String get message_confirm_delete => 'Bạn có chắc muốn xoá %s ?';

  @override
  String get message_confirm_delete_account => 'Bạn có chắc muốn xoá tài khoản ?';

  @override
  String get delete_account_successful => 'Tài khoản đã bị xoá.';

  @override
  String get menu_item_settings_title => 'Cài đặt';

  @override
  String get menu_item_settings_desc => 'Các thông tin cài đặt';

  @override
  String get menu_item_general => 'Chung';

  @override
  String get menu_item_view => 'Hiển thị';

  @override
  String get menu_item_barcode_scanner => 'Quét mã vạch';

  @override
  String get menu_item_minimum_quantity => 'Số lượng tối thiểu';

  @override
  String get menu_item_show_min_quantity_items_page_title => 'Hiển thị trường số lượng tối thiểu ở trang hàng hóa';

  @override
  String get menu_item_show_min_quantity_list_page_title => 'Hiển thị trường số lượng tối thiểu ở trang danh sách hàng hóa';

  @override
  String get menu_item_min_quantity_color_title => 'Màu sắc cho hàng hóa cần đặt hàng lại';

  @override
  String get menu_item_show_low_stock_alert_title => 'Hiển thị thông báo hết hàng';

  @override
  String get menu_item_show_low_stock_alert_desc => 'Khi bạn mở ứng dụng, chúng tôi sẽ gửi thông báo về việc hết hàng';

  @override
  String get menu_item_my_company => 'Thông tin công ty';

  @override
  String get menu_item_backup_and_restore => 'Back up and restore';

  @override
  String get menu_item_language_title => 'Ngôn ngữ';

  @override
  String get menu_item_language_desc => 'Thay đổi ngôn ngữ';

  @override
  String get menu_item_passcode_title => 'Khoá mật khẩu';

  @override
  String get menu_item_passcode_desc => 'Khoá mật khẩu';

  @override
  String get menu_item_reset_numeration_documents_title => 'Cài lại bộ đếm hóa dơn';

  @override
  String get settings_title => 'Cài đặt';

  @override
  String get dialog_title_change_language => 'Chọn ngôn ngữ';

  @override
  String get english_text => 'Tiếng Anh';

  @override
  String get vietnamese_text => 'Tiếng Việt';

  @override
  String get incoming_goods => 'Nhập hàng';

  @override
  String get outgoing_goods => 'Bán hàng';

  @override
  String get report_title => 'Báo cáo';

  @override
  String get select_store_title => 'Chọn cửa hàng';

  @override
  String get select_group_title => 'Chọn nhóm';

  @override
  String get message_type => 'Loại tin nhắn';

  @override
  String get message_type_bug_report => 'Báo cáo lỗi';

  @override
  String get message_type_feedback => 'Phản hồi';

  @override
  String get message_type_suggestion => 'Gợi ý';

  @override
  String get message_type_question => 'Câu hỏi';

  @override
  String get send_mail_bug_report_subject => 'Quản lý kho - Báo cáo lỗi';

  @override
  String get send_mail_feedback_subject => 'Quản lý kho - Phản hồi';

  @override
  String get send_mail_suggestion_subject => 'Quản lý kho - Gợi ý';

  @override
  String get send_mail_question_subject => 'Quản lý kho - Câu hỏi';

  @override
  String get dialog_title_data_not_save => 'Chú ý!';

  @override
  String get dialog_content_data_not_save => 'Đóng mà không lưu dữ liệu';

  @override
  String get batch_mode_scan => 'Chế độ quét mã liên tục';

  @override
  String get after_each_scan => 'Sau mỗi lần quét';

  @override
  String get after_each_scan_auto => 'Tự tăng số lượng thêm 1';

  @override
  String get after_each_scan_manually => 'Nhập số lượng bằng tay';

  @override
  String get when_a_barcode_is_found => 'Khi một mã vạch được tìm thấy';

  @override
  String get beep => 'Kêu';

  @override
  String get vibrate => 'Rung';

  @override
  String get question_or_suggestion_title => 'Câu hỏi và đề xuất';

  @override
  String get help_title => 'Trợ giúp';

  @override
  String get whats_new_title => 'Thông tin cập nhật mới';

  @override
  String get your_subscriptions_title => 'Thông tin đăng ký PRO';

  @override
  String get document_name_no => 'Số.';

  @override
  String get insert_transaction_success => 'Đã thêm sản phầm thành công!';

  @override
  String get insert_transaction_fail => 'Đã thêm sản phầm thất bại!';

  @override
  String get success => 'Thành công!';

  @override
  String get error => 'Thất bại!';

  @override
  String get error_same_barcode => 'Lỗi: cùng mã vạch';

  @override
  String get action_search => 'Tìm kiếm';

  @override
  String get action_sort_by => 'Sắp xếp';

  @override
  String get action_export_csv => 'Xuất CSV';

  @override
  String get action_export_pdf => 'Xuất PDF';

  @override
  String get action_batch_scan => 'Quét mã vạch liên tục';

  @override
  String get action_help => 'Trợ giúp';

  @override
  String get report_type_goods => 'Danh sách hàng hoá';

  @override
  String get report_type_expenses => 'Chi tiêu';

  @override
  String get report_type_list_of_documents => 'Danh sách hoá đơn';

  @override
  String get report_type_debt_by_supplier => 'Công nợ theo nhà cung cấp';

  @override
  String get report_type_debt_by_customer => 'Công nợ theo khách hàng';

  @override
  String get report_type_inbound_payments => 'Giao dịch thu';

  @override
  String get report_type_outbound_payments => 'Giao dịch chi';

  @override
  String get report_type_list_of_supplier_payments => 'Giao dịch theo nhà cung cấp';

  @override
  String get report_type_list_of_customer_payments => 'Giao dịch theo khách hàng';

  @override
  String get report_type_reorder => 'Báo cáo cần đặt hàng';

  @override
  String get select_date_range => 'Chọn khoảng thời gian';

  @override
  String get report_type_current_month => 'Tháng hiện tại';

  @override
  String get report_type_last_30_days => '30 ngày trước';

  @override
  String get report_type_last_90_days => '90 ngày trước';

  @override
  String get report_type_current_year => 'Năm hiện tại';

  @override
  String get report_type_custom => 'Tự Chọn';

  @override
  String get report_detail_period_time => 'Từ ngày %s đến ngày %s';

  @override
  String get report_detail_store => 'Cửa hàng %s';

  @override
  String get select_payment_status => 'Chọn trạng thái thanh toán';

  @override
  String get payment_status_unpaid => 'Chưa trả';

  @override
  String get payment_status_partial => 'Trả 1 phần';

  @override
  String get payment_status_paid => 'Đã trả';

  @override
  String get payments_title => 'Giao dịch';

  @override
  String get payment_invoiced => 'Hoá đơn';

  @override
  String get payment_due_pending => 'Cần trả/còn nợ';

  @override
  String get payment_paid => 'Đã trả';

  @override
  String get empty_payment => 'Chưa có giao dịch';

  @override
  String get title_outbound_payment => 'Chi';

  @override
  String get title_inbound_payment => 'Thu';

  @override
  String get save_outbound_payment_title => 'Lưu GD chi';

  @override
  String get save_inbound_payment_title => 'Lưu GD thu';

  @override
  String get menu_back_up => 'Sao lưu dữ liệu';

  @override
  String get menu_back_up_desc => 'Xuất tệp database ra điện thoại';

  @override
  String get menu_restore => 'Phục hồi dữ liệu';

  @override
  String get menu_restore_desc => 'Chọn tệp database từ điện thoại';

  @override
  String get backup_successful => 'Sao lưu dữ liệu thành công';

  @override
  String get backup_error => 'Sao lưu dữ liệu thất bại!!';

  @override
  String get error_wrong_email_password => 'Sai thông tin email hoặc mật khẩu, hãy thử lại';

  @override
  String get menu_push_data_to_cloud => 'Lưu dữ liệu trên cloud';

  @override
  String get login => 'ĐĂNG NHẬP';

  @override
  String get email => 'Email';

  @override
  String get error_email => 'Nhập email hợp lệ';

  @override
  String get password => 'Mật khẩu';

  @override
  String get error_password => 'Nhập mật khẩu hợp lệ';

  @override
  String get forgot_your_password => 'Quên mật khẩu ?';

  @override
  String get or_sign_in_with => 'hoặc đăng nhập bằng';

  @override
  String get dont_have_an_account_yet => 'Chưa có tài khoản ?';

  @override
  String get sign_up_text => 'Đăng ký';

  @override
  String get sign_up => 'ĐĂNG KÝ';

  @override
  String get name => 'Tên';

  @override
  String get reset_password => 'ĐẶT LẠI MẬT KHẨU';

  @override
  String get email_not_verified_title => 'Email chưa xác nhận';

  @override
  String get email_not_verified_desc => 'Hãy kiểm tra hòm thư của bạn';

  @override
  String get sign_up_successful => 'Đăng ký thành công';

  @override
  String get reset_password_successful => 'Cài lại mật khẩu thành công';

  @override
  String get cloud_file_no_updated => 'Chưa được cập nhật';

  @override
  String get signout_message => 'Bạn có chắc muốn đăng xuất không ?';

  @override
  String get item_history_title => 'Lịch sử';

  @override
  String get list_settings => 'Cài đặt danh sách';

  @override
  String get good_settings_hide_zero_entries => 'Ẩn đối tượng không có số lượng';

  @override
  String get good_setting_show_bar_code => 'Hiện mã vạch';

  @override
  String get good_setting_show_description => 'Hiện mô tả';

  @override
  String get version => 'Phiên bản: %s';

  @override
  String get change_tracking_store => 'Thay đổi cửa hàng theo dõi';

  @override
  String get loading_data => 'Đang tải...';

  @override
  String get title_good_count => 'Số mặt hàng';

  @override
  String get title_total_quantity => 'Tổng tồn kho';

  @override
  String get title_select_document => 'Chọn hoá đơn';

  @override
  String get title_chart_sale_report => 'Báo cáo doanh thu 6 tháng';

  @override
  String get label_select_payment_category => 'Chọn danh mục';

  @override
  String get label_select_wallet => 'Chọn ví';

  @override
  String get label_select_object => 'Select object';

  @override
  String get label_select_outbound_object => 'Chọn đối tượng chi';

  @override
  String get label_select_inbound_object => 'Chọn đối tượng thu';

  @override
  String get label_description => 'Mô tả';

  @override
  String get hint_description => 'Nhập mô tả';

  @override
  String get label_select_document_no => 'Hoá Đơn';

  @override
  String get label_supplier_name => 'Tên nhà cung cấp';

  @override
  String get label_customer_name => 'Tên khách hàng';

  @override
  String get label_group_name => 'Tên nhóm';

  @override
  String get label_good_name => 'Tên hàng hoá';

  @override
  String get label_category_name => 'Tên danh mục';

  @override
  String get label_wallet_name => 'Tên ví';

  @override
  String get hint_name => 'Nhập tên';

  @override
  String get label_address => 'Địa chỉ';

  @override
  String get hint_address => 'Nhập địa chỉ';

  @override
  String get label_email => 'Email';

  @override
  String get hint_email => 'Nhập email';

  @override
  String get label_phone_number => 'Số điện thoại';

  @override
  String get hint_phone_number => 'Nhập số điện thoại';

  @override
  String get label_tax_id => 'Mã số thuế';

  @override
  String get hint_tax_id => 'Nhập mã số thuế';

  @override
  String get label_bank_details => 'Thông tin ngân hàng';

  @override
  String get hint_bank_details => 'Nhập thông tin ngân hàng';

  @override
  String get label_bar_code => 'Mã vạch';

  @override
  String get hint_bar_code => 'Nhập mã vạch';

  @override
  String get action_save => 'Lưu';

  @override
  String get hint_select => 'Chọn';

  @override
  String get action_add_payment_category => 'Thêm danh mục';

  @override
  String get title_pick_color => 'Chọn màu';

  @override
  String get action_add_group => 'Thêm nhóm';

  @override
  String get action_add_good => 'Thêm hàng hoá';

  @override
  String get no_category => 'Không danh mục';

  @override
  String get field_start_period => 'Đầu kì';

  @override
  String get field_in => 'Vào';

  @override
  String get field_out => 'Ra';

  @override
  String get field_end_period => 'Cuối kì';

  @override
  String get action_document_created_withname => 'Hoá đơn %s đã được tạo';

  @override
  String get good_information => 'Thông tin hàng hoá';

  @override
  String get images_information => 'Thông tin hình ảnh';

  @override
  String get change_color => 'Thay đổi màu';

  @override
  String get change_icon => 'Đổi biểu tượng';

  @override
  String get save_file_successful => 'Lưu tệp thành công tại %s';

  @override
  String get save_file_failed => 'Lưu tệp thất bại tại %s';

  @override
  String get no_group => 'Không nhóm';

  @override
  String get save_wallet_title => 'Lưu Ví';

  @override
  String get action_add_wallet => 'Thêm Ví';

  @override
  String get total_balance => 'Tổng số dư';

  @override
  String get title_wallet => 'Ví Tiền';

  @override
  String get categories => 'Danh mục';

  @override
  String get title_save_category => 'Lưu danh mục';

  @override
  String get inbound_categories => 'Danh mục thu';

  @override
  String get outbound_categories => 'Danh mục chi';

  @override
  String get select_object_type => 'Chọn loại đối tượng';

  @override
  String get title_report_list_of_wallet => 'Danh sách ví tiền';

  @override
  String get hint_search_by => 'Tìm kiếm...';

  @override
  String get field_my_company_name => 'Tên công ty';

  @override
  String get field_reorder => 'Tái đặt hàng';

  @override
  String get title_filter => 'Bộ lọc';

  @override
  String get action_reset_all => 'Xóa bộ lọc';

  @override
  String get action_apply => 'Áp dụng';

  @override
  String get by_category => 'Theo danh mục';

  @override
  String get by_wallet => 'Theo ví';

  @override
  String get by_customer => 'Theo khách hàng';

  @override
  String get by_supplier => 'Theo NCC';

  @override
  String get by_date => 'Theo ngày';

  @override
  String get show_all => 'Tất cả';

  @override
  String get start_date => 'Ngày bắt đầu';

  @override
  String get end_date => 'Ngày kết thúc';

  @override
  String get hint_tap_first_column => 'Nhấn các đối tượng ở cột đầu tiên để xem chi tiết.';

  @override
  String get by_status => 'Theo trạng thái';

  @override
  String get status_paid => 'Đã thanh toán';

  @override
  String get status_unpaid => 'Chưa thanh toán';
}
