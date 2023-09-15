import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:stom_club/components/action_sheet_widget.dart';
import 'package:stom_club/components/default_button.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'package:stom_club/constants/titles.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';

class FileAttachmentViewWidget extends StatefulWidget {
  final String? attachment;
  final Function(String, String) didReturnValue;

  const FileAttachmentViewWidget(
      {Key? key, this.attachment, required this.didReturnValue})
      : super(key: key);

  @override
  _FileAttachmentViewState createState() => _FileAttachmentViewState();
}

class _FileAttachmentViewState extends State<FileAttachmentViewWidget> {
  File? _file;
  XFile? _xFile;
  String? _filePath;
  String? _fileName;

  @override
  void initState() {
    if (widget.attachment != null) _fileName = widget.attachment;

    super.initState();
  }

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
    return SizedBox.expand(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/ic_file.png',
                      width: 72.0,
                      height: 72.0,
                      fit: BoxFit.cover,
                      color: _fileName == null
                          ? HexColors.separator
                          : HexColors.selected),
                  const SizedBox(height: 12.0),
                  SizedBox(
                      height: 34.0,
                      child: Center(
                          child: Text(
                              _fileName == null
                                  ? '${Titles.document_attachment.substring(0, 28)}\n${Titles.document_attachment.substring(28, Titles.document_attachment.length)}'
                                  : _fileName!.length >= 18
                                      ? '...${_fileName!.substring(_fileName!.length - 16, _fileName!.length)}'
                                          .toUpperCase()
                                      : _fileName!.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14.0,
                                overflow: TextOverflow.ellipsis,
                                color: _fileName == null
                                    ? HexColors.black.withOpacity(0.5)
                                    : _fileName!.isEmpty
                                        ? HexColors.separator
                                        : HexColors.black,
                              )))),
                  const SizedBox(height: 30.0),

                  /// ATTACH BUTTON

                  DefaultButtonWidget(
                      isEnabled: true,
                      title: _fileName == null ? Titles.attach : Titles.change,
                      color: HexColors.white,
                      titleColor: HexColors.selected,
                      onTap: () => _showAlert(context)),
                  const SizedBox(height: 12.0),
                ])));
  }
}
