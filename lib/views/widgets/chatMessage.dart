import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jio_task/models/message.dart';
import 'package:jio_task/models/user.dart';

import '../../viewmodel/chatBloc.dart';

class ChatMessageWidget extends StatelessWidget {
  const ChatMessageWidget(
      {super.key,
      required this.message,
      required this.isLeft,
      required this.isFirstMessage});

  final Message message;
  final bool isLeft;
  final bool isFirstMessage;

  @override
  Widget build(BuildContext context) {
    ChatBloc chatBloc = BlocProvider.of<ChatBloc>(context);
    User sentUser = chatBloc.getUserDetails(message.isLeft);
    String formattedDate = DateFormat.yMMMd().format(message.dateTime);
    String formattedTime = DateFormat.Hm().format(message.dateTime);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        children: [
          isFirstMessage
              ? Text(formattedDate,
                  style: Theme.of(context).textTheme.subtitle2)
              : Container(),
          Row(
            mainAxisAlignment:
                isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              isLeft
                  ? CircleAvatar(
                      radius: 15,
                backgroundImage : AssetImage(sentUser.profilePic),
                    )
                  : Container(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isLeft
                      ? Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(sentUser.name,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        )
                      : Container(),
                  Card(
                    color: !isLeft ? Color(0xFFe7ffdb) : Colors.white,
                    elevation: 3.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(
                          color: Colors.grey, width: !isLeft ? 0 : 0.5),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(message.text),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                formattedTime,
                                style: TextStyle(
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
        ],
      ),
    );
  }
}
