import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mob_dev/app_status.dart';

import 'package:mob_dev/floor_model/recorder_database/recorder_database.dart';
import 'package:mob_dev/floor_model/emotion_recorder/emotion_recorder_entity.dart';


import 'package:mob_dev/floor_model/app_status/app_status_entity.dart';


class EmotionRecorder extends StatefulWidget {

  // const EmotionRecorder({super.key});

  final RecorderDatabase? database;
  const EmotionRecorder({Key? key, this.database}):super(key:key);

  @override
  _EmotionRecorder createState() => _EmotionRecorder();
}

class _EmotionRecorder extends State<EmotionRecorder> {
  List<EmotionRecorderEntity> emojiData = [];
  String selectedEmoji = '😀';
  ScrollController _scrollController = ScrollController();
  // RecorderDatabase? database;

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


    // AppStatusEntity? appStatus;
    //
    // const String whatRecorder = 'Emotion';

    if(widget.database != null){
      final points = Provider.of<RecordingState>(context, listen: false).points;
      emotion = EmotionRecorderEntity(null, selectedEmoji, points, DateTime.now());
    };

    if (emotion != null){
      try{
        await widget.database!.emotionRecorderDao.insertEmotionRecorder(emotion);

        // if (appStatus != null){
        //   await widget.database!.appStatusDao.insertAppStatus(appStatus);
        // }

        await _loadEmotions();
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      } catch (e) {
        print('Error: $e');
      }
    }
    Provider.of<RecordingState>(context, listen: false).record('Emotion');
  }


  Future<void> _deleteEmotion(EmotionRecorderEntity emotion) async {
    if(widget.database != null){
      try{
        await widget.database!.emotionRecorderDao.deleteEmotionRecorder(emotion);

        // Fetch the current status
        // AppStatusEntity currentStatus = await widget.database!.appStatusDao.getLastStatus();
        //
        // if (currentStatus.whichRecorder == 'Emotion' && currentStatus.timestamp == emotion.timestamp) {
        //   await widget.database!.appStatusDao.deleteAppStatus(currentStatus);
        // }

        _loadEmotions();
      } catch (e){
        print('Error: $e');
      }
    }
  }


  void _clearEmojis() {
    setState(() {
      emojiData.clear();
    });
  }

//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emotion Recorder'),
        centerTitle: true,
      ),

        body: Column(
          children: [
            const Text('Emoji Picker'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: DropdownButton<String>(
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
                  ),
                ),
                Flexible(
                  child: ElevatedButton(
                    onPressed: _recordEmotion,
                    child: const Text('Place Emoji'),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _clearEmojis,
              child: const Text('Clear Logs'),
            ),
            const Divider(),
            const Text('Logs'),
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
                      'Used On: ${emojiData[index].timestamp.toString()}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteEmotion(emojiData[index]),
                    )
                  );
                  },
              ),
            ),
          ],
        )
    );
  }
}
//
