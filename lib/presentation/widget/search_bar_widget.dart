import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../utils.dart';

class SearchBarWidget extends StatefulWidget {
  final FocusNode? focusNode;
  final ValueChanged<String>? onTextChanged;
  final bool showCamera;

  const SearchBarWidget({
    super.key,
    this.onTextChanged,
    this.focusNode,
    this.showCamera = false,
  });

  @override
  State<StatefulWidget> createState() {
    return SearchBarWidgetState();
  }
}

class SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    controller.removeListener(_onTextChanged);
    controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {}); // Triggers rebuild on text change
    if (widget.onTextChanged != null) {
      widget.onTextChanged!(controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Material(
      borderRadius: BorderRadius.circular(16),
      child: TextField(
        focusNode: widget.focusNode,
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
          hintText: context.tr("hint_search_by"),
          prefixIcon: Icon(Icons.search_sharp),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (controller.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    controller.clear();
                    setState(() {});
                  },
                ),
              if (widget.showCamera)
                IconButton(
                  onPressed: () async {
                    var result = await Utils.scanBarcode(context);
                    if (result != null) {
                      controller.text = result;
                    }
                  },
                  icon: Icon(Icons.barcode_reader),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
