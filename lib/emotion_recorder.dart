import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mob_dev/app_status.dart';

import 'package:mob_dev/floor_model/recorder_database.dart';
import 'package:mob_dev/floor_model/emotion_recorder_entity.dart';


class EmotionRecorder extends StatefulWidget {
  const EmotionRecorder({super.key});

  @override
  _EmotionRecorder createState() => _EmotionRecorder();
}

// class _EmotionRecorder extends State<EmotionRecorder> {
//   List<Map<String, dynamic>> emojiData = [];
//   String selectedEmoji = '😀';
//
//   final List<String> emojiList = [
//     '😀', '😃', '😄', '😁', '😆', '🥹', '😅', '😂', '🤣', '🥲', '☺️',
//     '😊', '😇', '🙂', '🙃', '😉', '😌', '😍', '🥰', '😘', '😗', '😚',
//     '😋', '😛', '😝',
//   ];
//
//   void _recordEmotion() {
//     setState(() {
//       emojiData.insert(0, {'emoji': selectedEmoji, 'datetime': DateTime.now()});
//     });
//
//     Provider.of<RecordingState>(context, listen: false).record('Emotion');
//   }



class _EmotionRecorder extends State<EmotionRecorder> {
  List<EmotionRecorderEntity> emojiData = [];
  String selectedEmoji = '😀';

  RecorderDatabase? database;

  final List<String> emojiList = [
    '😀', '😃', '😄', '😁', '😆', '🥹', '😅', '😂', '🤣', '🥲', '☺️',
    '😊', '😇', '🙂', '🙃', '😉', '😌', '😍', '🥰', '😘', '😗', '😚',
    '😋', '😛', '😝',
  ];

  @override
  void initState(){
    $FloorRecorderDatabase
        .databaseBuilder('recorder_database.db')
        .build()
        .then((db) => setState(() => database = db));
    _loadEmotions();
  }

  Future<void> _loadEmotions() async {
    if(database != null){
      final emotions = await database!.emotionRecorderDao.findAllEmotionRecorders();
      setState(() {
        emojiData = emotions;
        });

    }
  }

  Future<void> _recordEmotion() async {
    EmotionRecorderEntity? emotion;

    if(database != null){
      final points = Provider.of<RecordingState>(context, listen: false).points;
      emotion = EmotionRecorderEntity(null, selectedEmoji, points, DateTime.now());
    };

    if (emotion != null){
      try{
        await database!.emotionRecorderDao.insertEmotionRecorder(emotion);
        _loadEmotions();
      } catch (e) {
        print('Error: $e');
      }
    }

      // setState(() {
      //   emojiData.insert(0, {'emoji': selectedEmoji, 'datetime': DateTime.now()});
      // });

    Provider.of<RecordingState>(context, listen: false).record('Emotion');
  }


  Future<void> _deleteEmotion(EmotionRecorderEntity emotion) async {
    if(database != null){
      try{
        await database!.emotionRecorderDao.deleteEmotionRecorder(emotion);
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

            // IconButton(
            //   icon: const Icon(Icons.delete),
            //   onPressed: () => _deleteEmotion(emojiData),
            // );
            const Divider(),
            const Text('Logs'),
            Expanded(
              child: ListView.builder(
                itemCount: emojiData.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    // leading: Text(
                    //   emojiData[index]['emoji'],
                    //   style: const TextStyle(fontSize: 24),
                    // ),
                    // title: Text(
                    //   'Used On: ${emojiData[index]['datetime'].toString()}',
                    // ),


                    leading: Text(
                      emojiData[index].emoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: Text(
                      'Used On: ${emojiData[index].timestamp.toString()}',
                    ),
                    subtitle: Text(
                      'Points: ${emojiData[index].points.toString()}',
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
