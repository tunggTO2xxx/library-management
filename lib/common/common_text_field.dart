import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:library_management/common/gap.dart';

class CommonTextField extends StatelessWidget {
  const CommonTextField({
    required this.controller,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.label,
    this.labelStyle,
    this.labelColor,
    this.hintText,
    this.colorHintText,
    this.minLines = 1,
    this.maxLines = 1,
    this.maxLength = 255,
    this.isObscure = false,
    this.isLast = false,
    this.isEnable = true,
    this.fillColor,
    this.borderColor,
    this.suffixIcon,
    this.underlineInputBorder = false,
    this.onChanged,
    this.textColor,
    this.inputFormatters,
    this.onFieldSubmitted,
    this.textAlign,
    this.errorText,
    this.helperText,
    this.colorHelperText,
    this.isShowBorder = false,
    this.validator,
    this.padding,
    this.isShowTextError = true,
    this.height,
    this.onTapOutsite,
    this.suffix,
    this.onTap,
    this.borderRadius,
    this.width,
    this.textStyle,
    super.key,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final String? label;
  final TextStyle? labelStyle;
  final Color? labelColor;
  final String? hintText;
  final Color? colorHintText;
  final int minLines;
  final int maxLines;
  final int? maxLength;
  final bool isObscure;
  final bool isLast;
  final bool isEnable;
  final Color? fillColor;
  final Color? borderColor;
  final Widget? suffixIcon;
  final bool underlineInputBorder;
  final ValueChanged<String>? onChanged;
  final Color? textColor;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onFieldSubmitted;
  final TextAlign? textAlign;
  final String? errorText;
  final Color? colorHelperText;
  final String? helperText;
  final bool isShowBorder;
  final String? Function(String?)? validator;
  final EdgeInsetsGeometry? padding;
  final bool isShowTextError;
  final double? height;
  final void Function()? onTapOutsite;
  final Widget? suffix;
  final VoidCallback? onTap;
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final hasInteracted = ValueNotifier<bool>(false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label.toString(), style: labelStyle),
          Gap.h4,
        ],
        Container(
          height: height ?? 42,
          width: width,
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.5,
              color: (errorText != null && isShowBorder)
                  ? Colors.red
                  : (borderColor ?? Colors.transparent),
            ),
            borderRadius: borderRadius ?? BorderRadius.circular(5),
            color: fillColor,
          ),
          alignment: Alignment.center,
          child: ValueListenableBuilder<bool>(
            valueListenable: hasInteracted,
            builder: (context, interacted, child) {
              return TextFormField(
                validator:
                    validator ??
                    ((value) {
                      return errorText;
                    }),
                textAlign: textAlign ?? TextAlign.start,
                controller: controller,
                focusNode: focusNode,
                keyboardType: keyboardType,
                textInputAction:
                    textInputAction ??
                    (isLast ? TextInputAction.done : TextInputAction.next),
                inputFormatters: inputFormatters,
                obscureText: isObscure,
                minLines: minLines,
                maxLines: maxLines,
                maxLength: maxLength,
                obscuringCharacter: '*',
                cursorColor: Colors.black,
                enabled: isEnable,
                onChanged: (value) {
                  if (!hasInteracted.value) {
                    hasInteracted.value = true;
                  }
                  onChanged?.call(value);
                },
                onFieldSubmitted: (value) {
                  onFieldSubmitted?.call(value);
                  if (textInputAction == TextInputAction.search) {
                    FocusScope.of(context).unfocus();
                  }
                },
                onTapOutside: (_) {
                  // Mark as interacted when user taps away
                  onTapOutsite?.call();
                  if (!hasInteracted.value) {
                    hasInteracted.value = true;
                  }
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                onTap: onTap,
                decoration: InputDecoration(
                  contentPadding:
                      padding ??
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  border: underlineInputBorder
                      ? const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        )
                      : InputBorder.none,
                  enabledBorder: underlineInputBorder
                      ? const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        )
                      : InputBorder.none,
                  focusedBorder: underlineInputBorder
                      ? const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        )
                      : InputBorder.none,
                  errorBorder: underlineInputBorder
                      ? const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        )
                      : InputBorder.none,
                  suffixIcon: suffixIcon,
                  suffix: suffix,
                  suffixIconConstraints: const BoxConstraints(
                    maxHeight: 20,
                    maxWidth: 20,
                  ),
                  fillColor: fillColor,
                  hintText: hintText,
                  hintStyle: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: colorHintText),
                  isDense: true,
                  counterText: '',
                  errorStyle: const TextStyle(
                    height: 0,
                    color: Colors.transparent,
                  ),
                ),
                style:
                    textStyle ??
                    Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: textColor),
              );
            },
          ),
        ),
        // if ((errorText != null && isShowTextError) || helperText != null)
        //   Padding(
        //     padding: const EdgeInsets.only(top: 4, left: 2),
        //     child: TextView(
        //       text: errorText ?? helperText!,
        //       textColor:
        //           colorHelperText ??
        //           (errorText != null
        //               ? AppColors.statusRed
        //               : AppColors.statusInform),
        //     ),
        //   ),
      ],
    );
  }
}
