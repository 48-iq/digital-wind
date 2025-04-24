import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../main.dart';
import '../../../auth/data/store/auth_store.dart';
import '../../../core/components/button.dart';
import '../../../core/components/typed_text.dart';
import '../../../core/widgets/app_header_gear.dart';
import '../../../endings/data/store/endings_store.dart';
import '../../../endings/presentation/pages/all_endings_page.dart';
import '../../../main_menu/presentation/pages/main_menu_page.dart';
import '../../../quick_menu/presentation/pages/quick_menu_page.dart';

class QuestPage extends StatefulWidget {
  const QuestPage({super.key});

  @override
  _QuestPageState createState() => _QuestPageState();
}

class _QuestPageState extends State<QuestPage> {
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  List<String> _userLog = [];
  List<String> _currentChoices = [];
  bool _isTyping = false;
  bool _showEnding = false;
  String? _currentEnding;
  Map<String, dynamic>? _storyData;
  bool _isQuickMenuOpen = false;

  @override
  void initState() {
    super.initState();
    _loadStoryData();
  }

  Future<void> _loadStoryData() async {
    try {
      final jsonString = await rootBundle.loadString('assets/story.json');
      final data = json.decode(jsonString);
      setState(() {
        _storyData = data;
        _startQuest();
      });
    } catch (e) {
      print('Error loading story data: $e');
    }
  }

  void _startQuest() {
    if (_storyData == null) return;

    final startAction = _storyData!['sysActions']
        .firstWhere((action) => action['id'] == 'start');
    _addSystemMessage(startAction['text']);
    _showChoices(startAction['playerActionIds']);
    _saveProgress();
  }

  void _addSystemMessage(String text) {
    setState(() {
      _messages.add({
        'text': text,
        'isSystem': true,
        'isTyping': true,
      });
      _isTyping = true;
    });
    _userLog.add('sys:${_messages.last['text']}');
    _scrollToBottom();
    _saveProgress();
  }

  void _addPlayerMessage(String text) {
    setState(() {
      _messages.add({
        'text': text,
        'isSystem': false,
        'isTyping': true,
      });
      _isTyping = true;
    });
    _userLog.add('player:$text');
    _scrollToBottom();
    _saveProgress();
  }

  void _completeTyping(int index) {
    setState(() {
      _messages[index]['isTyping'] = false;
      _isTyping = false;
    });
  }

  void _showChoices(List<String>? choiceIds) {
    setState(() {
      _currentChoices = choiceIds?.map((id) {
        final action = _storyData!['playerActions']
            .firstWhere((action) => action['id'] == id);
        return action['text'] as String;
      }).toList().cast<String>() ?? [];
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleChoice(String choiceText) async {
    final choiceId = _storyData!['playerActions']
        .firstWhere((action) => action['text'] == choiceText)['id'];

    _addPlayerMessage(choiceText);
    setState(() => _currentChoices = []);

    final nextSysAction = _findNextSystemAction(choiceId);

    if (nextSysAction['type'] == 'ending') {
      await _handleEnding(nextSysAction);
    } else {
      _addSystemMessage(nextSysAction['text']);
      _showChoices(nextSysAction['playerActionIds']);
    }
  }

  Map<String, dynamic> _findNextSystemAction(String choiceId) {
    final playerAction = _storyData!['playerActions']
        .firstWhere((action) => action['id'] == choiceId);

    for (var sysAction in playerAction['sysActions']) {
      if (_checkCondition(sysAction['condition'])) {
        return _storyData!['sysActions']
            .firstWhere((action) => action['id'] == sysAction['id']);
      }
    }

    throw Exception('No valid system action found');
  }

  bool _checkCondition(List<dynamic>? condition) {
    if (condition == null) return true;
    if (_userLog.isEmpty) return false;

    for (var conditionGroup in condition) {
      if (conditionGroup is! List) continue;

      bool groupMatches = true;
      for (int i = 0; i < conditionGroup.length; i++) {
        final conditionItem = conditionGroup[i];
        if (i >= _userLog.length) {
          groupMatches = false;
          break;
        }

        if (conditionItem == '*') continue;

        final logItem = _userLog[i];
        if (conditionItem.startsWith('sys:')) {
          if (!logItem.startsWith('sys:') ||
              !logItem.endsWith(conditionItem.substring(4))) {
            groupMatches = false;
            break;
          }
        } else if (conditionItem.startsWith('player:')) {
          if (!logItem.startsWith('player:') ||
              logItem != conditionItem) {
            groupMatches = false;
            break;
          }
        } else {
          if (logItem != conditionItem) {
            groupMatches = false;
            break;
          }
        }
      }

      if (groupMatches) return true;
    }

    return false;
  }

  Future<void> _handleEnding(Map<String, dynamic> ending) async {
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _showEnding = true;
      _currentEnding = ending['text'];
    });

    final endingsStore = Provider.of<EndingsStore>(context, listen: false);
    final authStore = Provider.of<AuthStore>(context, listen: false);
    if (authStore.token != null) {
      await endingsStore.addEnding(ending['id'], authStore.token!);
    }
    _clearProgress();
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('user_log', _userLog);
    await prefs.setString('last_message', json.encode(_messages.last));
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLog = prefs.getStringList('user_log');
    if (savedLog != null) {
      setState(() => _userLog = savedLog);

      final lastMessage = prefs.getString('last_message');
      if (lastMessage != null) {
        final message = json.decode(lastMessage);
        setState(() => _messages.add(Map<String, dynamic>.from(message)));

        if (message['isSystem']) {
          final action = _storyData!['sysActions']
              .firstWhere((a) => a['text'] == message['text']);
          _showChoices(action['playerActionIds']);
        }
      }
    }
  }

  Future<void> _clearProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_log');
    await prefs.remove('last_message');
  }

