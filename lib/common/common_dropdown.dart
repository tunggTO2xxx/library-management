import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:library_management/common/gap.dart';

class CommonDropdown<T> extends StatefulWidget {
  const CommonDropdown({
    super.key,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.value,
    this.hint,
    this.selectedItems,
    this.onChangedMultiSelect,
    this.height,
    this.width,
    this.dropdownMaxHeight,
    this.buttonStyle,
    this.dropdownStyle,
    this.icon,
    this.borderRadius = 8,
    this.disableMultipleSelect = true,
    this.label,
    this.labelStyle,
  });

  /// Current selected value
  final T? value;

  /// List of items
  final List<T> items;

  /// Function to extract display label from item
  final String Function(T) itemLabel;

  /// Callback when value changes
  final ValueChanged<T?> onChanged;

  /// Optional hint widget when nothing is selected
  final Widget? hint;

  /// Items currently selected
  final List<T>? selectedItems;

  /// Callback when selection changes
  final ValueChanged<List<T>>? onChangedMultiSelect;

  /// Custom UI params
  final double? height;
  final double? width;
  final double? dropdownMaxHeight;
  final BoxDecoration? buttonStyle;
  final BoxDecoration? dropdownStyle;
  final Widget? icon;
  final double borderRadius;
  final bool disableMultipleSelect;
  final String? label;
  final TextStyle? labelStyle;

  @override
  State<CommonDropdown<T>> createState() => _CommonDropdownState<T>();
}

class _CommonDropdownState<T> extends State<CommonDropdown<T>> {
  late List<T> multiSelectedItem;

  @override
  void initState() {
    super.initState();
    multiSelectedItem = List.from(widget.selectedItems ?? []);
  }

  @override
  void didUpdateWidget(covariant CommonDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedItems != oldWidget.selectedItems) {
      setState(() {
        multiSelectedItem = List.from(widget.selectedItems ?? []);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(widget.label.toString(), style: widget.labelStyle),
          Gap.h4,
        ],
        DropdownButtonHideUnderline(
          child: DropdownButton2<T>(
            isExpanded: true,
            value: widget.value,
            hint: widget.hint,
            items: widget.items.map((item) {
              return DropdownMenuItem<T>(
                value: item,
                enabled: widget.disableMultipleSelect,
                child: widget.disableMultipleSelect
                    ? Text(
                        widget.itemLabel(item),
                        style: const TextStyle(fontSize: 14),
                      )
                    : StatefulBuilder(
                        builder: (context, menuSetState) {
                          final isSelected = multiSelectedItem.contains(item);
                          return InkWell(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  multiSelectedItem.remove(item);
                                } else {
                                  multiSelectedItem.add(item);
                                }
                                widget.onChangedMultiSelect?.call(
                                  multiSelectedItem,
                                );
                              });

                              menuSetState(() {});
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.itemLabel(item),
                                  style: const TextStyle(fontSize: 14),
                                ),
                                isSelected
                                    ? Icon(Icons.check, color: Colors.black)
                                    : SizedBox(),
                              ],
                            ),
                          );
                        },
                      ),
              );
            }).toList(),
            onChanged: widget.disableMultipleSelect ? widget.onChanged : (_) {},
            buttonStyleData: ButtonStyleData(
              width: widget.width ?? double.infinity,
              height: widget.height,
              decoration:
                  widget.buttonStyle ??
                  BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    border: Border.all(color: Colors.grey.shade400),
                    color: Colors.white,
                  ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: widget.dropdownMaxHeight ?? 250,
              decoration:
                  widget.dropdownStyle ??
                  BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    color: Colors.white,
                  ),
            ),
            iconStyleData: IconStyleData(
              icon: widget.icon ?? const Icon(Icons.arrow_drop_down),
            ),
            customButton: widget.disableMultipleSelect
                ? null
                : Container(
                    height: widget.height,
                    width: widget.width ?? double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration:
                        widget.buttonStyle ??
                        BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            widget.borderRadius,
                          ),
                          border: Border.all(color: Colors.grey.shade400),
                          color: Colors.white,
                        ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            multiSelectedItem.map(widget.itemLabel).join(", "),
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        widget.icon ?? const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
