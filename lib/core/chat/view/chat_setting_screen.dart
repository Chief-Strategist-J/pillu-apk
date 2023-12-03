import 'package:example/common/common_controller.dart';
import 'package:example/core/chat/chat_api.dart';
import 'package:example/core/chat/view/send_email_screen.dart';
import 'package:example/core/chat/model/register_response.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class ChatSettingScreen extends StatelessWidget {
  final RegisterResponse? userData;
  final String roomID;

  const ChatSettingScreen({super.key, this.userData, required this.roomID});

  String get userImage {
    if (userData != null) {
      if (userData!.data != null) {
        if (userData!.data!.userProfile != null) {
          return userData!.data!.userProfile!.photoUrl.validate();
        } else {
          return '';
        }
      } else {
        return '';
      }
    } else {
      return '';
    }
  }

  String get userEmail {
    if (userData != null) {
      if (userData!.data != null) {
        if (userData!.data!.userProfile != null) {
          return userData!.data!.userProfile!.email.validate();
        } else {
          return '';
        }
      } else {
        return '';
      }
    } else {
      return '';
    }
  }

  String get userDisplayName {
    if (userData != null) {
      if (userData!.data != null) {
        if (userData!.data!.userProfile != null) {
          return userData!.data!.userProfile!.userName.validate();
        } else {
          return '';
        }
      } else {
        return '';
      }
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('Chat Settings', elevation: 0),
      body: AnimatedScrollView(
        padding: EdgeInsets.all(16),
        listAnimationType: ListAnimationType.None,
        mainAxisSize: MainAxisSize.min,
        physics: BouncingScrollPhysics(),
        onSwipeRefresh: () {
          toast("value");
          return Future(() => false);
        },
        children: [
          16.height,
          if (userImage.isNotEmpty)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(radius: context.width() * 0.2, backgroundImage: NetworkImage(userImage)),
                  16.height,
                  Text(userDisplayName.capitalizeEachWord(), style: boldTextStyle(size: 24)),
                  Text(userEmail, style: secondaryTextStyle()),
                  8.height,
                  Divider(),
                  8.height,
                ],
              ),
            ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () async {
              SendEmailScreen(userEmail: userEmail).launch(context);
            },
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              iconColor: Colors.black,
              title: Text("Send Email", style: primaryTextStyle()),
              leading: IconButton(
                icon: Icon(Icons.outgoing_mail),
                style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.white)),
                onPressed: () async {
                  //
                },
              ),
              trailing: IconButton(
                icon: Icon(Icons.arrow_right),
                onPressed: () {
                  //
                },
              ),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            iconColor: Colors.black,
            title: Text("Send Payment", style: primaryTextStyle()),
            leading: IconButton(
              icon: Icon(Icons.send_rounded),
              style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.white)),
              onPressed: () {
                toast("Under construction");
              },
            ),
            trailing: IconButton(
              icon: Icon(Icons.arrow_right),
              onPressed: () {
                toast("Under construction");
              },
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            iconColor: Colors.black,
            title: Text("Request Payment", style: primaryTextStyle()),
            leading: IconButton(
              icon: Icon(Icons.account_balance_wallet_rounded),
              style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.white)),
              onPressed: () {
                toast("Under construction");
              },
            ),
            trailing: IconButton(
              icon: Icon(Icons.arrow_right),
              onPressed: () {
                toast("Under construction");
              },
            ),
          ),
          8.height,
          Divider(),
          8.height,
          ListTile(
            contentPadding: EdgeInsets.zero,
            iconColor: Colors.black,
            title: Text("Chat Lock", style: primaryTextStyle()),
            leading: IconButton(
              icon: Icon(Icons.lock),
              style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.white)),
              onPressed: () {
                toast("Under construction");
              },
            ),
            trailing: IconButton(
              icon: Icon(Icons.arrow_right),
              onPressed: () {
                toast("Under construction");
              },
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () async {
              await showConfirmDialogCustom(
                context,
                dialogType: DialogType.DELETE,
                onAccept: (p0) async {
                  Provider.of<CommonController>(context, listen: false).setLoading(true);
                  try {
                    await clearChat(roomID);
                    Provider.of<CommonController>(context, listen: false).setLoading(false);
                  } on Exception catch (e) {
                    Provider.of<CommonController>(context, listen: false).setLoading(false);
                  }
                },
              );
            },
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              iconColor: Colors.black,
              title: Text("Clear Chat", style: primaryTextStyle()),
              leading: IconButton(
                icon: Icon(Icons.outgoing_mail),
                style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.white)),
                onPressed: () async {
                  //
                },
              ),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            iconColor: Colors.redAccent,
            title: Text("Block User", style: primaryTextStyle(color: Colors.redAccent)),
            leading: IconButton(
              icon: Icon(Icons.block_rounded),
              style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.white)),
              onPressed: () {
                //
              },
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            iconColor: Colors.redAccent,
            title: Text("Report", style: primaryTextStyle(color: Colors.redAccent)),
            leading: IconButton(
              icon: Icon(Icons.report_rounded),
              style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.white)),
              onPressed: () {
                //
              },
            ),
          ),
        ],
      ),
    );
  }
}
