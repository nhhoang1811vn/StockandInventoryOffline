import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SelectSymbolsWidget extends StatefulWidget {
  final String symbol;
  final Function(String symbol) onPressed;

  SelectSymbolsWidget({required this.symbol, required this.onPressed});

  @override
  State<StatefulWidget> createState() {
    return SelectSymbolsWidgetState();
  }
}

class SelectSymbolsWidgetState extends State<SelectSymbolsWidget> {
  List<String> symbols = [
    "🏠", // Rent
    "💡", // Electricity Bill
    "💧", // Water Bill
    "📶", // Internet Bill
    "📱", // Phone Recharge / Bill
    "🛒", // Supplier Payment
    "📦", // Packaging Supplies
    "🚚", // Delivery Charges
    "🛠️", // Maintenance / Repairs
    "🧼", // Cleaning Services
    "💵", // Staff Salaries
    "🔒", // Security Services
    "💻", // POS System / Software Subscription
    "📣", // Marketing / Advertising
    "🚛", // Transport / Logistics
    "🏦", // Bank Charges
    "💳", // Loan Repayment
    "🛡️", // Insurance (Shop / Stock)
    "🐜", // Pest Control
    "🚮", // Waste Disposal
    "📜", // Licenses & Permits
    "💰", // Tax Payment
    "🛋️", // Furniture & Fixtures
    "👕", // Uniforms / Staff Clothing
    "🖨️", // Printer Ink & Paper
    "✏️", // Stationery Supplies
    "⛽", // Fuel (if applicable)
    "📑", // Other Bills
  ];

  @override
  void initState() {
    super.initState();
  }

  Widget _buildWidget(String symbol) {
    //bool selected = false;
    bool selected = symbol == widget.symbol;
    return InkWell(
      onTap: () {
        widget.onPressed(symbol);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: selected
            ? BoxDecoration(
                color: Colors.blue.shade50,
                border: Border.all(
                  color: Colors.blue.shade700,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(16),
              )
            : null, // No decoration if not selected

        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(symbol, style: TextStyle(fontSize: 28)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      //color: Colors.grey.shade200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.tr("label_select_payment_category"),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 16),
          Card(
            //color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: GridView.builder(
                itemCount: symbols.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  return _buildWidget(symbols[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
