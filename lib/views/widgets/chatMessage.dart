import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jio_task/models/message/message.dart';
import 'package:jio_task/models/user/user.dart';
import 'package:jio_task/viewmodel/chatEvent.dart';
import 'package:jio_task/viewmodel/chatState.dart';
import 'package:jio_task/views/widgets/draggableWidget.dart';

import '../../viewmodel/chatBloc.dart';

class ChatMessageWidget extends StatefulWidget {
  const ChatMessageWidget(
      {super.key,
      required this.message,
      required this.isLeft,
      required this.indexInList,
      required this.isFirstMessage});

  final Message message;
  final bool isLeft;
  final bool isFirstMessage;
  final int indexInList;

  @override
  State<ChatMessageWidget> createState() => _ChatMessageWidgetState();
}

class _ChatMessageWidgetState extends State<ChatMessageWidget> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    ChatBloc chatBloc = BlocProvider.of<ChatBloc>(context);
    User sentUser = chatBloc.getUserDetails(widget.message.isLeft);
    String formattedDate = DateFormat.yMMMd().format(widget.message.dateTime);
    String formattedTime = DateFormat.Hm().format(widget.message.dateTime);

    return BlocBuilder<ChatBloc, ChatState>(buildWhen: (previous, current) {
      if (current is UnSelectAllMessages) {
        isSelected = false;
        return true;
      }
      return false;
    }, builder: (context, state) {
      return Container(
        color: isSelected ? const Color(0xFFa6d0de) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Column(
            children: [
              widget.isFirstMessage
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(formattedDate,
                          style: Theme.of(context).textTheme.subtitle2),
                    )
                  : Container(),
              DraggableWidget(
                onSwipe: () {
                  chatBloc.add(MessageReply(
                      messageIndex: widget.indexInList, isLeft: widget.isLeft));
                },
                child: GestureDetector(
                  onLongPress: () {
                    setState(() {
                      isSelected = true;
                    });
                    chatBloc.add(MessageLongPressed(
                        messageIndex: widget.indexInList,
                        isLeft: widget.isLeft));
                  },
                  onLongPressCancel: () {
                    setState(() {
                      isSelected = false;
                    });
                    chatBloc.add(MessageLongPressedDisabled(
                        messageIndex: widget.indexInList));
                  },
                  child: Row(
                    mainAxisAlignment: widget.isLeft != widget.message.isLeft
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      widget.isLeft != widget.message.isLeft
                          ? CircleAvatar(
                              radius: 15,
                              backgroundImage: NetworkImage(sentUser.profilePic),
                            )
                          : Container(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.isLeft != widget.message.isLeft
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(sentUser.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.purple)),
                                )
                              : Container(),
                          Card(
                            color: widget.isLeft == widget.message.isLeft
                                ? const Color(0xFFe7ffdb)
                                : Colors.white,
                            elevation: 3.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(
                                  color: Colors.grey,
                                  width: !widget.isLeft ? 0 : 0.5),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  widget.message.replyToIndex != null
                                      ? InkWell(
                                          onTap: () {
                                            chatBloc.add(GoToIndex(
                                                index: widget
                                                    .message.replyToIndex!,
                                                isLeft: widget.isLeft));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10.0),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              decoration: const BoxDecoration(
                                                border: Border(
                                                  left: BorderSide(
                                                      color: Colors.purple,
                                                      width: 3.0),
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    chatBloc
                                                        .getUserDetails(chatBloc
                                                            .messages[widget
                                                                .message
                                                                .replyToIndex!]
                                                            .isLeft)
                                                        .name,
                                                    style: const TextStyle(
                                                        color: Colors.purple),
                                                  ),
                                                  Text(
                                                    chatBloc
                                                        .messages[widget.message
                                                            .replyToIndex!]
                                                        .text,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  Text(widget.message.text),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Text(
                                        formattedTime,
                                        style: const TextStyle(
                                            fontSize: 10.0, color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
