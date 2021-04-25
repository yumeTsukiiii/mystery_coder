import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mystery_coder/mystery/mystery.dart';
import 'package:mystery_coder/utils/tip.dart';
import 'package:url_launcher/url_launcher.dart';

class IndexPage extends StatefulWidget {
  IndexPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _IndexState();
}

class _MysteryCoderState {
  _MysteryCoderState(this.color, this.text, this.coder, this.tip);

  final Color color;
  final String text;
  final MysteryCoder coder;
  final String tip;
}

class _IndexState extends State<IndexPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _mysteryCodeController = TextEditingController();
  final TextEditingController _eroCodeController = TextEditingController();

  final List<_MysteryCoderState> _mysteryCoderState = [
    _MysteryCoderState(
        Colors.green,
        'H',
        MysteryCoder(
            secretText: '嗷~喵呜', multiplier: 2, prefix: '喵呜', suffix: '嗷'),
        '欸嘿嘿'),
    _MysteryCoderState(
        Colors.red,
        'R18',
        MysteryCoder(
            secretText: '嗯~啊❤', multiplier: 2, prefix: '嗯', suffix: '啊'),
        '呀！！H！！')
  ];

  late _MysteryCoderState _currentMysteryCoderState;

  @override
  void initState() {
    super.initState();
    setState(() {
      _currentMysteryCoderState = _mysteryCoderState[0];
    });
  }

  void _openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  void _encode(BuildContext context) {
    if (_mysteryCodeController.text.isEmpty) {
      return;
    }
    try {
      _eroCodeController.text =
          _currentMysteryCoderState.coder.encode(_mysteryCodeController.text);
    } catch (e) {
      showError(context, 'Error！！！~Ah~ QaQ');
    }
  }

  void _decode(BuildContext context) {
    if (_eroCodeController.text.isEmpty) {
      return;
    }
    try {
      _mysteryCodeController.text =
          _currentMysteryCoderState.coder.decode(_eroCodeController.text);
    } catch (e) {
      showError(context, 'Error！！！~Ah~ QaQ');
    }
  }

  Future<void> _copyText(BuildContext context, String text) async {
    if (text.isEmpty) {
      showError(context, '不给你复制空的❤');
      return;
    }
    await Clipboard.setData(ClipboardData(text: text)).catchError((error) {
      showSuccess(context, 'Copy Failed❤');
    });
    showSuccess(context, 'Copy Successfully❤');
  }

  void _clearText(TextEditingController controller) {
    controller.clear();
  }

  void _handleSwitchMysteryCoderTap(BuildContext context) {
    final nextState = _mysteryCoderState[
        (_mysteryCoderState.indexOf(_currentMysteryCoderState) + 1) %
            _mysteryCoderState.length];
    showInfo(context, nextState.tip);
    setState(() {
      _currentMysteryCoderState = nextState;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    final title = ([TextStyle? style]) {
      return Text.rich(
        TextSpan(children: [
          TextSpan(text: "❤ ", style: TextStyle(color: Colors.red)),
          TextSpan(text: "E", style: TextStyle(color: Colors.blue)),
          TextSpan(text: "R", style: TextStyle(color: Colors.red)),
          TextSpan(text: "O", style: TextStyle(color: Colors.yellow)),
          TextSpan(
            text: " Code Generator",
            style: TextStyle(color: Colors.black),
          ),
          TextSpan(text: " ❤", style: TextStyle(color: Colors.red))
        ]),
        style: style,
      );
    };

    final coderBorder = BorderSide(color: Colors.grey.shade300, width: 0.8);
    final coderTitleSize = max(mediaSize.width * 0.012, 16).toDouble();

    final actionButtonSize = max(mediaSize.width * 0.01, 14).toDouble();
    final actionButtonStyle = ButtonStyle(
      padding: MaterialStateProperty.all(EdgeInsets.symmetric(
          horizontal: max(mediaSize.width * 0.011, 14) * 2.5,
          vertical: max(mediaSize.width * 0.011, 8))),
    );

    final inputFontSize = max(mediaSize.width * 0.013, 16).toDouble();
    final inputLines = 6;
    final inputMaxLength = 5000;

    final orientationWidth = 720;

    final encoder = Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Text.rich(
                TextSpan(children: [
                  TextSpan(text: '❤', style: TextStyle(color: Colors.red)),
                  TextSpan(text: ' 加密前 '),
                  TextSpan(text: '❤', style: TextStyle(color: Colors.red))
                ]),
                style: TextStyle(fontSize: coderTitleSize),
              )),
              Builder(builder: (context) {
                return OutlinedButton(
                    onPressed: () => _encode(context),
                    child: Text(
                      '加密',
                      style: TextStyle(
                          fontSize: actionButtonSize, letterSpacing: 8),
                    ),
                    style: actionButtonStyle);
              }),
            ],
          ),
        ),
        SizedBox(
          height: 16,
        ),
        DecoratedBox(
          decoration: BoxDecoration(
              border: Border(top: coderBorder, right: coderBorder)),
          child: Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: TextField(
              controller: _mysteryCodeController,
              minLines: inputLines,
              maxLines: inputLines,
              maxLength: inputMaxLength,
              style: TextStyle(fontSize: inputFontSize),
              decoration: InputDecoration(
                  suffix: Builder(
                    builder: (context) {
                      return Wrap(
                        direction: Axis.vertical,
                        children: [
                          Tooltip(
                            message: 'Copy❤',
                            child: IconButton(
                                icon: Icon(Icons.copy, color: Colors.grey),
                                onPressed: () => _copyText(
                                    context, _mysteryCodeController.text)),
                          ),
                          Tooltip(
                            message: 'Clear❤',
                            child: IconButton(
                                icon: Icon(Icons.clear, color: Colors.grey),
                                onPressed: () =>
                                    _clearText(_mysteryCodeController)),
                          ),
                        ],
                      );
                    },
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: inputFontSize, vertical: inputFontSize)),
            ),
          ),
        )
      ],
    );
    final decoder = Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Text.rich(
                TextSpan(children: [
                  TextSpan(text: '❤', style: TextStyle(color: Colors.red)),
                  TextSpan(text: ' 加密后 '),
                  TextSpan(text: '❤', style: TextStyle(color: Colors.red))
                ]),
                style: TextStyle(fontSize: coderTitleSize),
              )),
              Builder(builder: (context) {
                return OutlinedButton(
                    onPressed: () => _decode(context),
                    child: Text(
                      '解密',
                      style: TextStyle(
                          fontSize: actionButtonSize, letterSpacing: 8),
                    ),
                    style: actionButtonStyle);
              })
            ],
          ),
        ),
        SizedBox(
          height: 16,
        ),
        DecoratedBox(
          decoration: BoxDecoration(
              border: Border(
            top: coderBorder,
          )),
          child: Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: TextField(
              controller: _eroCodeController,
              minLines: inputLines,
              maxLines: inputLines,
              maxLength: inputMaxLength,
              style: TextStyle(fontSize: inputFontSize),
              decoration: InputDecoration(
                  suffix: Builder(
                    builder: (context) {
                      return Wrap(
                        direction: Axis.vertical,
                        children: [
                          Tooltip(
                            message: 'Copy❤',
                            child: IconButton(
                                icon: Icon(Icons.copy, color: Colors.grey),
                                onPressed: () => _copyText(
                                    context, _eroCodeController.text)),
                          ),
                          Tooltip(
                            message: 'Clear❤',
                            child: IconButton(
                                icon: Icon(Icons.clear, color: Colors.grey),
                                onPressed: () =>
                                    _clearText(_eroCodeController)),
                          ),
                        ],
                      );
                    },
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: inputFontSize, vertical: inputFontSize)),
            ),
          ),
        )
      ],
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: title(),
        leading: IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.black,
            ),
            onPressed: _openDrawer),
        actions: [
          Tooltip(
            message: 'Github源码',
            child: IconButton(
                icon: Image.network(
                  'http://cdn.yumetsuki.cn/github.png',
                  width: 24,
                  height: 24,
                ),
                onPressed: () {
                  launch('https://github.com/yumeTsukiiii/mystery_coder.git');
                }),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.symmetric(
                  horizontal: mediaSize.width < 1024 ||
                          mediaSize.width < mediaSize.height
                      ? max(mediaSize.width * 0.04, 32)
                      : mediaSize.width * 0.08,
                  vertical: mediaSize.height * 0.07),
              child: Column(
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  mediaSize.width >= orientationWidth
                      ? Row(
                          children: [
                            Expanded(child: encoder),
                            Expanded(child: decoder)
                          ],
                        )
                      : Column(
                          children: [encoder, decoder],
                        )
                ],
              ),
              elevation: 16,
            )
          ],
        ),
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: title(TextStyle(fontSize: 18)),
              ),
              Text('略略略, 什么也没有~')
            ],
          ),
        ),
      ),
      drawerEnableOpenDragGesture: false,
      floatingActionButton: Builder(builder: (context) {
        return FloatingActionButton(
          backgroundColor: _currentMysteryCoderState.color,
          onPressed: () => _handleSwitchMysteryCoderTap(context),
          child: Text(_currentMysteryCoderState.text),
        );
      }),
    );
  }
}
