import 'package:btt/view/global/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../global/constants/text_styles.dart';

class BTTDropdownButton extends StatefulWidget {
  Map<dynamic, String> items;
  final void Function(Object? value) onChanged;
  final String hint;
  final Object? value;
  final IconData? icon;
  final bool loadingData;
  final String loadingText;
  final Key? assignKey;
  BTTDropdownButton(
      {super.key,
      required this.items,
      required this.onChanged,
      required this.hint,
      this.value,
      this.icon,
      this.loadingData = false,
      this.assignKey,
      this.loadingText = 'Loading...'});

  @override
  State<BTTDropdownButton> createState() => _BTTDropdownButtonState();
}

class _BTTDropdownButtonState extends State<BTTDropdownButton> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      key: widget.assignKey,
      items: widget.items.entries.map((entry) {
        return DropdownMenuItem(
          value: entry.key,
          child: Text(
            entry.value,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      selectedItemBuilder: (context) {
        return widget.loadingData
            ? []
            : widget.items.entries.map((entry) {
                return SizedBox(
                  width: 0.65.sw,
                  child: Text(
                    entry.value,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.body,
                  ),
                );
              }).toList();
      },
      value: widget.value,
      hint: Text(
        widget.loadingData ? widget.loadingText : widget.hint,
        style: TextStyles.body.apply(color: AppColors.secondaryText),
      ),
      iconSize: 0,
      onChanged: widget.onChanged,
      style: TextStyles.body,
      dropdownColor: AppColors.elevationOne,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.elevationOne,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.r),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.zero,
        hintStyle: TextStyles.body.apply(color: AppColors.secondaryText),
        prefixIcon: Icon(
          widget.icon,
        ),
        suffixIcon: widget.loadingData
            ? IntrinsicHeight(
                child: SizedBox(
                  height: 10.h,
                  width: 10.h,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 3.w,
                    ),
                  ),
                ),
              )
            : const Icon(
                Icons.arrow_drop_down_circle_rounded,
                color: AppColors.darkElevation,
              ),
      ),
    );
  }
}
