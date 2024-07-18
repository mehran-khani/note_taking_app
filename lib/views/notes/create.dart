// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:note_taking_app/note/model/note_model.dart';
// import 'package:note_taking_app/note/providers/note_upload_provider.dart';
// import 'package:note_taking_app/state/auth/provider/user_id_provider.dart';
// import 'package:note_taking_app/widgets/helpers/keyboard_helpers.dart';
// import 'package:uuid/uuid.dart';

// class CreateAndUpdateNotes extends StatefulWidget {
//   final Note? existingNote;
//   const CreateAndUpdateNotes(this.existingNote, {super.key});

//   @override
//   CreateAndUpdateNotesState createState() => CreateAndUpdateNotesState();
// }

// class CreateAndUpdateNotesState extends State<CreateAndUpdateNotes> {
//   final _textEditingController = TextEditingController();
//   final FocusNode _focusNode = FocusNode();
//   bool isRowVisible = false; // Track the visibility of the row
//   bool isCheckBoxEnabled = false;
//   bool isChecked = false;
//   int previousParagraphCount = 0; // Initialize the previous paragraph count
//   List<Icon> prefixIcons = []; // Declare the prefixIcons list
//   List<bool> isCheckedList = [];
//   List<double> _iconWidths = []; // List to store icon widths
//   int heightOfTheLines = 0;

//   @override
//   void initState() {
//     super.initState();
//     _textEditingController.text = widget.existingNote != null
//         ? '${widget.existingNote!.title}\n${widget.existingNote!.content}'
//         : '';

//     // Add a listener to detect changes in the keyboard visibility
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final bool isKeyboardVisible =
//           MediaQuery.of(context).viewInsets.bottom > 0;
//       setState(() {
//         isRowVisible = _focusNode.hasFocus && isKeyboardVisible;
//       });
//     });

