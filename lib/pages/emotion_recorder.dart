import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mob_dev/pages/settings.dart';
import 'package:provider/provider.dart';
import 'package:mob_dev/utils/app_status.dart';

import 'package:mob_dev/floor_model/recorder_database/recorder_database.dart';
import 'package:mob_dev/floor_model/emotion_recorder/emotion_recorder_entity.dart';

import 'package:mob_dev/utils/app_localization.dart';
import 'package:mob_dev/utils/theme_widgets.dart';

import 'package:cloud_functions/cloud_functions.dart';

class EmotionRecorder extends StatefulWidget {

  final RecorderDatabase? database;
  const EmotionRecorder({Key? key, this.database}):super(key:key);

  @override
  _EmotionRecorder createState() => _EmotionRecorder();
}

class _EmotionRecorder extends State<EmotionRecorder> {
  List<EmotionRecorderEntity> emojiData = [];
  String selectedEmoji = '😀';
  ScrollController _scrollController = ScrollController();

  final List<String> emojiList = [
    '😀', '😃', '😄', '😁', '😆', '🥹', '😅', '😂', '🤣', '🥲', '☺️',
    '😊', '😇', '🙂', '🙃', '😉', '😌', '😍', '🥰', '😘', '😗', '😚',
    '😋', '😛', '😝',
  ];


  @override
  void initState(){
    super.initState();
    _loadEmotions();
  }

  Future<void> _loadEmotions() async {
    if(widget.database != null){
      final emotions = await widget.database!.emotionRecorderDao.findAllEmotionRecorders();
      setState(() {
        emojiData = emotions;
        });
    }
  }

  Future<void> _recordEmotion() async {
    EmotionRecorderEntity? emotion;

    FirebaseFunctions.instance.httpsCallable('updatePoints').call({
      'increment': 1, // Increment the points by 1
    });

    if(widget.database != null){
      final points = Provider.of<RecordingState>(context, listen: false).points;
      emotion = EmotionRecorderEntity(null, selectedEmoji, points, DateTime.now());
    };

    if (emotion != null){
      try{
        await widget.database!.emotionRecorderDao.insertEmotionRecorder(emotion);
        await _loadEmotions();
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }

      } catch (e) {
        print('Error: $e');
      }
    }


    Provider.of<RecordingState>(context, listen: false).record(AppLocalizations.of(context).translate('Emotion'));
  }

  Future<void> _deleteEmotion(EmotionRecorderEntity emotion) async {
    FirebaseFunctions.instance.httpsCallable('updatePoints').call({
      'decrement': 1, // Decrement the points by 1
    });
    if(widget.database != null){
      try{
        await widget.database!.emotionRecorderDao.deleteEmotionRecorder(emotion);
        Provider.of<RecordingState>(context, listen: false).decreasePoints();
        await Provider.of<RecordingState>(context, listen: false).loadLastStatus();
        await _loadEmotions();
      } catch (e){
        print('Error: $e');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('emotionRecorder')),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Text(AppLocalizations.of(context).translate('emojiPicker')),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: currentTheme == ThemeStyle.material
                    ? DropdownButton<String>(
                  isExpanded: true,
                  value: selectedEmoji,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedEmoji = newValue;
                      });
                    }
                  },
                  items: emojiList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )
                    : themedDropdownButton(
                  context: context,
                  items: emojiList,
                  selectedItem: selectedEmoji,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedEmoji = newValue;
                      });
                    }
                  },
                ),
              ),
              Flexible(
                child: themedButton(
                  context,
                  AppLocalizations.of(context).translate('placeEmoji'),
                  _recordEmotion,
                ),
              ),
            ],
          ),
          const Divider(),
          Text(AppLocalizations.of(context).translate('logs')),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: emojiData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Text(
                    emojiData[index].emoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                  title: Text(
                    '${AppLocalizations.of(context).translate('usedOn')}: ${emojiData[index].timestamp.toString()}',
                  ),
                  trailing: themedIconButton(
                    materialIcon: Icons.delete,
                    cupertinoIcon: CupertinoIcons.trash,
                    onPressed: () => _deleteEmotion(emojiData[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


