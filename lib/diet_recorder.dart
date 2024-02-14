import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mob_dev/app_status.dart';

class DietRecorder extends StatefulWidget {
  const DietRecorder({Key? key}) : super(key: key);

  @override
  _DietRecorderState createState() => _DietRecorderState();
}

class _DietRecorderState extends State<DietRecorder> {
  final TextEditingController _foodController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final List<Map<String, dynamic>> dietData = [];
  List<String> uniqueFoodItems = [];

  String? selectedFood;

  void _logFood() {
    final String food = selectedFood ?? _foodController.text.trim();
    final String amount = _amountController.text.trim();

    if (food.isNotEmpty && amount.isNotEmpty) {
      bool foodExists = uniqueFoodItems.contains(food);
      setState(() {
        dietData.insert(0, {
          'Food': food,
          'Amount': amount,
          'datetime': DateTime.now()
        });

        if (!foodExists) {
          uniqueFoodItems.add(food);
        }
      });

      Provider.of<RecordingState>(context, listen: false).record('Diet');

      _foodController.clear();
      _amountController.clear();
      selectedFood = null;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both food and amount'),
        ),
      );
    }
  }




  @override
  Widget build(BuildContext context) {
    List<String> foodItems = dietData.map((entry) => entry['Food'] as String).toList();

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text('Diet Recorder')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DropdownButton<String>(
              key: const Key('foodDropdown'),
              value: selectedFood,
              hint: const Text('Select Food'),
              onChanged: (newValue) {
                setState(() {
                  selectedFood = newValue;
                  _foodController.text = newValue ?? '';
                });
              },
              items: uniqueFoodItems.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),

            TextField(
              controller: _foodController,
              decoration: const InputDecoration(
                hintText: 'Enter Food',
              ),
            ),
            const SizedBox(height: 50),
            const Text('Amount'),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Enter Amount',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _logFood,
              child: const Text('Log Food'),
            ),
            ElevatedButton(
              onPressed: () => setState(() {
                dietData.clear();
                selectedFood = null;
              }),
              child: const Text('Clear Logs'),
            ),
            const Divider(),
            const Text('Food Logs'),
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: dietData.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(dietData[index]['Food']),
                    subtitle: Text('Amount: ${dietData[index]['Amount']}'),
                    trailing: Text('Date and Time: ${dietData[index]['datetime'].toString()}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _foodController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
