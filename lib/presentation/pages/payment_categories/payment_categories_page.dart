import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/presentation/pages/payment_categories/bloc/payment_categories_cubit.dart';
import 'package:good_manager/presentation/widget/widget.dart';

import '../../../constant/constant.dart';
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

  void funcA(PaymentCategory item) async {
    var result = await Navigator.of(context)
        .pushNamed(Pages.save_payment_category, arguments: {"item": item});
    if (result != null) {
      context.read<PaymentCategoriesCubit>().init();
    }
  }

  Scaffold _buildScaffold(PaymentCategoriesState state) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Text(, style: Theme.of(context).textTheme.titleMedium,),
            CategoriesGridView(
              header: context.tr("inbound_categories"),
              categories: state.inboundCategories,
              onAddNewButtonPressed: () async {
                PaymentCategory item = PaymentCategory();
                item.type = PaymentType.inbound;
                funcA(item);
              },
              onPressed: (category) {
                funcA(category);
              },
              onLongPressed: (category) {
                _showCategoryOptionsDialog(category);
              },
            ),
            SizedBox(
              height: 16,
            ),
            //Text(,  style: Theme.of(context).textTheme.titleMedium),
            CategoriesGridView(
              header: context.tr("outbound_categories"),
              categories: state.outboundCategories,
              onAddNewButtonPressed: () async {
                PaymentCategory item = PaymentCategory();
                item.type = PaymentType.outbound;
                funcA(item);
              },
              onPressed: (category) {
                funcA(category);
              },
              onLongPressed: (category) {
                _showCategoryOptionsDialog(category);
              },
            ),
          ],
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
          context.read<PaymentCategoriesCubit>().init();
        }
      },
    );
  }

  PreferredSize _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(UIConstants.appBarHeight),
      child: AppBar(
        title: new Text(context.tr("categories")),
        actions: [],
      ),
    );
  }
}
