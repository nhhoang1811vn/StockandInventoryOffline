import 'dart:convert';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:good_manager/presentation/pages/pages.dart';
import 'package:good_manager/presentation/pages/save_good/bloc/save_good_cubit.dart';
import 'package:good_manager/presentation/pages/save_good/components/quick_insert_document_widget.dart';
import 'package:good_manager/presentation/utils.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sprintf/sprintf.dart';

import '../../../../constant/constant.dart';
import '../../../../domain/entity/entity.dart';
import '../../../../presentation/widget/widget.dart';
import '../../../../util/util.dart';
import '../../../dialog/dialog.dart';
import '../../../review_manager.dart';
import '../../full_image_page.dart';

class SaveGoodForm extends StatelessWidget {
  SaveGoodForm();

  final quantityTextController = TextEditingController();
  final priceTextController = TextEditingController();
  final barcodeTextController = TextEditingController();

  final purchasePriceTextController = TextEditingController();
  final salePriceTextController = TextEditingController();
  final minQuantityTextController = TextEditingController();

  final _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SaveGoodCubit, SaveGoodState>(
      listenWhen: (state1, state2) {
        return state1.state != state2.state;
      },
      listener: (BuildContext context, SaveGoodState state) async {
        if (state.state is SaveItemError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(snackBarWhenFailure(context));
        } else if (state.state is SaveItemSameBarcodeError) {
          ScaffoldMessenger.of(context).showSnackBar(
            snackBarWhenFailureWithText(
              context.tr("error_same_barcode"),
            ),
          );
        } else if (state.state is SaveItemSuccessful) {
          ReviewManager.maybeRequestReview();
          ScaffoldMessenger.of(context)
              .showSnackBar(snackBarWhenSuccess(context));
          Navigator.of(context)
              .pop({"item": state.item, "document": state.document});
        } else if (state.state is OpenCalculatorToInputQuantityState) {
          showCalculatorPopup(context, state.transaction!.quantity.toDouble(),
              (p0) {
            context
                .read<SaveGoodCubit>()
                .quantityChanged(p0.toInt().toString());
            quantityTextController.text = p0.toInt().toString();
          });
        } else if (state.state is OpenCalculatorToInputPriceState) {
          showCalculatorPopup(context, state.transaction!.price, (p0) {
            NumberFormat format = new NumberFormat("0.#");
            context.read<SaveGoodCubit>().onPriceChanged(format.format(p0));
            priceTextController.text = Config.simpleCurrencyFormat.format(p0);
          });
        } else if (state.state is OpenCalculatorToInputPurchasePriceState) {
          showCalculatorPopup(context, state.purchasePrice, (p0) {
            NumberFormat format = new NumberFormat("0.#");
            context
                .read<SaveGoodCubit>()
                .onPurchasePriceChanged(format.format(p0));
            purchasePriceTextController.text =
                Config.simpleCurrencyFormat.format(p0);
          });
        } else if (state.state is OpenCalculatorToInputSalePriceState) {
          showCalculatorPopup(context, state.salePrice, (p0) {
            NumberFormat format = new NumberFormat("0.#");
            context.read<SaveGoodCubit>().onSalePriceChanged(format.format(p0));
            salePriceTextController.text =
                Config.simpleCurrencyFormat.format(p0);
          });
        } else if (state.state is OpenBarcodeScannerPageState) {
          var result = await Utils.scanBarcode(context);
          if (result != null) {
            context.read<SaveGoodCubit>().barCodeChanged(result);
          }
        } else if (state.state is OpenHistoryPageState) {
          Navigator.of(context).pushNamed(
            Pages.good_history,
            arguments: {'goodId': state.item!.id},
          );
        } else if (state.state is OpenReceiveGoodsPopupState) {
          //quick insert document +
          Map<dynamic, dynamic>? result = await showDialog(
            context: context,
            builder: (_) =>
                QuickInsertDocumentWidget(state.item!, DocumentType.incoming),
            barrierDismissible: true,
          );
          if (result != null) {
            saveTransaction(context, DocumentType.incoming, state, result);
          }
        } else if (state.state is OpenIssueGoodsPopupState) {
          //quick insert document -
          Map<dynamic, dynamic>? result = await showDialog(
            context: context,
            builder: (_) =>
                QuickInsertDocumentWidget(state.item!, DocumentType.outgoing),
            barrierDismissible: true,
          );
          if (result != null) {
            saveTransaction(context, DocumentType.outgoing, state, result);
          }
        }
      },
      builder: (context, state) {
        barcodeTextController.text = state.barCode;
        if (state.transaction?.price != null) {
          priceTextController.text =
              Config.simpleCurrencyFormat.format(state.transaction?.price);
        } else {
          priceTextController.text = "";
        }
        if (state.purchasePrice != null) {
          purchasePriceTextController.text =
              Config.simpleCurrencyFormat.format(state.purchasePrice);
        } else {
          purchasePriceTextController.text = "";
        }
        if (state.salePrice != null) {
          salePriceTextController.text =
              Config.simpleCurrencyFormat.format(state.salePrice);
        } else {
          salePriceTextController.text = "";
        }
        if (state.minQuantity != null) {
          minQuantityTextController.text =
              Config.simpleCurrencyFormat.format(state.minQuantity);
        } else {
          minQuantityTextController.text = "";
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildLogo(context, state.files.firstOrNull),
            SizedBox(
              height: 16,
            ),
            AppTextField(
              labelText: context.tr("label_good_name"),
              hintText: context.tr("hint_name"),
              initialValue: state.name.value,
              onChanged: (value) =>
                  context.read<SaveGoodCubit>().nameChanged(value),
              keyboardType: TextInputType.name,
              error: state.name.displayError?.text(context),
            ),
            SizedBox(
              height: 16,
            ),
            AppTextField(
              labelText: context.tr("label_description"),
              hintText: context.tr("hint_description"),
              maxLines: null,
              minLines: 2,
              initialValue: state.description,
              onChanged: (value) =>
                  context.read<SaveGoodCubit>().descriptionChanged(value),
              keyboardType: TextInputType.name,
            ),
            SizedBox(
              height: 16,
            ),
            _buildBarCode(context, state),
            SizedBox(height: 16),
            if (state.transaction == null)
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildPurchasePrice(context, state)),
                      Expanded(child: _buildSalePrice(context, state)),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Expanded(child: _buildQuantity(context, state, true)),
                      CircleButton(
                        FontAwesomeIcons.plus,
                        context
                            .read<SaveGoodCubit>()
                            .onPlusQuantityButtonPressed,
                      ),
                      CircleButton(
                        FontAwesomeIcons.minus,
                        context
                            .read<SaveGoodCubit>()
                            .onMinusQuantityButtonPressed,
                      ),
                    ],
                  ),
                ],
              ),
            if (state.transaction != null)
              Row(
                children: [
                  Expanded(
                    child: _buildQuantity(context, state, false),
                  ),
                  Expanded(child: _buildPrice(context, state)),
                ],
              ),
            SizedBox(
              height: 16,
            ),
            if (state.showMinQuantity)
              AppTextField(
                labelText: context.tr("min_quantity"),
                hintText: context.tr("min_quantity"),
                controller: minQuantityTextController,
                onChanged: (value) =>
                    context.read<SaveGoodCubit>().onMinQuantityChanged(value),
                keyboardType: TextInputType.number,
              ),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Text(
                  context.tr("images_information"),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Spacer(),
                if (state.files.isNotEmpty)
                  CircleButton(Icons.add_a_photo, () {
                    _showImageSourceDialog(context, false);
                  })
              ],
            ),
            SizedBox(
              height: 8,
            ),
            _buildPhoto(context, state)
          ],
        );
      },
    );
  }

  _buildLogo(BuildContext context,Uint8List? logo) {
    return GestureDetector(
      onTap: () {
        _showImageSourceDialog(context, true);
      },
      child:
      logo == null
          ? const CircleAvatar(
        radius: 50,
        child: Icon(
          Icons.camera_alt,
          size: 30,
          color: Colors.white70,
        ),
      )
          : SizedBox(
        width: 100,
        height: 100,
        child: ClipOval(
          child: Image.memory(
            logo,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildBarCode(BuildContext context, SaveGoodState state) {
    return Row(
      children: [
        Expanded(
          child: AppTextField(
            //initialValue: state.barCode,
            controller: barcodeTextController,
            labelText: context.tr("label_bar_code"),
            hintText: context.tr("hint_bar_code"),
            onChanged: (value) =>
                context.read<SaveGoodCubit>().barCodeChanged(value),
            keyboardType: TextInputType.text,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: CircleButton(
            Icons.barcode_reader,
            context.read<SaveGoodCubit>().onBarcodeScannerPressed,
          ),
        ),
      ],
    );
  }

  Widget _buildQuantity(
    BuildContext context,
    SaveGoodState state,
    bool readonly,
  ) {
    quantityTextController.text =
        StringUtils.getQuantityText(state.item!.quantity);
    return Row(
      children: [
        Expanded(
          child: AppTextField(
            readOnly: readonly,
            labelText: context.tr("quantity"),
            keyboardType: TextInputType.number,
            onChanged: (value) =>
                context.read<SaveGoodCubit>().quantityChanged(value),
            controller: quantityTextController,
          ),
        ),
        if (!readonly)
          Align(
            alignment: Alignment.centerRight,
            child: CircleButton(
              FontAwesomeIcons.calculator,
              context.read<SaveGoodCubit>().onQuantityCalculatorPressed,
            ),
          ),
      ],
    );
  }

  Widget _buildPrice(BuildContext context, SaveGoodState state) {
    return Row(
      children: [
        Expanded(
          child: CurrencyAppTextField(
            labelText: state.transaction?.type == DocumentType.incoming
                ? context.tr("purchase_price")
                : context.tr("sale_price"),
            controller: priceTextController,
            onChanged: context.read<SaveGoodCubit>().onPriceChanged,
          ),
        ),
        CircleButton(
          FontAwesomeIcons.calculator,
          context.read<SaveGoodCubit>().onPriceCalculatorPressed,
        ),
      ],
    );
  }

  Widget _buildPurchasePrice(BuildContext context, SaveGoodState state) {
    return Row(
      children: [
        Expanded(
          child: CurrencyAppTextField(
            labelText: context.tr("purchase_price"),
            controller: purchasePriceTextController,
            onChanged: context.read<SaveGoodCubit>().onPurchasePriceChanged,
          ),
        ),
        CircleButton(
          FontAwesomeIcons.calculator,
          context.read<SaveGoodCubit>().onPurchasePriceCalculatorPressed,
        ),
      ],
    );
  }

  Widget _buildSalePrice(BuildContext context, SaveGoodState state) {
    return Row(
      children: [
        Expanded(
          child: CurrencyAppTextField(
            labelText: context.tr("sale_price"),
            controller: salePriceTextController,
            onChanged: context.read<SaveGoodCubit>().onSalePriceChanged,
          ),
        ),
        CircleButton(
          FontAwesomeIcons.calculator,
          context.read<SaveGoodCubit>().onSalePriceCalculatorPressed,
        ),
      ],
    );
  }

  Future<void> saveTransaction(
    BuildContext context,
    DocumentType type,
    SaveGoodState state,
    Map result,
  ) async {
    int storeId = context.read<SaveGoodCubit>().getSelectedStoreId();

    Document document = Document();
    document.storeId = storeId;
    document.type = type;
    document.name = context.tr("document_name_no") +
        context.read<SaveGoodCubit>().getAutoDocumentNo(storeId).toString();
    document.date = result["date"] ?? DateTime.now();
    document.description = result["description"] ?? "";
    document.personId = result["personId"] ?? null;

    int documentId =
        await context.read<SaveGoodCubit>().insertDocument(document);

    DocumentTransaction transaction = DocumentTransaction();
    transaction.storeId = storeId;
    transaction.documentId = documentId;
    transaction.goodId = state.item!.id!;
    transaction.type = type;
    transaction.quantity = result["quantity"] ?? 0.0;
    transaction.price = result["price"] ?? 0.0;

    context.read<SaveGoodCubit>().insertTransaction(transaction);
    if (type == DocumentType.incoming) {
      context.read<SaveGoodCubit>().updateQuantity(transaction.quantity);
    } else {
      context.read<SaveGoodCubit>().updateQuantity(-transaction.quantity);
    }

    var text = sprintf(
      context.tr("action_document_created_withname"),
      [document.name],
    );
    ScaffoldMessenger.of(context)
        .showSnackBar(snackBarWhenSuccessWithText(text));
  }

  Widget _buildPhoto(BuildContext context, SaveGoodState state) {
    return Container(
      padding: EdgeInsets.all(4),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          style: BorderStyle.solid,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: state.files.isEmpty
          ? _buildAddPhotoWidget(context)
          : _buildPreview(context, state.files),
    );
  }

  Widget _buildAddPhotoWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showImageSourceDialog(context, false);
      },
      child: Container(
          height: 120,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_a_photo, color: Colors.grey, size: 40),
              SizedBox(height: 8),
              Text(
                context.tr("tap_to_add_file"),
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          )),
    );
  }

  Widget _buildPreview(BuildContext context, List<Uint8List> files) {
    return Wrap(
        runSpacing: 8,
        spacing: 8,
        children: files.asMap().entries.map((entry) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      entry.value,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FullImagePage(
                          base64Image: base64Encode(entry.value),
                          heroTag: 'imageHero',
                        ),
                      ),
                    );
                  }),
              Positioned(
                right: 4,
                top: 4,
                child: GestureDetector(
                  onTap: () {
                    context.read<SaveGoodCubit>().onDeleteFile(entry.key);
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          );
        }).toList());
  }

  void _showImageSourceDialog(BuildContext context, bool isLogo) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo),
              title: Text(context.tr("choose_gallery")),
              onTap: () async {
                Navigator.pop(context);
                await _pickAndSaveImage(context, ImageSource.gallery, isLogo);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(context.tr("take_picture")),
              onTap: () async {
                Navigator.pop(context);
                await _pickAndSaveImage(context, ImageSource.camera, isLogo);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAndSaveImage(BuildContext context, ImageSource source, bool isLogo) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 75,
    );
    if (pickedFile == null) return;
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio4x3,
          ],
        ),
        IOSUiSettings(
          title: 'Cropper',
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio4x3,
          ],
        ),
      ],
    );
    if (croppedFile == null) return;
    final bytes = await croppedFile.readAsBytes();
    if (isLogo){
      context.read<SaveGoodCubit>().onLogoChanged(bytes);
    }else{
      context.read<SaveGoodCubit>().onAddFile(bytes);
    }
  }
}
