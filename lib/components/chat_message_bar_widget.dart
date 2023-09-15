import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:stom_club/components/action_sheet_widget.dart';
import 'package:stom_club/components/device_detector.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'package:stom_club/constants/titles.dart';
import 'package:path/path.dart';

class ChatMessageBarWidget extends StatefulWidget {
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final Function(String) onChanged;
  final Function(String, String) didReturnValue;
  final VoidCallback onSendTap;

  const ChatMessageBarWidget({
    Key? key,
    required this.textEditingController,
    required this.onChanged,
    required this.focusNode,
    required this.didReturnValue,
    required this.onSendTap,
  }) : super(key: key);

  @override
  _ChatMessageBarState createState() => _ChatMessageBarState();
}

class _ChatMessageBarState extends State<ChatMessageBarWidget> {
  File? _file;
  XFile? _xFile;
  String? _filePath;
  String? _fileName;

  void _openSystemFolder() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      if (result.files.single.path != null) {
        _file = File(result.files.single.path!);

        if (_file != null) {
          _filePath = _file!.path;
          _fileName = basename(_file!.path);

          if (_filePath != null && _fileName != null) {
            widget.didReturnValue(_filePath!, _fileName!);
          }
        }

        setState(() => {});
      }
    }
  }

  void _openGallery() async {
    _xFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (mounted) {
      if (_xFile != null) {
        _filePath = _xFile!.path;
        _fileName = basename(_xFile!.path);

        if (_filePath != null && _fileName != null) {
          widget.didReturnValue(_filePath!, _fileName!);
        }

        setState(() => {});
      }
    }
  }

  void _showAlert(BuildContext context) {
    showMaterialModalBottomSheet(
        barrierColor: Colors.black.withOpacity(0.5),
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => ActionSheetWidget(
                actions: [
                  Titles.file,
                  Titles.image,
                ],
                onIndexTap: (index) =>
                    index == 0 ? _openSystemFolder() : _openGallery()));
  }

  @override
  Widget build(BuildContext context) {
    final _padding = MediaQuery.of(context).padding;

    return Align(
        alignment: Alignment.bottomCenter,
        child: Wrap(children: [
          Align(
              alignment: Alignment.topCenter,
              child: Column(children: [
                Container(
                  height: 1.0,
                  color: HexColors.separator,
                ),
                Container(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 20.0, top: 8.0),
                    margin: EdgeInsets.only(
                        bottom: DeviceDetector().isLarge()
                            ? _padding.bottom > 0.0
                                ? _padding.bottom
                                : 8.0
                            : 12.0),
                    color: HexColors.gray,
                    child: Row(children: [
                      /// CLIP BUTTON
                      Material(
                          color: Colors.transparent,
                          child: InkWell(
                              onTap: () => _showAlert(context),
                              borderRadius: BorderRadius.circular(22.0),
                              child: Image.asset('assets/ic_attach.png',
                                  width: 40.0, height: 40.0))),

                      /// MESSAGE INPUT
                      Expanded(
                          child: Container(
                              constraints:
                                  const BoxConstraints(maxHeight: 90.0),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              decoration: BoxDecoration(
                                  color: HexColors.white,
                                  border: Border.all(
                                      width: 1.0, color: HexColors.separator),
                                  borderRadius: BorderRadius.circular(16.0)),
                              child: TextFormField(
                                  maxLength: 256,
                                  keyboardAppearance: Brightness.light,
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  controller: widget.textEditingController,
                                  focusNode: widget.focusNode,
                                  cursorColor: HexColors.selected,
                                  textInputAction: TextInputAction.done,
                                  onChanged: (text) => widget.onChanged(text),
                                  onEditingComplete: () =>
                                      FocusScope.of(context).unfocus(),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(
                                        left: 12.0,
                                        top: 6.0,
                                        bottom: 6.0,
                                        right: 12.0),
                                    counterText: '',
                                    hintText: Titles.write,
                                    hintStyle: TextStyle(
                                        color: HexColors.subtitle,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.0),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                      borderSide: const BorderSide(
                                        color: Colors.transparent,
                                        width: 0.0,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                      borderSide: const BorderSide(
                                        color: Colors.transparent,
                                        width: 0.0,
                                      ),
                                    ),
                                  ),
                                  style: TextStyle(
                                      color: HexColors.black,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.0)))),
                      const SizedBox(width: 4.0),

                      /// SEND MESSAGE BUTTON
                      IgnorePointer(
                          ignoring:
                              // false,
                              widget.textEditingController.text.isEmpty,
                          child: InkWell(
                              onTap: () => widget.onSendTap(),
                              borderRadius: BorderRadius.circular(20.0),
                              child: Opacity(
                                  opacity:
                                      widget.textEditingController.text.isEmpty
                                          ? 0.5
                                          : 1.0,
                                  child: Image.asset(
                                      'assets/ic_send_message.png',
                                      width: 40.0,
                                      height: 40.0,
                                      fit: BoxFit.cover))))
                    ]))
              ]))
        ]));
  }
}
