import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mob_dev/app_status.dart';


class EmotionRecorder extends StatefulWidget {
  const EmotionRecorder({super.key});

  @override
  _EmotionRecorder createState() => _EmotionRecorder();
}

class _EmotionRecorder extends State<EmotionRecorder> {
  List<Map<String, dynamic>> emojiData = [];
  String selectedEmoji = '😀';

  final List<String> emojiList = [
    '😀', '😃', '😄', '😁', '😆', '🥹', '😅', '😂', '🤣', '🥲', '☺️',
    '😊', '😇', '🙂', '🙃', '😉', '😌', '😍', '🥰', '😘', '😗', '😚',
    '😋', '😛', '😝',
  ];

  void _recordEmotion() {
    setState(() {
      emojiData.insert(0, {'emoji': selectedEmoji, 'datetime': DateTime.now()});
    });

    Provider.of<RecordingState>(context, listen: false).record('Emotion');
  }

  void _clearEmojis() {
    setState(() {
      emojiData.clear();
    });
  }

  // RecorderDatabase? database;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   $FloorRecorderDatabase
  //       .databaseBuilder('recorder_database.db')
  //       .build()
  //       .then((db) => setState(() => database = db));
  // }


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
                itemCount: emojiData.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Text(
                      emojiData[index]['emoji'],
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: Text(
                      'Used On: ${emojiData[index]['datetime'].toString()}',
                    ),
                  );
                  },
              ),
            ),
          ],
        )
    );
  }
}
