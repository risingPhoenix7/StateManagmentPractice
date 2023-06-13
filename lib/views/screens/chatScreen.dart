import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/message.dart';
import '../../models/user.dart';
import '../../viewmodel/chatBloc.dart';
import '../../viewmodel/chatState.dart';
import '../widgets/chatMessage.dart';
import '../widgets/customTextField.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({super.key, required this.isLeft});

  bool isLeft;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> messages = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ChatBloc chatBloc = BlocProvider.of<ChatBloc>(context);
    User otherUser = chatBloc.getUserDetails(!widget.isLeft);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight), // This is the default AppBar height
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey,
                width: 0.5,
              ),
            ),
          ),
          child: Row(children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.arrow_back, size: 24),
                    // Custom back button without padding
                    CircleAvatar(
                      backgroundImage: AssetImage(otherUser.profilePic),
                    ),
                  ],
                ),
              ),
            ),
            Text(otherUser.name, style: Theme.of(context).textTheme.headline6!),
          ]),
        ),
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is MessagesUpdated) {
            messages = state.messages;
          }
          return Column(children: <Widget>[
            Flexible(
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(8.0),
                itemBuilder: (_, int index) {
                  int actualIndex = messages.length - 1 - index;
                  return ChatMessageWidget(
                    message: messages[actualIndex],
                    isLeft: messages[actualIndex].isLeft != widget.isLeft,
                    isFirstMessage: actualIndex == 0 ||
                        messages[actualIndex].dateTime.day !=
                            messages[actualIndex - 1].dateTime.day,
                  );
                },
                itemCount: messages.length,
              ),
            ),
            const Divider(height: 1.0),
            Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Theme.of(context).cardColor),
                child: CustomTextField(isLeft: widget.isLeft)),
          ]);
        },
      ),
    );
  }
}
