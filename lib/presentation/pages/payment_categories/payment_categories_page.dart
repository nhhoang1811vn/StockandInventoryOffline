import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/presentation/pages/payment_categories/bloc/payment_categories_cubit.dart';
import 'package:good_manager/presentation/widget/widget.dart';

import '../../../domain/entity/entity.dart';
import '../../dialog/dialog.dart';
import '../pages.dart';

class PaymentCategoriesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PaymentCategoriesPageState();
  }
}

class PaymentCategoriesPageState extends State<PaymentCategoriesPage> {
  @override
  void initState() {
    super.initState();
    context.read<PaymentCategoriesCubit>().init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentCategoriesCubit, PaymentCategoriesState>(
      builder: (context, state) => _buildScaffold(state),
      listenWhen: (p1, p2) => p1.state != p2.state,
      listener: (context, state) async {},
    );
  }

  void onSaveCategory(PaymentCategory item) async {
    var result = await Navigator.of(context)
        .pushNamed(Pages.save_payment_category, arguments: {"item": item});
    if (result != null) {
      context.read<PaymentCategoriesCubit>().init();
    }
  }

  Scaffold _buildScaffold(PaymentCategoriesState state) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(theme),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CategoriesGridView(
                header: context.tr("inbound_categories"),
                categories: state.inboundCategories,
                onAddNewButtonPressed: () async {
                  PaymentCategory item = PaymentCategory();
                  item.type = PaymentType.inbound;
                  onSaveCategory(item);
                },
                onPressed: (category) {
                  onSaveCategory(category);
                },
                onLongPressed: (category) {
                  _showCategoryOptionsDialog(category);
                },
              ),
              const SizedBox(height: 32),
              CategoriesGridView(
                header: context.tr("outbound_categories"),
                categories: state.outboundCategories,
                onAddNewButtonPressed: () async {
                  PaymentCategory item = PaymentCategory();
                  item.type = PaymentType.outbound;
                  onSaveCategory(item);
                },
                onPressed: (category) {
                  onSaveCategory(category);
                },
                onLongPressed: (category) {
                  _showCategoryOptionsDialog(category);
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _showCategoryOptionsDialog(PaymentCategory item) {
    var items = [
      context.tr("delete"),
    ];
    showSelectOptionDialog(
      context,
      items: items,
      onItemSelected: (index) async {
        if (items[index] == context.tr("delete")) {
          context.read<PaymentCategoriesCubit>().deleteCategory(item.id!);
        }
      },
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      centerTitle: false,
      title: Text(
        context.tr("categories"),
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w800,
          fontSize: 20,
        ),
      ),
      iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
    );
  }
}
