import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jio_task/constants/boxNames.dart';
import 'package:jio_task/models/message/message.dart';
import 'package:jio_task/viewmodel/chatBloc.dart';
import 'package:hive_flutter/adapters.dart';

import 'views/screens/viewChatsPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(MessageAdapter());
  await Hive.openBox<Message>(BoxNames.messageBox);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) {
          var chatBloc = ChatBloc();
          return chatBloc;
        },
        child: const ViewChatsPage(),
      ),
    );
  }
}
