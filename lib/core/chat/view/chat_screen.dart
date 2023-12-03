import 'package:example/common/common_controller.dart';
import 'package:example/common/theme_data.dart';
import 'package:example/core/auth/auth_api.dart';
import 'package:example/core/chat/chat_api.dart';
import 'package:example/core/chat/model/register_response.dart';
import 'package:example/core/chat/model/register_user_model.dart';
import 'package:example/core/chat/view/chat_setting_screen.dart';
import 'package:example/firebase_chat_core/lib/flutter_firebase_chat_core.dart';
import 'package:example/model/src/message.dart';
import 'package:example/model/src/user.dart';
import 'package:example/ui/flutter_chat_ui.dart';

import 'package:flutter/material.dart';

import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../../model/src/room.dart';

class ChatPage extends StatefulWidget {
  final User otherUser;
  final Room room;

  ChatPage({super.key, required this.room, required this.otherUser});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  RegisterResponse registerResponse = RegisterResponse();

  String get getRoomId => widget.room.id;

  @override
  void initState() {
    super.initState();
    init();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> init() async {
    registerResponse = await getUserInfo(firebaseUserId: widget.otherUser.id);
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      updateUserCollection(RegisterUserModel.getUserUID(), {'isActive': true});
    }
    if (state == AppLifecycleState.inactive) {
      updateUserCollection(RegisterUserModel.getUserUID(), {'isActive': false});
    }
  }

  DefaultChatTheme getLightChatTheme(BuildContext context) {
    return DefaultChatTheme(
      primaryColor: context.primaryColor,
      inputTextColor: context.cardColor,
      attachmentButtonIcon: Icon(Icons.add, color: context.cardColor),
      sendButtonIcon: Icon(Icons.send, color: context.cardColor),
      inputMargin: EdgeInsets.only(left: 4, bottom: 2, right: 4),
      inputBorderRadius: BorderRadius.circular(PilluThemeData.globalActiveButtonRadius),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        'Chat',
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              ChatSettingScreen(userData: registerResponse, roomID: getRoomId).launch(context);
            },
          ),
        ],
      ),
      body: StreamBuilder<Room>(
        initialData: widget.room,
        stream: FirebaseChatCore.instance.room(getRoomId),
        builder: (context, snapshot) {
          return StreamBuilder<List<Message>>(
            initialData: const [],
            stream: FirebaseChatCore.instance.messages(snapshot.data!),
            builder: (context, snapshot) {
              return Theme(
                data: ThemeData(),
                child: Selector<CommonController, bool>(
                  selector: (context, provider) => provider.isLoading,
                  builder: (context, value, child) {
                    return Chat(
                      isAttachmentUploading: value,
                      messages: snapshot.data ?? [],
                      l10n: ChatL10nEn(inputPlaceholder: 'Message', emptyChatPlaceholder: ''),
                      theme: getLightChatTheme(context),
                      user: User(id: FirebaseChatCore.instance.firebaseUser?.uid ?? ''),
                      onAttachmentPressed: () {
                        handleAttachmentPressed(context, getRoomId);
                      },
                      onMessageTap: (context, message) {
                        handleMessageTap(context, message, getRoomId);
                      },
                      onPreviewDataFetched: (message, previewData) {
                        handlePreviewDataFetched(message, previewData, getRoomId);
                      },
                      onSendPressed: (message) async {
                        if (registerResponse.data != null) {
                          if (registerResponse.data!.onesignalUserProfile != null) {
                            String notificationID = registerResponse.data!.onesignalUserProfile!.onesignalSubscriptionId.validate();
                            await handleSendPressed(
                              message,
                              roomID: getRoomId,
                              otherUserId: widget.otherUser.id,
                              notificationID: notificationID,
                            );
                          }
                        }
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
