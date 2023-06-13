import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jio_task/models/user.dart';

import '../../models/message.dart';
import '../../viewmodel/chatBloc.dart';
import '../../viewmodel/chatState.dart';
import 'chatScreen.dart';

class ViewChatsPage extends StatefulWidget {
  const ViewChatsPage({Key? key}) : super(key: key);

  @override
  State<ViewChatsPage> createState() => _ViewChatsPageState();
}

class _ViewChatsPageState extends State<ViewChatsPage> {
  @override
  void initState() {
    BlocProvider.of<ChatBloc>(context).loadMessagesFromJson();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is MessagesUpdated) {
            return const Column(children: [
              ChatMessageWidget(isLeft: true),
              ChatMessageWidget(isLeft: false)
            ]);
          }
          return const SizedBox(
              width: 50, height: 50, child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class ChatMessageWidget extends StatelessWidget {
  final bool isLeft;

  const ChatMessageWidget({Key? key, required this.isLeft}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChatBloc chatBloc = BlocProvider.of<ChatBloc>(context);
    User otherUser = chatBloc.getUserDetails(!isLeft);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: chatBloc,
              child: ChatScreen(isLeft: isLeft),
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: AssetImage(otherUser.profilePic),
              radius: 30,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    otherUser.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  // Space between name and message
                  BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
                    Message lastMessage = chatBloc.getLastMessage();
                    return Row(
                      children: [
                        Text(
                          "${lastMessage.isLeft != isLeft ? otherUser.name : 'You'}: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700]),
                        ),
                        Expanded(
                          child: Text(
                            lastMessage.text,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
            BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
              Message lastMessage = chatBloc.getLastMessage();
              return Text(
                DateFormat('h:mm a').format(lastMessage.dateTime),
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              );
            }),
          ],
        ),
      ),
    );
  }
}
