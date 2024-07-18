import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:note_taking_app/constants/colors.dart';
import 'package:note_taking_app/views/loading/loading_screen_controller.dart';

class LoadinScreen {
  LoadinScreen._sharedInstance();
  static final LoadinScreen _shared = LoadinScreen._sharedInstance();
  factory LoadinScreen.instance() => _shared;

  LoadingScreenController? _controller;

  void show({
    required BuildContext context,
    String text = 'Loading',
  }) {
    if (_controller?.update(text) ?? false) {
      return;
    } else {
      _controller = showOverlay(context: context, text: text);
    }
  }

  void hide() {
    _controller?.close();
    _controller = null;
  }

  LoadingScreenController? showOverlay({
    required BuildContext context,
    required String text,
  }) {
    final state = Overlay.of(context);

    // if (state == null) {
    //   return null;
    // }

    final textController = StreamController<String>();
    textController.add(text);

    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: CustomColors.overlay,
          child: Center(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 4,
                sigmaY: 4,
              ),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: size.height * 0.8,
                  maxWidth: size.width * 0.8,
                  minWidth: size.width * 0.5,
                ),
                decoration: BoxDecoration(
                    color: CustomColors.glass,
                    borderRadius: BorderRadius.circular(22)),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const CircularProgressIndicator(
                        color: Color(CustomColors.lavender),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      StreamBuilder(
                        stream: textController.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.requireData,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: const Color(CustomColors.navy),
                                  ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
    state.insert(overlay);
    return LoadingScreenController(
      close: () {
        textController.close();
        overlay.remove();
        return true;
      },
      update: (text) {
        textController.add(text);
        return true;
      },
    );
  }
}
