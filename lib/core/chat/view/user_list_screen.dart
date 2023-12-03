import 'package:example/common/component/app_loader.dart';
import 'package:example/core/chat/chat_api.dart';
import 'package:example/core/chat/model/register_user_model.dart';
import 'package:example/core/chat/view/profile_screen.dart';
import 'package:example/core/setting/view/setting_screen.dart';
import 'package:example/core/util/util.dart';
import 'package:example/firebase_chat_core/lib/flutter_firebase_chat_core.dart';
import 'package:example/model/src/user.dart' as user;
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        updateUserCollection(RegisterUserModel.getUserUID(), {'isActive': true});
        break;
      case AppLifecycleState.inactive:
        updateUserCollection(RegisterUserModel.getUserUID(), {'isActive': false});
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
      case AppLifecycleState.paused:
        break;
    }
  }

  Widget _buildAvatar(user.User user) {
    final color = getUserAvatarNameColor(user);
    final hasImage = user.imageUrl != null;
    final name = getUserName(user);

    return Builder(builder: (context) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          ProfileScreen(user: user).launch(context);
        },
        child: CircleAvatar(
          radius: 20,
          backgroundColor: hasImage ? Colors.transparent : color,
          backgroundImage: hasImage ? NetworkImage(user.imageUrl!) : null,
          child: !hasImage ? Text(name.isEmpty ? '' : name[0].toUpperCase(), style: primaryTextStyle(color: Colors.white)) : null,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('Users', elevation: 0, showBack: false),
      body: Stack(
        children: [
          StreamBuilder<List<user.User>>(
            stream: FirebaseChatCore.instance.users(),
            initialData: const [],
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(bottom: 200),
                  child: const Text('No users'),
                );
              }

              return AnimatedListView(
                listAnimationType: ListAnimationType.None,
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final user = snapshot.data![index];

                  return Container(
                    padding: EdgeInsets.all(8),
                    color: context.cardColor,
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        launchChat(user, context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildAvatar(user),
                          8.width,
                          CircleAvatar(minRadius: 2, maxRadius: 2, backgroundColor: isActiveColor(user)),
                          6.width,
                          Text(getUserName(user), style: boldTextStyle(size: 14)),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          AppLoader(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: context.primaryColor,
        onTap: (value) {
          if (value == 1) {
            SettingScreen().launch(context);
          }
        },
      ),
    );
  }

  MaterialColor isActiveColor(user.User user) => (user.isActive.validate()) ? Colors.green : Colors.red;
}
