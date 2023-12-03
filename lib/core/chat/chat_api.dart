import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/common/common_controller.dart';
import 'package:example/core/chat/view/chat_screen.dart';
import 'package:example/core/util/service/network/onsignal_api.dart';
import 'package:example/firebase_chat_core/lib/flutter_firebase_chat_core.dart';
import 'package:example/model/src/message.dart';
import 'package:example/model/src/messages/file_message.dart';
import 'package:example/model/src/messages/partial_file.dart';
import 'package:example/model/src/messages/partial_image.dart';
import 'package:example/model/src/messages/partial_text.dart';
import 'package:example/model/src/messages/text_message.dart';
import 'package:example/model/src/preview_data.dart';
import 'package:example/model/src/user.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

FirebaseChatCoreConfig config = const FirebaseChatCoreConfig(null, 'rooms', 'users');

CommonController common(BuildContext context) => Provider.of<CommonController>(context, listen: false);

FirebaseFirestore getFirebaseFirestore() {
  if (config.firebaseAppName != null) {
    return FirebaseFirestore.instanceFor(app: Firebase.app(config.firebaseAppName!));
  } else {
    return FirebaseFirestore.instance;
  }
}

void launchChat(User otherUser, BuildContext context) async {
  common(context).setLoading(true);

  try {
    await FirebaseChatCore.instance.createRoom(otherUser).then((value) {
      ChatPage(room: value, otherUser: otherUser).launch(context);
      common(context).setLoading(false);
    }).catchError((e) {
      common(context).setLoading(false);
      toast("Something Went Wrong");
    });
  } on Exception catch (e) {
    common(context).setLoading(false);
    toast("Something Went Wrong");
  }
}

Future<void> updateUserCollection(String userId, Map<String, dynamic> request) async {
  try {
    await getFirebaseFirestore().collection(config.usersCollectionName).doc(userId).update(request).then((value) {
      log('USER-ID - $userId');
    }).catchError((e) {
      log('Something went wrong - $e');
    });
  } on Exception catch (e) {
    log('Something went wrong - $e');
  }
}

Future<void> clearChat(String roomID) async {
  QuerySnapshot<Map<String, dynamic>> docs = await getFirebaseFirestore().collection(config.roomsCollectionName).doc(roomID).collection('messages').get();

  for (QueryDocumentSnapshot doc in docs.docs) {
    await doc.reference.delete();
  }
}

Future<T?> getUserCollectionDetail<T>(String userId, String key) async {
  DocumentSnapshot<Map<String, dynamic>> mapData = await getFirebaseFirestore().collection(config.usersCollectionName).doc(userId).get();
  return mapData.data()?['key'] as T;
}

void handlePreviewDataFetched(TextMessage message, PreviewData previewData, String roomID) {
  final updatedMessage = message.copyWith(previewData: previewData);
  FirebaseChatCore.instance.updateMessage(updatedMessage, roomID);
}

Future<void> handleSendPressed(
  PartialText message, {
  required String otherUserId,
  required String roomID,
  required String notificationID,
}) async {
  try {
    FirebaseChatCore.instance.sendMessage(message, roomID);

    await getUserCollectionDetail<bool?>(otherUserId, 'isActive').then((isActive) {
      if (!isActive.validate()) {
        notificationMessage(id: notificationID, message: message.text);
      }
    });
  } on Exception catch (e) {
    log('Error: $e');
  }
}

void handleMessageTap(BuildContext _, Message message, String roomID) async {
  if (message is FileMessage) {
    var localPath = message.uri;

    if (message.uri.startsWith('http')) {
      try {
        final updatedMessage = message.copyWith(isLoading: true);

        FirebaseChatCore.instance.updateMessage(updatedMessage, roomID);

        final client = http.Client();
        final request = await client.get(Uri.parse(message.uri));

        final bytes = request.bodyBytes;
        final documentsDir = (await getApplicationDocumentsDirectory()).path;

        localPath = '$documentsDir/${message.name}';

        if (!File(localPath).existsSync()) {
          final file = File(localPath);
          await file.writeAsBytes(bytes);
        }
      } finally {
        final updatedMessage = message.copyWith(isLoading: false);
        FirebaseChatCore.instance.updateMessage(updatedMessage, roomID);
      }
    }

    await OpenFilex.open(localPath);
  }
}

void handleFileSelection(BuildContext context, String roomID) async {
  final result = await FilePicker.platform.pickFiles(type: FileType.any);

  if (result != null && result.files.single.path != null) {
    setAttachmentUploading(context, true);

    final name = result.files.single.name;
    final filePath = result.files.single.path!;
    final file = File(filePath);

    try {
      final reference = FirebaseStorage.instance.ref(name);

      await reference.putFile(file);

      final uri = await reference.getDownloadURL();
      final size = result.files.single.size;
      final mimeType = lookupMimeType(filePath);

      final message = PartialFile(mimeType: mimeType, name: name, size: size, uri: uri);

      FirebaseChatCore.instance.sendMessage(message, roomID);

      setAttachmentUploading(context, false);
    } finally {
      setAttachmentUploading(context, false);
    }
  }
}

void handleImageSelection(BuildContext context, String roomID) async {
  final result = await ImagePicker().pickImage(imageQuality: 70, maxWidth: 1440, source: ImageSource.gallery);

  if (result != null) {
    setAttachmentUploading(context, true);

    final file = File(result.path);

    final size = file.lengthSync();
    final bytes = await result.readAsBytes();
    final image = await decodeImageFromList(bytes);

    final name = result.name;

    try {
      final reference = FirebaseStorage.instance.ref(name);

      await reference.putFile(file);

      final uri = await reference.getDownloadURL();

      final message = PartialImage(name: name, size: size, uri: uri, width: image.width.toDouble(), height: image.height.toDouble());

      FirebaseChatCore.instance.sendMessage(message, roomID);
      setAttachmentUploading(context, false);
    } finally {
      setAttachmentUploading(context, false);
    }
  }
}

void handleAttachmentPressed(BuildContext context, String roomID) {
  showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                child: Align(alignment: Alignment.centerLeft, child: Text('Photo')),
                onPressed: () {
                  finish(context);
                  handleImageSelection(context, roomID);
                },
              ),
              TextButton(
                child: Align(alignment: Alignment.centerLeft, child: Text('File')),
                onPressed: () {
                  finish(context);
                  handleFileSelection(context, roomID);
                },
              ),
              TextButton(
                child: Align(alignment: Alignment.centerLeft, child: Text('Cancel')),
                onPressed: () {
                  finish(context);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

void setAttachmentUploading(BuildContext context, bool uploading) {
  common(context).setLoading(uploading);
}

void sendEmail({
  required String subject,
  required String body,
  required List<String> to,
  required List<String> cc,
  required List<String> bcc,
}) async {
  final Email email = Email(
    body: body,
    subject: subject,
    recipients: to,
    cc: cc,
    bcc: bcc,
  );
  await FlutterEmailSender.send(email);
}
