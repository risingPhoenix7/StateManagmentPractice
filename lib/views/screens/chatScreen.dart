import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jio_task/viewmodel/chatEvent.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../models/message/message.dart';
import '../../models/user/user.dart';
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
    messages = BlocProvider.of<ChatBloc>(context).getMessages();
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
    ItemScrollController itemScrollController = ItemScrollController();

    return WillPopScope(
      onWillPop: () async {
        if (chatBloc.editingMessageIndices.isNotEmpty) {
          chatBloc.add(RemoveAllLongPressed());
          return false;
        }
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            // This is the default AppBar height
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                ),
              ),
              child: BlocBuilder<ChatBloc, ChatState>(
                  buildWhen: (previous, current) =>
                      current is ShowDeleteDialog ||
                      current is DisableDeleteDialog,
                  builder: (context, state) {
                    print("delete rebuild");
                    if (state is ShowDeleteDialog) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    chatBloc.add(RemoveAllLongPressed());
                                  },
                                  icon: const Icon(Icons.close)),
                              Text(otherUser.name,
                                  style:
                                      Theme.of(context).textTheme.headline6!),
                            ],
                          ),
                          IconButton(
                              onPressed: () {
                                chatBloc.add(DeleteMessages(isLeft: widget.isLeft));
                              },
                              icon: const Icon(Icons.delete))
                        ],
                      );
                    } else {
                      return Row(children: [
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
                                  backgroundImage:
                                      NetworkImage(otherUser.profilePic),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Text(otherUser.name,
                            style: Theme.of(context).textTheme.headline6!),
                      ]);
                    }
                  }),
            ),
          ),
          body: BlocBuilder<ChatBloc, ChatState>(
            buildWhen: (previous, current) =>
                current is MessagesUpdated || current is ScrollToIndex,
            builder: (context, state) {
              if (state is MessagesUpdated) {
                messages = state.messages;
                try {
                  itemScrollController.scrollTo(
                      index: 0,
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOutCubic);
                } catch (e) {
                  print(e);
                }
              } else if (state is ScrollToIndex &&
                  state.isLeft == widget.isLeft) {
                print("Scrolling to index ${state.index}");
                try {
                  itemScrollController.scrollTo(
                      index: messages.length - state.index - 1,
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOutCubic);
                } catch (e) {
                  print(e);
                }
              }
              return Column(children: <Widget>[
                Flexible(
                    child: messages.isNotEmpty
                        ? ScrollablePositionedList.builder(
                            itemCount: messages.length,
                            physics: const BouncingScrollPhysics(),
                            itemScrollController: itemScrollController,
                            reverse: true,
                            padding: const EdgeInsets.all(8.0),
                            itemBuilder: (_, int index) {
                              print("Index: $index");
                              int actualIndex = messages.length - 1 - index;
                              print(actualIndex);
                              return ChatMessageWidget(
                                message: messages[actualIndex],
                                indexInList: index,
                                isLeft: widget.isLeft,
                                isVisible: widget.isLeft
                                    ? !messages[actualIndex].deletedByLeft
                                    : !messages[actualIndex].deletedByRight,
                                isFirstMessage: actualIndex == 0 ||
                                    ((messages[actualIndex].dateTime.day !=
                                            messages[actualIndex - 1]
                                                .dateTime
                                                .day) ||
                                        (messages[actualIndex].dateTime.month !=
                                            messages[actualIndex - 1]
                                                .dateTime
                                                .month) ||
                                        (messages[actualIndex].dateTime.year !=
                                            messages[actualIndex - 1]
                                                .dateTime
                                                .year)),
                              );
                            },
                          )
                        : Container(
                            alignment: Alignment.center,
                            child: Text("No messages yet"),
                          )),
                const Divider(height: 1.0),
                Container(
                    width: MediaQuery.of(context).size.width,
                    decoration:
                        BoxDecoration(color: Theme.of(context).cardColor),
                    child: CustomTextField(isLeft: widget.isLeft)),
              ]);
            },
          ),
        ),
      ),
    );
  }
}
