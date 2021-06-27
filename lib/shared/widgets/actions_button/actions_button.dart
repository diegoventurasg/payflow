import 'package:flutter/material.dart';

import 'package:payflow/shared/themes/app_colors.dart';

class ActionsButton extends StatelessWidget {
  final String label;
  final TextStyle textStyle;
  final Color backgroundColor;
  final Color fontColor;
  final Color borderColor;
  final VoidCallback onTap;

  const ActionsButton({
    Key? key,
    required this.label,
    required this.textStyle,
    required this.backgroundColor,
    required this.fontColor,
    required this.borderColor,
    required this.onTap,
  }) : super(key: key);

  ActionsButton.white({
    required String label,
    required TextStyle textStyle,
    required VoidCallback onTap,
  })  : this.backgroundColor = AppColors.background,
        this.fontColor = AppColors.grey,
        this.borderColor = AppColors.stroke,
        this.textStyle = textStyle,
        this.onTap = onTap,
        this.label = label;

  ActionsButton.orange({
    required String label,
    required TextStyle textStyle,
    required VoidCallback onTap,
  })  : this.backgroundColor = AppColors.primary,
        this.fontColor = AppColors.background,
        this.borderColor = AppColors.stroke,
        this.textStyle = textStyle,
        this.onTap = onTap,
        this.label = label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 156,
      height: 55,
      child: TextButton(
        style: ButtonStyle(
            overlayColor:
                MaterialStateProperty.all(AppColors.grey.withOpacity(0.1)),
            backgroundColor: MaterialStateProperty.all(backgroundColor),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            )),
            side: MaterialStateProperty.all(BorderSide(
              color: borderColor,
            ))),
        onPressed: onTap,
        child: Text(
          label,
          style: textStyle,
        ),
      ),
    );
  }
}
