import 'package:flutter/material.dart';

class AppTextSelection extends StatelessWidget {
  final Widget? icon;
  final String item;
  final bool isSelected;
  final void Function() onPressed;

  AppTextSelection({
    this.icon,
    required this.item,
    required this.isSelected,
    required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme
        .of(context)
        .brightness == Brightness.dark;
    var bgColor;
    var textColor;
    if (isSelected){
      bgColor = Theme.of(context).colorScheme.primary;
      textColor = Theme.of(context).colorScheme.onPrimary;
    }else{
      bgColor = isDarkMode
          ? Colors.grey[800]
          : Colors.grey[300];

      textColor = isDarkMode
          ? Colors.white
          : Colors.black;

    }
    return InkWell(
      onTap: () {
        onPressed();
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: bgColor,
          ),
          child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: icon!),
                Text(
                  item,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: textColor),
                  textAlign: TextAlign.center,
                ),
                if (isSelected)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(Icons.check, color: textColor, size: 20,),
                  )
              ])),
    );
  }
}
