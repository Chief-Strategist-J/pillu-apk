import 'package:example/common/component/button_component.dart';
import 'package:example/common/component/decoration.dart';
import 'package:example/core/chat/chat_api.dart';
import 'package:example/core/util/util.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class SendEmailScreen extends StatefulWidget {
  final String userEmail;

  SendEmailScreen({super.key, required this.userEmail});

  @override
  State<SendEmailScreen> createState() => _SendEmailScreenState();
}

class _SendEmailScreenState extends State<SendEmailScreen> {
  final TextEditingController subject = TextEditingController();

  final TextEditingController body = TextEditingController(text: emailTemplate);

  final TextEditingController cc = TextEditingController();

  final TextEditingController bcc = TextEditingController();

  List<String> ccList = [];

  List<String> bccList = [];

  void onBccAddedTap() {
    if (bcc.text.validateEmail()) {
      final currCc = bcc.text;
      bcc.clear();
      bccList.add(currCc);
      toast("Added to Bcc");
    } else {
      toast("Enter valid email");
    }
    setState(() {});
  }

  void onCcAddTap() {
    if (cc.text.validateEmail()) {
      final currCc = cc.text;
      cc.clear();
      ccList.add(currCc);
      toast("Added to Ccc");
    } else {
      toast("Enter valid email");
    }
    setState(() {});
  }

  void onBccRemoveTap(int p1) {
    bccList.remove(bccList[p1]);
    setState(() {});
  }

  void onCcRemoveTap(int p1) {
    ccList.remove(ccList[p1]);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('Send Email', elevation: 0),
      body: AnimatedScrollView(
        padding: EdgeInsets.all(16),
        children: [
          AppTextField(
            textFieldType: TextFieldType.EMAIL,
            controller: cc,
            textStyle: primaryTextStyle(size: 14),
            decoration: inputDecorationField(
              labelText: 'Cc',
              suffixIcon: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  onCcAddTap();
                },
              ),
            ),
          ),
          if (ccList.isNotEmpty)
            AnimatedScrollView(
              mainAxisSize: MainAxisSize.min,
              children: [
                4.height,
                AnimatedWrap(
                  itemCount: ccList.length,
                  itemBuilder: (p0, p1) {
                    return GestureDetector(
                      onTap: () {
                        onCcRemoveTap(p1);
                      },
                      child: Container(
                        margin: EdgeInsets.all(4),
                        padding: EdgeInsets.all(8),
                        decoration: boxDecorationWithRoundedCorners(
                          borderRadius: BorderRadius.circular(360),
                          border: Border.all(color: context.dividerColor, width: 0.2),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            8.width,
                            Text(ccList[p1]),
                            8.width,
                            CircleAvatar(
                              maxRadius: 10,
                              minRadius: 10,
                              child: Text('x', style: primaryTextStyle(size: 12, color: context.scaffoldBackgroundColor)).center(),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          16.height,
          AppTextField(
            textFieldType: TextFieldType.EMAIL,
            controller: bcc,
            textStyle: primaryTextStyle(size: 14),
            decoration: inputDecorationField(
              labelText: 'Bcc',
              suffixIcon: IconButton(
                onPressed: () {
                  onBccAddedTap();
                },
                icon: Icon(Icons.add),
              ),
            ),
          ),
          if (bccList.isNotEmpty)
            AnimatedScrollView(
              mainAxisSize: MainAxisSize.min,
              children: [
                4.height,
                AnimatedWrap(
                  itemCount: bccList.length,
                  itemBuilder: (p0, p1) {
                    return GestureDetector(
                      onTap: () {
                        onBccRemoveTap(p1);
                      },
                      child: Container(
                        margin: EdgeInsets.all(4),
                        padding: EdgeInsets.all(8),
                        decoration: boxDecorationWithRoundedCorners(
                          borderRadius: BorderRadius.circular(360),
                          border: Border.all(color: context.dividerColor, width: 0.2),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            8.width,
                            Text(bccList[p1]),
                            8.width,
                            CircleAvatar(
                              maxRadius: 10,
                              minRadius: 10,
                              child: Text(
                                'x',
                                style: primaryTextStyle(size: 12, color: context.scaffoldBackgroundColor),
                              ).center(),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          16.height,
          AppTextField(
            textFieldType: TextFieldType.MULTILINE,
            textStyle: primaryTextStyle(size: 14),
            textAlign: TextAlign.start,
            maxLines: 24,
            minLines: 24,
            controller: body,
            decoration: inputDecorationField(labelText: 'Body'),
          ),
          16.height,
          PilluButton(
            text: 'Send',
            onTap: () {
              sendEmail(subject: subject.text, body: body.text, to: [widget.userEmail], cc: ccList, bcc: bccList);
            },
          ),
        ],
      ),
    );
  }
}