  void _exitToMenu() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final authStore = Provider.of<AuthStore>(context);
    if (_storyData == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (_showEnding) {
      return _buildEndingScreen();
    }

    if (_isQuickMenuOpen) {
      return QuickMenuPage(
        onContinuePressed: () {
          setState(() {
            _isQuickMenuOpen = false;
          });
        },
        onExitPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MainMenuPage(
              onPlayPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const QuestPage()),
                );
              },
              // onEndingsPressed: () async {
              //   try {
              //     final endingsStore = Provider.of<EndingsStore>(context, listen: false);
              //     await endingsStore.loadEndings(authStore.token!);
              //
              //     if (mounted) {
              //       Navigator.of(context).push(
              //         MaterialPageRoute(
              //           builder: (_) => AllEndingsPage(
              //             endings: endingsStore.endings,
              //             onExitPressed: () => Navigator.of(context).pop(),
              //           ),
              //         ),
              //       );
              //     }
              //   } catch (e) {
              //     if (mounted) {
              //       ScaffoldMessenger.of(context).showSnackBar(
              //         SnackBar(content: Text('Ошибка загрузки концовок: ${e.toString()}')),
              //       );
              //     }
              //   }
              // },
              onEndingsPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AllEndingsPage(
                      endings: ["концовка слона", 'концовка бурильщика'],
                      onExitPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                );
              },
              onLogoutPressed: () async {
                await authStore.logout();
                if (mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const AuthWrapper()),
                  );
                }
              },
            )),
          );
        },
      );
    }

    return _buildQuestScreen();
  }

  Widget _buildEndingScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppHeaderGear(),
            const SizedBox(height: 32),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TypedText(
                      text: '[система] вы открыли новую концовку',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _currentEnding ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Courier',
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Button(
              text: 'Выйти в меню',
              borderColor: Colors.blue,
              onPressed: _exitToMenu,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          if (_isTyping) {
            setState(() {
              for (var msg in _messages) {
                if (msg['isTyping']) {
                  msg['isTyping'] = false;
                }
              }
              _isTyping = false;
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const AppHeaderGear(),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ..._messages.asMap().entries.map((entry) {
                        final index = entry.key;
                        final message = entry.value;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (message['isSystem'])
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                          text: '[',
                                          style: TextStyle(color: Colors.white)
                                      ),
                                      TextSpan(
                                        text: 'система',
                                        style: const TextStyle(color: Colors.blue),
                                      ),
                                      const TextSpan(
                                          text: ']',
                                          style: TextStyle(color: Colors.white)
                                      ),
                                    ],
                                  ),
                                ),

                              if (!message['isTyping'] && !message['isSystem'])
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                          text: '[',
                                          style: TextStyle(color: Colors.white)
                                      ),
                                      TextSpan(
                                        text: 'игрок',
                                        style: const TextStyle(color: Color(0xFFB91354)),
                                      ),
                                      const TextSpan(
                                          text: ']',
                                          style: TextStyle(color: Colors.white)
                                      ),
                                    ],
                                  ),
                                ),

                              if (message['isTyping'])
                                TypedText(
                                  text: message['text'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Courier',
                                  ),
                                  onCompleted: () => _completeTyping(index),
                                )
                              else
                                Text(
                                  message['isSystem']
                                      ? message['text']
                                      : '> ${message['text']}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Courier',
                                  ),
                                ),
                            ],
                          ),
                        );
                      }).toList(),
                      if (_currentChoices.isNotEmpty)
                        ..._currentChoices.map((choice) => Button(
                          text: choice,
                          borderColor: const Color(0xFFB91354),
                          onPressed: () => _handleChoice(choice),
                        )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}