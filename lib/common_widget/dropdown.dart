import 'package:flutter/material.dart';
import 'package:saver_bbk_main/styles/colors.dart';

class SaverDropdown extends StatelessWidget {
  final List<String> items;
  final String selectedItem;
  final ValueChanged<String?> onChanged;
  final Color borderColor;
  final double borderRadius;
  final String hint;

  const SaverDropdown({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    this.borderColor = AppColor.lightGrey,
    this.borderRadius = 7.0,
    this.hint = 'Select an option',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedItem.isNotEmpty ? selectedItem : null,
          hint: Text(hint, style: TextStyle(color: AppColor.lightGrey200)),
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down),
          onChanged: onChanged,
          items:
              items.map((String item) {
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),
        ),
      ),
    );
  }
}
