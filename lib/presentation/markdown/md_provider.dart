import 'package:good_manager/presentation/pages/help_content.dart';

abstract class MDProvider{
  String getWhatNews();
  String getHelpText(HelpType type);
}