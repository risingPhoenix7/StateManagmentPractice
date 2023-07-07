import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jio_task/viewmodel/chatBloc.dart';

import '../../models/message/message.dart';
import '../../viewmodel/chatEvent.dart';
import '../../viewmodel/chatState.dart';

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
      replyToIndex: bloc.state is ReplyModeEnabled
          ? (bloc.state as ReplyModeEnabled).replyIndex
          : null,
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
      child: Column(
        children: [
          BlocBuilder<ChatBloc, ChatState>( builder: (context, state) {
            if (state is ReplyModeEnabled && state.isLeft == widget.isLeft) {
              return  Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 20.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        state.replyMessage.text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        BlocProvider.of<ChatBloc>(context)
                            .add(MessageReplyDisabled());
                      },
                    ),
                  ],
                ),
              );
            }
            return Container();
          }),
          Container(
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
                      onPressed: _isComposing
                          ? () => _handleSubmitted(context)
                          : null),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
