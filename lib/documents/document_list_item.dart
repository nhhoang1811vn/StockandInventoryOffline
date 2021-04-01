import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/model/Document.dart';
import 'package:intl/intl.dart';

class DocumentList extends StatelessWidget{
  List<Document> items;
  void Function(Document document) onDocumentTapped;
  void Function(Document document) onDocumentLongPressed;
  DocumentList(this.items, this.onDocumentTapped, this.onDocumentLongPressed);

  Color getIndicatorColor(DocumentType type){
    switch(type){
      case DocumentType.incoming:
        return Colors.red;
      case DocumentType.outgoing:
        return Colors.green;
      default:
        return Colors.orange;
    }
  }
  @override
  Widget build(BuildContext context) {
    DateFormat format = DateFormat( "dd/MM/yyyy", "vi");
    if (items == null || items.isEmpty){
      return Center(child: Text('Không có giao dịch'),);
    }else{
      return new ListView.separated(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index){
          return ListTile(
            leading: Container(width: 8,height: 200,color: getIndicatorColor(items[index].type),),
            title: Transform.translate(
              offset: Offset(-32, 0),
              child: Text(items[index].name, style: TextStyle(color: Colors.blue, fontWeight:FontWeight.bold)),
            ),
            subtitle: Transform.translate(
              offset: Offset(-32, 0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ngày ' + format.format(items[index].date)),
                  Text(items[index].supplierName +
                        " | " +
                        items[index].description)
                  ]
              ),
            ),
            trailing: Text(items[index].quantity.toString()),
            onTap: () => onDocumentTapped(items[index]),
            onLongPress: () => onDocumentLongPressed(items[index]),
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },


      );
    }
  }
}