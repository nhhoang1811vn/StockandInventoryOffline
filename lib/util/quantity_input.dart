import 'package:flutter/services.dart';

import '../data/app_settings.dart';
import 'quantity_format.dart';

/// Input formatters for a quantity text field: at most the Store's number of
/// decimals ([decimals] overrides it).
List<TextInputFormatter> quantityInputFormatters([int? decimals]) => [
      QuantityInputFormatter(decimals ?? AppSettings.getQuantityDecimals()),
    ];

/// A number keyboard that offers a decimal point only when decimals are
/// allowed.
TextInputType quantityKeyboardType([int? decimals]) =>
    TextInputType.numberWithOptions(
      decimal: (decimals ?? AppSettings.getQuantityDecimals()) > 0,
    );