//     // Add listener for focus changes
//     _focusNode.addListener(() {
//       setState(() {
//         isRowVisible = _focusNode.hasFocus;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Create Note'),
//       ),
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   SizedBox(
//                     height: MediaQuery.of(context).size.height * 0.8,
//                     child: // Initialize a list to track the state of each icon
//                         TextField(
//                       focusNode: _focusNode,
//                       controller: _textEditingController,
//                       keyboardType: TextInputType.multiline,
//                       maxLines: null,
//                       decoration: InputDecoration(
//                         hintText: 'Start typing your note here...',
//                         prefix: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: prefixIcons.asMap().entries.map((entry) {
//                             final index = entry.key;
//                             final icon = entry.value;
//                             final isIconChecked =
//                                 isCheckedList.length > index &&
//                                     isCheckedList[index];

//                             return Container(
//                               height: 74,
//                               child: CupertinoButton(
//                                 child: isIconChecked
//                                     ? const Icon(
//                                         CupertinoIcons.check_mark_circled)
//                                     : icon,
//                                 onPressed: () {
//                                   setState(() {
//                                     if (isCheckedList.length <= index) {
//                                       isCheckedList.add(!isIconChecked);
//                                     } else {
//                                       isCheckedList[index] = !isIconChecked;
//                                     }
//                                   });
//                                 },
//                               ),
//                             );
//                           }).toList(),
//                         ),
//                         border: InputBorder.none,
//                       ),
//                       onChanged: (value) {
//                         final paragraphs = value.split('\n');
//                         final currentParagraphCount = paragraphs.length;

//                         if (currentParagraphCount > previousParagraphCount) {
//                           // New paragraph added, insert an icon
//                           setState(() {
//                             prefixIcons.add(const Icon(
//                               CupertinoIcons.circle,
//                               size: 24,
//                             ));
//                             isCheckedList.add(false);
//                           });
//                         } else if (currentParagraphCount <
//                             previousParagraphCount) {
//                           // Paragraph deleted, remove the last icon
//                           setState(() {
//                             prefixIcons.removeLast();
//                             isCheckedList.removeLast();
//                           });
//                         }

//                         previousParagraphCount =
//                             currentParagraphCount; // Update the previous count
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 16.0),
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             bottom:
//                 isRowVisible ? 0 : -500, // Adjust position based on visibility
//             left: 0,
//             right: 0,
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 300),
//               height: 50, // Set your desired height
//               color: Colors.grey.withOpacity(0.5),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   IconButton(
//                     icon: const Icon(CupertinoIcons.list_bullet),
//                     onPressed: () {
//                       KeyboardHelper().insertBulletPoint(
//                         textEditingController: _textEditingController,
//                       );
//                     },
//                   ),
//                   IconButton(
//                     icon: const Icon(CupertinoIcons.list_number),
//                     onPressed: () {
//                       KeyboardHelper().insertNumberedPoint(
//                         textEditingController: _textEditingController,
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: Padding(
//         padding: EdgeInsets.only(bottom: isRowVisible ? 35 : 0),
//         child: Consumer(
//           builder: (_, WidgetRef ref, __) {
//             return FloatingActionButton(
//               onPressed: () {
//                 final text = _textEditingController.text;
//                 final List<String> lines = text.split('\n');
//                 final title = lines.isNotEmpty ? lines.first : '';
//                 final content =
//                     lines.length > 1 ? lines.sublist(1).join('\n') : '';

//                 final note = widget.existingNote != null
//                     ? widget.existingNote!.copyWith(
//                         title: title,
//                         content: content,
//                         updatedAt: DateTime.now(),
//                       )
//                     : Note(
//                         title: title,
//                         content: content,
//                         createdAt: DateTime.now(),
//                         updatedAt: DateTime.now(),
//                         noteId: const Uuid().v4(),
//                       );

//                 final noteUploadNotifier =
//                     ref.read(noteUploadProvider.notifier);
//                 final userId = ref.read(userIdProvider);

//                 noteUploadNotifier.upload(note: note, userId: userId!);

//                 GoRouter.of(context).pop();
//               },
//               child: const Icon(CupertinoIcons.create),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }




// /////////////////////////////////////////////////////////////

// class CreateAndUpdateNotes extends ConsumerWidget {
//   final Note? existingNote;
//   const CreateAndUpdateNotes(this.existingNote, {super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final textEditingController = TextEditingController(
//       text: existingNote != null
//           ? '${existingNote!.title}\n${existingNote!.content}'
//           : '',
//     );

//     final noteUploadNotifier = ref.read(noteUploadProvider.notifier);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Create Note'),
//       ),
//       body: SizedBox(
//         height: MediaQuery.sizeOf(context).height,
//         width: MediaQuery.sizeOf(context).width,
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 SizedBox(
//                   height: MediaQuery.sizeOf(context).height * 0.8,
//                   child: TextField(
//                     controller: textEditingController,
//                     keyboardType: TextInputType.multiline,
//                     maxLines: null,
//                     decoration: const InputDecoration(
//                       hintText: 'Start typing your note here...',
//                       border: InputBorder.none,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16.0),
//               ],
//             ),
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           final text = textEditingController.text;
//           final List<String> lines = text.split('\n');
//           final title = lines.isNotEmpty ? lines.first : '';
//           final content = lines.length > 1 ? lines.sublist(1).join('\n') : '';

//           final note = existingNote != null
//               ? existingNote!.copyWith(
//                   title: title,
//                   content: content,
//                   updatedAt: DateTime.now(),
//                 )
//               : Note(
//                   title: title,
//                   content: content,
//                   createdAt: DateTime.now(),
//                   updatedAt: DateTime.now(),
//                   noteId: const Uuid().v4(),
//                 );

//           final userId = ref.read(userIdProvider);

//           noteUploadNotifier.upload(note: note, userId: userId!);

//           GoRouter.of(context).pop();
//         },
//         child: const Icon(CupertinoIcons.create),
//       ),
//     );
//   }
// }
