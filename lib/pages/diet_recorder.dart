import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mob_dev/pages/settings.dart';
import 'package:provider/provider.dart';
import 'package:mob_dev/app_status.dart';


import 'package:mob_dev/floor_model/recorder_database/recorder_database.dart';
import 'package:mob_dev/floor_model/diet_recorder/diet_recorder_entity.dart';

import 'package:mob_dev/app_localization.dart';

import '../theme_widgets.dart';



class DietRecorder extends StatefulWidget {
  final RecorderDatabase? database;
  const DietRecorder({Key? key, this.database}):super(key:key);

  @override
  _DietRecorderState createState() => _DietRecorderState();
}

class _DietRecorderState extends State<DietRecorder> {
  ScrollController _scrollController = ScrollController();
  final TextEditingController _foodController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String? selectedFood;

  List<DietRecorderEntity> dietData = [];

  Set<String> uniqueFoodItems = Set();

  @override
  void initState(){
    super.initState();
    _loadDiet();
  }

  Future<void> _loadDiet() async {
    if(widget.database != null){
      final diets = await widget.database!.dietRecorderDao.findAllDietRecorders();
      setState(() {
        dietData = diets;
        uniqueFoodItems = diets.map((diet) => diet.diet).toSet();
      });
    }
  }

  Future<void> _recordDiet() async {
    DietRecorderEntity? diet;
    final String food = _foodController.text;
    final String amount = _amountController.text;

    if(widget.database != null){
      final points = Provider.of<RecordingState>(context, listen: false).points;
      diet = DietRecorderEntity(null, food, int.parse(amount), points, DateTime.now());
    }

    if (diet != null){
      try{
        await widget.database!.dietRecorderDao.insertDietRecorder(diet);

        await _loadDiet();

        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }

        _foodController.clear();
        _amountController.clear();
        setState(() {
          selectedFood = null;
        });
        FocusScope.of(context).unfocus();
      } catch (e) {
        print('Error: $e');
      }
    }
    Provider.of<RecordingState>(context, listen: false).record('Diet');
  }

  Future<void> _deleteDiet(DietRecorderEntity diet) async {
    if(widget.database != null){
      try{
        await widget.database!.dietRecorderDao.deleteDietRecorder(diet);
        Provider.of<RecordingState>(context, listen: false).decreasePoints();
        await Provider.of<RecordingState>(context, listen: false).loadLastStatus();
        await _loadDiet();
      } catch (e){
        print('Error: $e');
      }
    }
  }

  Future<void> _updateDiet(DietRecorderEntity diet, int newAmount) async {
    if(widget.database != null){
      try{
        // Create a new DietRecorderEntity with the updated amount
        DietRecorderEntity updatedDiet = diet.copyWith(amount: newAmount);
        // Update the diet record in the database
        await widget.database!.dietRecorderDao.updateDietRecorder(updatedDiet);
        // Reload the diet records
        _loadDiet();
      } catch (e){
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (selectedFood == null || !uniqueFoodItems.contains(selectedFood)) {
      selectedFood = uniqueFoodItems.isNotEmpty ? uniqueFoodItems.first : '';
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context).translate('dietRecorder')),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            themedDropdownButton(
              context: context,
              items: uniqueFoodItems.toList(),
              selectedItem: selectedFood ?? '',
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedFood = newValue;
                    _foodController.text = newValue;
                  });
                }
              },
            ),

            themedTextField(
              controller: _foodController,
              textHint: AppLocalizations.of(context).translate('enterFood'),
            ),
            const SizedBox(height: 50),
            Text(AppLocalizations.of(context).translate('amount')),
            themedNumberPadField(
              controller: _amountController,
              placeholder: AppLocalizations.of(context).translate('enterAmount'),
            ),
            const SizedBox(height: 16),
            currentTheme == ThemeStyle.material
                ? ElevatedButton(
              onPressed: _recordDiet,
              child: Text(AppLocalizations.of(context).translate('logFood')),
            )
                : CupertinoButton(
              color: Colors.blue,
              onPressed: _recordDiet,
              child: Text(AppLocalizations.of(context).translate('logFood')),
            ),
            const Divider(),
            Text(AppLocalizations.of(context).translate('foodLogs')),
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: dietData.length,
                itemBuilder: (context, index) {
                  // return ListTile(
                  //     title: Text(dietData[index].diet),
                  //     subtitle: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Text('${AppLocalizations.of(context).translate('amount')}: ${dietData[index].amount}'),
                  //         Text('${AppLocalizations.of(context).translate('dateAndTime')}: ${dietData[index].timestamp.toString()}'),
                  //       ],
                  //     ),
                  //     trailing: Row(
                  //         mainAxisSize: MainAxisSize.min,
                  //         children: [
                  //           IconButton(
                  //             icon: const Icon(Icons.delete),
                  //             onPressed: () => _deleteDiet(dietData[index]),
                  //           ),
                  //           IconButton(
                  //             icon: const Icon(Icons.edit),
                  //             onPressed: () async {
                  //               final newAmount = await showDialog<int>(
                  //                 context: context,
                  //                 builder: (context) {
                  //                   final controller = TextEditingController();
                  //                   return AlertDialog(
                  //                     title: Text(AppLocalizations.of(context).translate('enterNewAmount')),
                  //                     content: TextField(
                  //                       controller: controller,
                  //                       keyboardType: TextInputType.number,
                  //                       decoration: InputDecoration(
                  //                         hintText: AppLocalizations.of(context).translate('enterAmount'),
                  //                       ),
                  //                     ),
                  //                     actions: [
                  //                       TextButton(
                  //                         child: Text(AppLocalizations.of(context).translate('cancel')),
                  //                         onPressed: () {
                  //                           Navigator.of(context).pop();
                  //                         },
                  //                       ),
                  //                       TextButton(
                  //                         child: Text(AppLocalizations.of(context).translate('ok')),
                  //                         onPressed: () {
                  //                           Navigator.of(context).pop(int.parse(controller.text));
                  //                         },
                  //                       ),
                  //                     ],
                  //                   );
                  //                 },
                  //               );
                  //               if (newAmount != null) {
                  //                 _updateDiet(dietData[index], newAmount);
                  //               }
                  //             },
                  //           ),
                  //         ]
                  //     )
                  // );
                  return ListTile(
                    title: Text(dietData[index].diet),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${AppLocalizations.of(context).translate('amount')}: ${dietData[index].amount}'),
                        Text('${AppLocalizations.of(context).translate('dateAndTime')}: ${dietData[index].timestamp.toString()}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        themedIconButton(
                          materialIcon: Icons.delete,
                          cupertinoIcon: CupertinoIcons.trash,
                          onPressed: () => _deleteDiet(dietData[index]),
                        ),
                        // themedIconButton(
                        //   materialIcon: Icons.edit,
                        //   cupertinoIcon: CupertinoIcons.pencil,
                        //   onPressed: () async {
                        //     final newAmount = await showDialog<int>(
                        //       context: context,
                        //       builder: (context) {
                        //         final controller = TextEditingController();
                        //         return AlertDialog(
                        //           title: Text(AppLocalizations.of(context).translate('enterNewAmount')),
                        //           content: TextField(
                        //             controller: controller,
                        //             keyboardType: TextInputType.number,
                        //             decoration: InputDecoration(
                        //               hintText: AppLocalizations.of(context).translate('enterAmount'),
                        //             ),
                        //           ),
                        //           actions: [
                        //             TextButton(
                        //               child: Text(AppLocalizations.of(context).translate('cancel')),
                        //               onPressed: () {
                        //                 Navigator.of(context).pop();
                        //               },
                        //             ),
                        //             TextButton(
                        //               child: Text(AppLocalizations.of(context).translate('ok')),
                        //               onPressed: () {
                        //                 Navigator.of(context).pop(int.parse(controller.text));
                        //               },
                        //             ),
                        //           ],
                        //         );
                        //       },
                        //     );
                        //     if (newAmount != null) {
                        //       _updateDiet(dietData[index], newAmount);
                        //     }
                        //   },
                        // ),

                        themedIconButton(
                          materialIcon: Icons.edit,
                          cupertinoIcon: CupertinoIcons.pencil,
                          onPressed: () async {
                            final newAmount = await themedAlertDialog(
                              context,
                              AppLocalizations.of(context).translate('enterNewAmount'),
                              AppLocalizations.of(context).translate('enterAmount'),
                            );
                            if (newAmount != null) {
                              _updateDiet(dietData[index], newAmount);
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  //


  @override
  void dispose() {
    _foodController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
