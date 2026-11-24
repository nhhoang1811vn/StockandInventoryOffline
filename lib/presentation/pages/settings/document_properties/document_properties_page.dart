import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widget/widget.dart';
import 'bloc/document_properties_cubit.dart';

class DocumentPropertiesPage extends StatefulWidget {
  const DocumentPropertiesPage({Key? key}) : super(key: key);

  @override
  State<DocumentPropertiesPage> createState() => _DocumentPropertiesPageState();
}

class _DocumentPropertiesPageState extends State<DocumentPropertiesPage> {
  @override
  void initState() {
    super.initState();
    context.read<DocumentPropertiesCubit>().init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentPropertiesCubit, DocumentPropertiesState>(
      builder: (context, state) {
        final cubit = context.read<DocumentPropertiesCubit>();
        return SettingsScaffold(
          title: context.tr("document_properties"),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              SettingsMenuCard(
                children: [
                  SettingsSwitchItem(
                    icon: Icons.image_outlined,
                    title: context.tr("good_properties_image"),
                    subtitle: context.tr("good_properties_toggle_hint"),
                    value: state.showImage,
                    onChanged: cubit.onShowImageChanged,
                  ),
                  SettingsSwitchItem(
                    icon: Icons.tag_rounded,
                    title: context.tr("document_no"),
                    subtitle: context.tr("good_properties_toggle_hint"),
                    value: state.showDocumentNo,
                    onChanged: cubit.onShowDocumentNoChanged,
                  ),
                  SettingsSwitchItem(
                    icon: Icons.schedule_rounded,
                    title: context.tr("field_date_time"),
                    subtitle: context.tr("good_properties_toggle_hint"),
                    value: state.showDateTime,
                    onChanged: cubit.onShowDateTimeChanged,
                  ),
                  SettingsSwitchItem(
                    icon: Icons.notes_outlined,
                    title: context.tr("label_description"),
                    subtitle: context.tr("good_properties_toggle_hint"),
                    value: state.showDescription,
                    onChanged: cubit.onShowDescriptionChanged,
                    isLast: true,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
