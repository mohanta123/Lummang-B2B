import 'dart:async';

import 'package:flutter/material.dart';

import 'package:my_store/functions/localizations.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final msgController = TextEditingController();
  DateTime now = DateTime.now();
  ScrollController _scrollController = new ScrollController();
  String amPm;
  int chatDataLength = 0;
  final chatData = [
    // {'role': 'sender', 'msg': 'Hello', 'time': '9:35 AM', 'read': 'read'},
    // {'role': 'me', 'msg': 'Hi', 'time': '9:36 AM', 'read': 'read'},
    // {
    //   'role': 'sender',
    //   'msg': 'How are you?',
    //   'time': '9:38 AM',
    //   'read': 'read'
    // },
    // {
    //   'role': 'me',
    //   'msg': 'I\'m fine. How are you?',
    //   'time': '9:38 AM',
    //   'read': 'unread'
    // },
  ];

  @override
  void initState() {
    super.initState();
    if (chatDataLength != 0) {
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300), curve: Curves.elasticOut);
    } else {
      Timer(Duration(milliseconds: 400), () => _scrollToBottom());
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    Locale myLocale = Localizations.localeOf(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          title: Text(
            AppLocalizations.of(context)
                .translate('chatPage', 'chatAppBarString'),
            style: TextStyle(
              fontFamily: 'Jost',
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              letterSpacing: 1.7,
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 15.0),
            Expanded(
              child: (chatDataLength == 0)
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/no_message.png',
                            width: 200.0,
                            fit: BoxFit.fitWidth,
                          ),
                          SizedBox(height: 20.0),
                          Padding(
                            padding: EdgeInsets.only(right: 20.0, left: 20.0),
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate('chatPage', 'noMessageString'),
                              style: TextStyle(
                                fontFamily: 'Jost',
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                letterSpacing: 1.7,
                                color:
                                    Theme.of(context).textTheme.headline6.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: chatData.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final item = chatData[index];
                        return Container(
                          width: width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: (item['role'] == 'sender')
                                ? CrossAxisAlignment.start
                                : CrossAxisAlignment.end,
                            children: <Widget>[
                              Wrap(
                                children: <Widget>[

                                    Padding(
                                      padding: (myLocale.languageCode == 'ar')
                                          ? (item['role'] == 'sender')
                                              ? EdgeInsets.only(left: 100.0)
                                              : EdgeInsets.only(right: 100.0)
                                          : (item['role'] == 'sender')
                                              ? EdgeInsets.only(right: 100.0)
                                              : EdgeInsets.only(left: 100.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            (item['role'] == 'sender')
                                                ? CrossAxisAlignment.start
                                                : CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.all(10.0),
                                            margin: EdgeInsets.only(
                                                left: 10.0, right: 10.0),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              color: (item['role'] == 'sender')
                                                  ? Colors.white
                                                  : Colors.red,
                                            ),
                                            child: Text(
                                              item['msg'],
                                              style: TextStyle(
                                                color:
                                                    (item['role'] == 'sender')
                                                        ? Colors.red
                                                        : Colors.white,
                                                fontSize: 15.0,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  (item['role'] == 'sender')
                                                      ? MainAxisAlignment.start
                                                      : MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                (item['role'] == 'sender')
                                                    ? Container()
                                                    : Icon(
                                                        (item['read'] == 'read')
                                                            ? Icons.done_all
                                                            : Icons.check,
                                                        color:
                                                            Colors.blueAccent,
                                                        size: 14.0,
                                                      ),
                                                SizedBox(
                                                  width: 7.0,
                                                ),
                                                Text(
                                                  item['time'],
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            Container(
              width: width,
              height: 70.0,
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: width - 70.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey,
                    ),
                    child: TextField(
                      controller: msgController,
                      style: TextStyle(
                        fontSize: 13.0,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)
                            .translate('chatPage', 'typeMessageString'),
                        hintStyle: TextStyle(
                          fontSize: 13.0,
                          color: Colors.white60,
                        ),
                        contentPadding: (myLocale.languageCode == 'ar')
                            ? EdgeInsets.only(right: 10.0)
                            : EdgeInsets.only(left: 10.0),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  InkWell(
                    borderRadius: BorderRadius.circular(20.0),
                    onTap: () {
                      if (msgController.text != '') {
                        if (now.hour > 11) {
                          amPm = 'PM';
                        } else {
                          amPm = 'AM';
                        }
                        setState(() {
                          chatData.add({
                            'role': 'me',
                            'msg': msgController.text,
                            'time': (now.hour > 12)
                                ? '${now.hour - 12}:${now.minute} $amPm'
                                : '${now.hour}:${now.minute} $amPm',
                            'read': 'unread'
                          });
                          chatDataLength = chatDataLength + 1;
                          msgController.text = '';
                        });
                        if (chatDataLength != 0) {
                          setState(() {
                            _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              curve: Curves.easeOut,
                              duration: const Duration(milliseconds: 300),
                            );
                          });
                        }
                      }
                    },
                    child: Container(
                      width: 40.0,
                      height: 40.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.grey,
                      ),
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 18.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
