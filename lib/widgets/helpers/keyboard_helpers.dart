import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class KeyboardHelper {
  KeyboardHelper();

  void insertBulletPoint({
    required TextEditingController textEditingController,
  }) {
    final String text = textEditingController.text;
    final int selectionStart = textEditingController.selection.start;

    // Find the start and end positions of the current line
    int lineStart = selectionStart;
    int lineEnd = selectionStart;
    while (lineStart > 0 && text[lineStart - 1] != '\n') {
      lineStart--;
    }
    while (lineEnd < text.length && text[lineEnd] != '\n') {
      lineEnd++;
    }

    // Check if the line starts with a bullet point
    final bool hasBulletPoint = text.startsWith('\u2022', lineStart);

    // Remove any existing bullet points in the line
    final lineText = text.substring(lineStart, lineEnd);
    final newText = lineText.replaceAll('\u2022 ', '');

    // Construct the updated text with the bullet point toggled
    final updatedText = hasBulletPoint
        ? text.replaceRange(lineStart, lineStart + 1, '')
        : '${text.substring(0, lineStart)}\u2022$newText${text.substring(lineEnd)}';

    textEditingController.value = TextEditingValue(
      text: updatedText,
      selection: TextSelection.collapsed(offset: updatedText.length),
    );
  }

  void insertNumberedPoint({
    required TextEditingController textEditingController,
  }) {
    final String text = textEditingController.text;
    final int selectionStart = textEditingController.selection.start;

    // Find the start and end positions of the current line
    int lineStart = selectionStart;
    int lineEnd = selectionStart;
    while (lineStart > 0 && text[lineStart - 1] != '\n') {
      lineStart--;
    }
    while (lineEnd < text.length && text[lineEnd] != '\n') {
      lineEnd++;
    }

    // Extract the current line
    final String lineText = text.substring(lineStart, lineEnd);

    // Check if the line starts with a number
    final bool hasNumber = RegExp(r'^\d+\.\s*').hasMatch(lineText);

    // Construct the updated text with the numbered point
    // Remove any existing number from the line
    final String updatedText = hasNumber
        ? '${text.substring(0, lineStart)}${lineText.replaceFirst(RegExp(r'^\d+\.\s*'), '')}${text.substring(lineEnd)}'
        : '${text.substring(0, lineStart)}${_getNextNumber(text, lineStart)}$lineText${text.substring(lineEnd)}';

    // Update the text field value
    textEditingController.value = TextEditingValue(
      text: updatedText,
      selection: TextSelection.collapsed(offset: updatedText.length),
    );
  }

  String _getNextNumber(String text, int lineStart) {
    int lineNumber = 1;

    // Extract the text before the current line
    final String previousText = text.substring(0, lineStart);
    final List<String> previousLines = previousText.split('\n');

    // Iterate over previous lines to find the highest number
    for (final line in previousLines) {
      final match = RegExp(r'^(\d+)\.\s*').firstMatch(line);
      if (match != null) {
        final number = int.parse(match.group(1)!);
        if (number >= lineNumber) {
          lineNumber = number + 1;
        }
      }
    }

    return '$lineNumber. ';
  }
}
