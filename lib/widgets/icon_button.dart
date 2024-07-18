import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Checklist extends StatefulWidget {
  const Checklist({Key? key});

  @override
  ChecklistState createState() => ChecklistState();
}

class ChecklistState extends State<Checklist> {
  final TextEditingController textEditingController = TextEditingController();
  final List<String> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: items.length + 1, // +1 for the input field
        itemBuilder: (context, index) {
          if (index == items.length) {
            // Input field for adding new items
            return Row(
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      items.add(textEditingController.value.text);
                      textEditingController.clear(); // Clear text field
                    });
                  },
                  child: Icon(
                    items[index].isEmpty
                        ? CupertinoIcons.circle
                        : CupertinoIcons.check_mark_circled,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: textEditingController,
                    decoration: const InputDecoration(
                      hintText: 'Add item',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        items[index] = value;
                      });
                    },
                  ),
                ),
              ],
            );
          } else {
            // Existing checklist item
            return Row(
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      items[index] = textEditingController.value.text;
                    });
                  },
                  child: Icon(
                    items[index].isEmpty
                        ? CupertinoIcons.circle
                        : CupertinoIcons.check_mark_circled,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    initialValue: items[index],
                    decoration: const InputDecoration(
                      hintText: 'Add item',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        items[index] = value;
                      });
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}







// TextField(
//                       focusNode: focusNode,
//                       controller: textEditingController,
//                       keyboardType: TextInputType.multiline,
//                       maxLines: null,
//                       decoration: InputDecoration(
//                         hintText: 'Start typing your note here...',
//                         prefixIcon: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             // Existing icon
//                             CupertinoButton(
//                               padding: EdgeInsets.zero,
//                               child: Icon(
//                                 isChecked
//                                     ? CupertinoIcons.check_mark_circled
//                                     : CupertinoIcons.circle,
//                                 color: Colors.blue,
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   isChecked = !isChecked;
//                                 });
//                               },
//                             ),
//                             // Add new icons dynamically
//                             for (var icon in prefixIcons)
//                               CupertinoButton(
//                                 padding: EdgeInsets.zero,
//                                 child: Icon(
//                                   icon,
//                                   color: Colors.blue,
//                                 ),
//                                 onPressed: () {
//                                   // Find the index of the current icon
//                                   final index = prefixIcons.indexOf(icon);
//                                   setState(() {
//                                     prefixIcons[index] = isChecked
//                                         ? CupertinoIcons.check_mark_circled
//                                         : CupertinoIcons.circle;
//                                   });
//                                 },
//                               ),
//                           ],
//                         ),
//                         border: InputBorder.none,
//                       ),
//                       onChanged: (value) {
//                         // Check if the last character entered was a newline
//                         if (value.endsWith('\n')) {
//                           // Insert a new icon for the new line
//                           setState(() {
//                             prefixIcons.add(CupertinoIcons.circle);
//                           });
//                         }
//                       },
//                     ),
// import 'package:flutter/material.dart';

// class TextFieldWithTappableIcon extends StatefulWidget {
//   const TextFieldWithTappableIcon({super.key});

//   @override
//   TextFieldWithTappableIconState createState() =>
//       TextFieldWithTappableIconState();
// }

// class TextFieldWithTappableIconState extends State<TextFieldWithTappableIcon> {
//   bool iconTapped = false;
//   bool newLineTyped = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Container(
//           padding: const EdgeInsets.all(16.0),
//           child: TextField(
//             decoration: InputDecoration(
//               labelText: 'Enter text',
//               prefixIcon: newLineTyped
//                   ? const Icon(Icons.star)
//                   : null, // Change the icon based on new line typed
//             ),
//             onChanged: (text) {
//               setState(() {
// // Check if the user types a new line
//                 newLineTyped = text.endsWith('\n');
//               });
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }