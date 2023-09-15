import 'package:flutter/material.dart';
import 'package:stom_club/constants/hex_colors.dart';

class InputWidget extends StatefulWidget {
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final Color? textColor;
  final Brightness? keyboardAppearance;
  final BoxConstraints? constraints;
  final EdgeInsets? margin;
  final int? maxLines;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final TextCapitalization? textCapitalization;
  final bool? removeClearButton;
  final String? placeholder;
  final Function(String)? onChanged;
  final VoidCallback? onTap;
  final VoidCallback? onEditingComplete;

  const InputWidget(
      {Key? key,
      required this.textEditingController,
      required this.focusNode,
      this.textColor,
      this.keyboardAppearance,
      this.constraints,
      this.margin,
      this.textInputType,
      this.textInputAction,
      this.textCapitalization,
      this.removeClearButton,
      this.placeholder,
      this.onChanged,
      this.onTap,
      this.onEditingComplete,
      this.maxLines})
      : super(key: key);

  @override
  _InputState createState() => _InputState();
}

class _InputState extends State<InputWidget> {
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
          color: HexColors.selected),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
        counterText: '',
        hintText: widget.placeholder,
        hintStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
            color: widget.textColor ?? HexColors.white),
        suffixIcon: widget.removeClearButton != null &&
                widget.removeClearButton == true
            ? null
            : widget.textEditingController.text.isNotEmpty &&
                    widget.focusNode.hasFocus
                ? IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onPressed: () => setState(() {
                      widget.onChanged != null ? widget.onChanged!('') : {};
                      widget.textEditingController.clear();
                    }),
                    icon: Image.asset('assets/ic_clear.png',
                        width: 20.0,
                        height: 20.0,
                        fit: BoxFit.cover,
                        color: HexColors.unselected),
                  )
                : IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onPressed: () => {},
                    icon: const Icon(Icons.clear, color: Colors.transparent)),
        // fillColor: Color.fromRGBO(21, 33, 47, 1.0),
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
      onChanged: (text) =>
          widget.onChanged == null ? {} : widget.onChanged!(text),
      onEditingComplete: () => {
        widget.onEditingComplete == null
            // ignore: avoid_print
            ? print('onEditingComplete is null')
            : widget.onEditingComplete!(),
        FocusScope.of(context).unfocus()
      },
    );

    return Container(
        constraints:
            widget.constraints ?? const BoxConstraints(minHeight: 52.0),
        margin: widget.margin ?? const EdgeInsets.symmetric(horizontal: 24.0),
        padding: const EdgeInsets.only(left: 12.0, right: 4.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
                width: 1.0,
                color: widget.focusNode.hasFocus
                    ? HexColors.selected
                    : Colors.transparent),
            color: HexColors.row),
        child: widget.constraints == null
            ? Row(children: [
                Image.asset('assets/ic_search.png'),
                Expanded(child: _textFormField)
              ])
            : Center(
                child: _textFormField,
              ));
  }
}
