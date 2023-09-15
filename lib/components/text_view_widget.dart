import 'package:flutter/material.dart';
import 'package:stom_club/constants/hex_colors.dart';

class TextViewWidget extends StatefulWidget {
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final Color? textColor;
  final Brightness? keyboardAppearance;
  final int? maxLines;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final TextCapitalization? textCapitalization;
  final String? placeholder;
  final VoidCallback? onTap;
  final VoidCallback? onEditingComplete;

  const TextViewWidget(
      {Key? key,
      required this.textEditingController,
      required this.focusNode,
      this.textColor,
      this.keyboardAppearance,
      this.textInputType,
      this.textInputAction,
      this.textCapitalization,
      this.placeholder,
      this.onTap,
      this.onEditingComplete,
      this.maxLines})
      : super(key: key);

  @override
  _TextViewState createState() => _TextViewState();
}

class _TextViewState extends State<TextViewWidget> {
  @override
  Widget build(BuildContext context) {
    final _textFormField = TextFormField(
      maxLines: widget.maxLines ?? 1,
      keyboardAppearance: widget.keyboardAppearance ?? Brightness.dark,
      keyboardType: widget.textInputType ?? TextInputType.text,
      focusNode: widget.focusNode,
      controller: widget.textEditingController,
      cursorColor: HexColors.selected,
      textInputAction: widget.textInputAction ?? TextInputAction.done,
      textCapitalization:
          widget.textCapitalization ?? TextCapitalization.sentences,
      style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          color: HexColors.black),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
        counterText: '',
        hintText: widget.placeholder,
        hintStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
            color: widget.textColor ?? HexColors.white),
        suffixIcon: IconButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onPressed: () => {},
            icon: const Icon(Icons.clear, color: Colors.transparent)),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      onTap: () =>
          // ignore: avoid_print
          widget.onTap == null ? print('onTap disabled') : widget.onTap!(),
      onChanged: (text) => {},
      onEditingComplete: () => {
        widget.onEditingComplete == null
            // ignore: avoid_print
            ? print('onEditingComplete is null')
            : widget.onEditingComplete!(),
        FocusScope.of(context).unfocus()
      },
    );

    return Container(
      padding: const EdgeInsets.only(left: 12.0, right: 4.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
              width: 1.0,
              color: widget.focusNode.hasFocus
                  ? HexColors.selected
                  : Colors.transparent),
          color: HexColors.gray),
      child: _textFormField,
    );
  }
}
