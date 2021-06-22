import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/data/repositories/data_document_repository.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'document_item_row.dart';
import 'documents_controller.dart';

class DocumentsPage extends View {
  @override
  DocumentPageView createState() => DocumentPageView();
}

class DocumentPageView extends ViewState<DocumentsPage, DocumentsController> {
  DocumentPageView() : super(DocumentsController(DataDocumentRepository()));

  Widget get allDocumentView => ControlledWidgetBuilder<DocumentsController>(
          builder: (context, controller) {
        return ModalProgressHUD(
            child: content, inAsyncCall: controller.isLoadingAll, opacity: 0);
      });

  Widget get incomingDocumentView => Stack(
        children: [incomingEmptyView, incomingListView],
      );

  Widget get outgoingDocumentView => Stack(
        children: [outgoingEmptyView, outgoingListView],
      );

  @override
  Widget get view => DefaultTabController(
      key: globalKey,
      length: 3,
      child: Builder(builder: (BuildContext context) {
        return Scaffold(
            appBar: appBar,
            body: TabBarView(
              children: [
                allDocumentView,
                incomingDocumentView,
                outgoingDocumentView,
              ],
            ),
            floatingActionButton: ControlledWidgetBuilder<DocumentsController>(
                builder: (context, controller) {
              return FloatingActionButton(
                onPressed: () => controller
                    .onAddDocument(DefaultTabController.of(context).index),
                child: Icon(Icons.add),
                backgroundColor: Colors.blue,
              );
            }));
      }));

  Widget get appBar => AppBar(
        title: Text(AppLocalizations.of(context).title_document),
        bottom: TabBar(
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: AppLocalizations.of(context).document_list_tab_all),
            Tab(text: AppLocalizations.of(context).document_list_tab_incoming),
            Tab(text: AppLocalizations.of(context).document_list_tab_outgoing),
          ],
        ),
      );

  Widget get allEmptyView => ControlledWidgetBuilder<DocumentsController>(
          builder: (context, controller) {
        return Visibility(
            visible:
                controller.allDocuments.isEmpty && !controller.isLoadingAll,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  UIConstants.documentsIconData,
                  size: 60,
                ),
                Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(AppLocalizations.of(context).empty_document,
                        textAlign: TextAlign.center))
              ],
            ));
      });

  Widget get incomingEmptyView => ControlledWidgetBuilder<DocumentsController>(
          builder: (context, controller) {
        return Visibility(
            visible: controller.incomingDocuments.isEmpty &&
                !controller.isLoadingAll,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  UIConstants.documentsIconData,
                  size: 60,
                ),
                Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                        AppLocalizations.of(context).empty_incoming_document,
                        textAlign: TextAlign.center))
              ],
            ));
      });

  Widget get outgoingEmptyView => ControlledWidgetBuilder<DocumentsController>(
          builder: (context, controller) {
        return Visibility(
            visible: controller.outgoingDocuments.isEmpty &&
                !controller.isLoadingAll,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  UIConstants.documentsIconData,
                  size: 60,
                ),
                Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                        AppLocalizations.of(context).empty_outgoing_document,
                        textAlign: TextAlign.center))
              ],
            ));
      });

  Widget get allListView => ControlledWidgetBuilder<DocumentsController>(
          builder: (context, controller) {
        return Visibility(
            visible: controller.allDocuments.isNotEmpty,
            child: ListView.separated(
                itemBuilder: (BuildContext context, index) {
                  Document item = controller.allDocuments[index];
                  return DocumentItemRow(
                      true,
                      item,
                      (item) => controller.onDocumentTapped(item),
                      (item) => controller.onDocumentLongPressed(item));
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: controller.allDocuments.length));
      });

  Widget get incomingListView => ControlledWidgetBuilder<DocumentsController>(
          builder: (context, controller) {
        return Visibility(
            visible: controller.incomingDocuments.isNotEmpty,
            child: ListView.separated(
                itemBuilder: (BuildContext context, index) {
                  Document item = controller.incomingDocuments[index];
                  return DocumentItemRow(
                      true,
                      item,
                      (item) => controller.onDocumentTapped(item),
                      (item) => controller.onDocumentLongPressed(item));
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: controller.incomingDocuments.length));
      });

  Widget get outgoingListView => ControlledWidgetBuilder<DocumentsController>(
          builder: (context, controller) {
        return Visibility(
            visible: controller.outgoingDocuments.isNotEmpty,
            child: ListView.separated(
                itemBuilder: (BuildContext context, index) {
                  Document item = controller.outgoingDocuments[index];
                  return DocumentItemRow(
                      true,
                      item,
                      (item) => controller.onDocumentTapped(item),
                      (item) => controller.onDocumentLongPressed(item));
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: controller.outgoingDocuments.length));
      });

  Widget get content => Stack(
        children: [allEmptyView, allListView],
      );
}
