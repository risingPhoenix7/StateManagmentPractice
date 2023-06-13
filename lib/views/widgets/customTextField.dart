import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jio_task/viewmodel/chatBloc.dart';

import '../../models/message.dart';
import '../../viewmodel/chatEvent.dart';

class CustomTextField extends StatefulWidget {
  CustomTextField({Key? key, required this.isLeft}) : super(key: key);
  bool isLeft;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isComposing = false;
  final TextEditingController _textController = TextEditingController();

  void _handleSubmitted(BuildContext context) {
    final bloc = BlocProvider.of<ChatBloc>(context);
    bloc.add(NewMessage(
        message: Message(
      isLeft: widget.isLeft,
      text: _textController.text,
      dateTime: DateTime.now(),
    )));
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).primaryColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                maxLines: null,
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.isNotEmpty;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Send a message',
                  contentPadding: EdgeInsets.all(20.0),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed:
                      _isComposing ? () => _handleSubmitted(context) : null),
            ),
          ],
        ),
      ),
    );
  }
}
