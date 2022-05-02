import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class RichTextQuillReadOnly extends StatefulWidget {
  final jsonDescription;
  RichTextQuillReadOnly({this.jsonDescription});

  @override
  State<RichTextQuillReadOnly> createState() => _RichTextQuillReadOnlyState();
}

class _RichTextQuillReadOnlyState extends State<RichTextQuillReadOnly> {
  QuillController _controller;
  FocusNode _focusNode = new FocusNode();
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = QuillController(
    document: Document.fromJson(widget.jsonDescription),
    selection: TextSelection.collapsed(offset: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: QuillEditor(
        controller: _controller,
        scrollController: ScrollController(),
        scrollable: true,
        focusNode: _focusNode,
        autoFocus: false,
        readOnly: true,
        expands: false,
        padding: EdgeInsets.zero,
        showCursor: false, // add this
      ),
    );
  }
}
