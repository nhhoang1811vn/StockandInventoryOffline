import 'package:flutter/material.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/payment.dart';


class SelectDestObjectWidget extends StatefulWidget{
  final PaymentType type;
  final void Function() onDocumentOptionPressed;
  final void Function() onPersonOptionPressed;



  SelectDestObjectWidget({
    required this.type,
    required this.onDocumentOptionPressed,
    required this.onPersonOptionPressed,

  });

  @override
  State<StatefulWidget> createState() {
    return SelectDestObjectWidgetState();
  }
}
class SelectDestObjectWidgetState extends State<SelectDestObjectWidget>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      color: Colors.grey.shade200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(AppLocalizations.of(context)!.select_object_type,
              style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 16),
          SizedBox(
              width: double.infinity,
              child: TextButton(onPressed: widget.onDocumentOptionPressed, child: Text(AppLocalizations.of(context)!.documents_title))),
          SizedBox(
              width: double.infinity,
              child: TextButton(onPressed: widget.onPersonOptionPressed, child: Text(widget.type == PaymentType.inbound ? AppLocalizations.of(context)!.customers_title : AppLocalizations.of(context)!.suppliers_title)))
        ],
      ),
    );
  }
}