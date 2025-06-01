import 'package:flutter/material.dart';
import 'package:good_manager/domain/entities/supplier.dart';
import 'package:good_manager/l10n/app_localizations.dart';
enum SupplierItemMenu { sendEmail, sendSMS, phoneCall }
class SupplierItemRow extends StatelessWidget{
  final Supplier item;
  final void Function(Supplier item) onPressed;
  final void Function(Supplier item) onLongPressed;
  final void Function(Supplier item) onSendEmailPressed;
  final void Function(Supplier item) onSendSmsPressed;
  final void Function(Supplier item) onPhoneCallPressed;

  SupplierItemRow(this.item, this.onPressed, this.onLongPressed, this.onSendEmailPressed, this.onSendSmsPressed, this.onPhoneCallPressed);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => onPressed(item),
        onLongPress: () => onLongPressed(item),
        child: ListTile(
          leading: CircleAvatar(
            child: Text('${item.name[0].toUpperCase()}'),
          ),
          title: Text(item.name, style:
          Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.primary)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              item.description.isNotEmpty
                  ? Text(item.description, style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Theme.of(context).colorScheme.onSurface))
                  : Container(),
              item.numberDocument > 0
                  ? Text(item.numberDocument.toString()+ " " + AppLocalizations.of(context)!.documents_title, style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Theme.of(context).colorScheme.onSurface))
                 : Container()
            ],
          ),
          trailing: PopupMenuButton<SupplierItemMenu>(
            onSelected: (SupplierItemMenu result) {
              switch (result) {
                case SupplierItemMenu.sendEmail:
                  onSendEmailPressed(item);
                  break;
                case SupplierItemMenu.sendSMS:
                  onSendSmsPressed(item);
                  break;
              default:
                  onPhoneCallPressed(item);
                  break;
              }
            },
            itemBuilder: (BuildContext a) =>
            <PopupMenuEntry<SupplierItemMenu>>[
              PopupMenuItem<SupplierItemMenu>(
                  value: SupplierItemMenu.sendEmail,
                  child:
                  Text(AppLocalizations.of(context)!.action_send_email)),
              PopupMenuItem<SupplierItemMenu>(
                  value: SupplierItemMenu.sendSMS,
                  child:
                  Text(AppLocalizations.of(context)!.action_send_sms)),
              PopupMenuItem<SupplierItemMenu>(
                  value: SupplierItemMenu.phoneCall,
                  child:
                  Text(AppLocalizations.of(context)!.action_phone_call)),
            ],
          ),
        ),
      ),
    );
  }
}