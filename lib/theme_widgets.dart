import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mob_dev/pages/settings.dart';

Widget themedButton(BuildContext context, String text, VoidCallback onPressed) {
  if (currentTheme == ThemeStyle.material) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  } else {
    return CupertinoButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}


Widget themedTextField({required TextEditingController controller, required String textHint}) {
  if (currentTheme == ThemeStyle.material) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: textHint,
      ),
    );
  } else {
    return CupertinoTextField(
      controller: controller,
      placeholder: textHint,
    );
  }
}

Widget themedNumberPadField({required TextEditingController controller, required String placeholder}) {
  if (currentTheme == ThemeStyle.material) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: placeholder,
      ),
    );
  } else {
    return CupertinoTextField(
      controller: controller,
      keyboardType: TextInputType.number,
      placeholder: placeholder,
    );
  }
}


Widget themedProgressIndicator() {
  if (currentTheme == ThemeStyle.material) {
    return CircularProgressIndicator();
  } else {
    return CupertinoActivityIndicator();
  }
}

Widget themedDropdownButton({required List<String> items, required String selectedItem, required ValueChanged<String?> onChanged, required BuildContext context}) {
  if (currentTheme == ThemeStyle.material) {
    return DropdownButton<String>(
      value: selectedItem,
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  } else {
    return CupertinoButton(
      child: Text(selectedItem),
      onPressed: () {
        showCupertinoModalPopup<String>(
          context: context,
          builder: (BuildContext context) {
            return CupertinoActionSheet(
              actions: [
                Container(
                  height: 200,
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                      initialItem: items.indexOf(selectedItem),
                    ),
                    itemExtent: 32.0,
                    onSelectedItemChanged: (int index) {
                      onChanged(items[index]);
                    },
                    children: items.map<Text>((String value) {
                      return Text(value);
                    }).toList(),
                  ),
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                child: Text('Done'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            );
          },
        );
      },
    );
  }
}

Widget themedIconButton({required IconData materialIcon, required IconData cupertinoIcon, required VoidCallback onPressed}) {
  if (currentTheme == ThemeStyle.material) {
    return IconButton(
      icon: Icon(materialIcon),
      onPressed: onPressed,
    );
  } else {
    return CupertinoButton(
      child: Icon(cupertinoIcon),
      onPressed: onPressed,
    );
  }
}


Future<int?> themedAlertDialog(BuildContext context, String title, String placeholder) {
  if (currentTheme == ThemeStyle.material) {
    final controller = TextEditingController();
    return showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: placeholder,
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(int.parse(controller.text));
              },
            ),
          ],
        );
      },
    );
  } else {
    final controller = TextEditingController();
    return showCupertinoDialog<int>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: CupertinoTextField(
            controller: controller,
            keyboardType: TextInputType.number,
            placeholder: placeholder,
          ),
          actions: [
            CupertinoDialogAction(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(int.parse(controller.text));
              },
            ),
          ],
        );
      },
    );
  }
}