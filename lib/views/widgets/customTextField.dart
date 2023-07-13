import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jio_task/viewmodel/chatBloc.dart';
import 'package:flutter/foundation.dart' as foundation;
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
  bool emojiShowing = false;
  final key = GlobalKey<EmojiPickerState>();
  FocusNode focusNode = FocusNode();

  final TextEditingController _textController = TextEditingController();

  _onBackspacePressed() {
    _textController
      ..text = _textController.text.characters.toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _textController.text.length));
  }

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
    focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).primaryColor),
      child: Column(
        children: [
          BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
            if (state is ReplyModeEnabled && state.isLeft == widget.isLeft) {
              return Container(
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
                Container(
                  child: IconButton(
                      icon: const Icon(Icons.emoji_emotions),
                      onPressed: () {
                        setState(() {
                          if (emojiShowing) {
                            emojiShowing = false;
                            FocusScope.of(context).requestFocus(focusNode);
                          } else {
                            emojiShowing = true;
                            focusNode.unfocus();
                            focusNode.canRequestFocus = true;
                          }
                        });
                      }),
                ),
                Flexible(
                  child: TextField(
                    focusNode: focusNode,
                    controller: _textController,
                    maxLines: null,
                    onChanged: (String text) {
                      setState(() {
                        _isComposing = text.isNotEmpty;
                      });
                    },
                    onTap: () {
                      setState(() {
                        emojiShowing = false;
                        FocusScope.of(context).requestFocus(focusNode);
                      });
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      // Remove default bottom underline
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
          Offstage(
            offstage: !emojiShowing,
            child: SizedBox(
                height: 250,
                child: EmojiPicker(
                  key: key,
                  textEditingController: _textController,
                  onBackspacePressed: _onBackspacePressed,
                  config: Config(
                    columns: 7,
                    emojiSizeMax: 32 *
                        (foundation.defaultTargetPlatform == TargetPlatform.iOS
                            ? 1.30
                            : 1.0),
                    verticalSpacing: 0,
                    horizontalSpacing: 0,
                    gridPadding: EdgeInsets.zero,
                    initCategory: Category.RECENT,
                    bgColor: const Color(0xFFF2F2F2),
                    indicatorColor: Colors.blue,
                    iconColor: Colors.grey,
                    iconColorSelected: Colors.blue,
                    backspaceColor: Colors.blue,
                    skinToneDialogBgColor: Colors.white,
                    skinToneIndicatorColor: Colors.grey,
                    enableSkinTones: true,
                    recentTabBehavior: RecentTabBehavior.RECENT,
                    recentsLimit: 28,
                    replaceEmojiOnLimitExceed: false,
                    noRecents: const Text(
                      'No Recents',
                      style: TextStyle(fontSize: 20, color: Colors.black26),
                      textAlign: TextAlign.center,
                    ),
                    loadingIndicator: const SizedBox.shrink(),
                    tabIndicatorAnimDuration: kTabScrollDuration,
                    categoryIcons: const CategoryIcons(),
                    buttonMode: ButtonMode.MATERIAL,
                    checkPlatformCompatibility: true,
                  ),
                )),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
