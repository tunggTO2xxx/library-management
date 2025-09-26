import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({
    this.onTap,
    this.height,
    this.color,
    this.actions,
    this.iconColor,
    this.isDisabledBack,
    this.onHorizontalDragUpdate,
    this.title,
    this.systemOverlayStyle,
    super.key,
  });

  final Widget? title;
  final VoidCallback? onTap;
  final double? height;
  final Color? color;
  final List<Widget>? actions;
  final Color? iconColor;
  final bool? isDisabledBack;
  final void Function(DragUpdateDetails)? onHorizontalDragUpdate;
  final SystemUiOverlayStyle? systemOverlayStyle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: onHorizontalDragUpdate,
      child: AppBar(
        title: title,
        centerTitle: false,
        backgroundColor: color ?? Colors.transparent,
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        shadowColor: Colors.transparent,
        actionsPadding: const EdgeInsets.only(right: 15),
        leadingWidth: 35,
        leading: isDisabledBack ?? false
            ? null
            : GestureDetector(
                onTap:
                    onTap ??
                    () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      Navigator.of(context).pop();
                    },
                behavior: HitTestBehavior.translucent,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 7, 0, 7),
                  child: Icon(Icons.arrow_back, color: iconColor),
                ),
              ),
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height ?? 24);
}
