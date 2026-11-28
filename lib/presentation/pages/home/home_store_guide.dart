import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

/// First-time coach mark on Home that highlights the Store selector.
class HomeStoreGuide {
  HomeStoreGuide._();

  static const String seenKey = 'home_store_guide_seen';

  /// True while the guide has not been seen. Does not write anything.
  static Future<bool> shouldShow(SharedPreferences prefs) async =>
      !(prefs.getBool(seenKey) ?? false);

  static Future<void> markSeen(SharedPreferences prefs) =>
      prefs.setBool(seenKey, true);

  /// Completes once [route]'s push transition has finished (immediately if it
  /// has no animation or already finished). The coach mark measures its target
  /// once, so it must not be shown while the page is still sliding in.
  static Future<void> waitForRouteTransition(ModalRoute<dynamic>? route) {
    final animation = route?.animation;
    if (animation == null || animation.status == AnimationStatus.completed) {
      return Future<void>.value();
    }
    final done = Completer<void>();
    void listener(AnimationStatus status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        animation.removeStatusListener(listener);
        done.complete();
      }
    }

    animation.addStatusListener(listener);
    return done.future;
  }

  /// Builds the one-target coach mark. [onClose] runs at most once, however
  /// the guide ends (button, skip, finish, overlay tap, target tap).
  /// [onTapTarget] runs when the highlighted area is tapped.
  static TutorialCoachMark build({
    required GlobalKey target,
    required String title,
    required String body,
    required String buttonLabel,
    required VoidCallback onTapTarget,
    required VoidCallback onClose,
  }) {
    var closed = false;
    void closeOnce() {
      if (closed) return;
      closed = true;
      onClose();
    }

    return TutorialCoachMark(
      targets: [
        TargetFocus(
          identify: 'home_store_selector',
          keyTarget: target,
          shape: ShapeLightFocus.RRect,
          radius: 16,
          enableOverlayTab: true,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (context, controller) {
                final theme = Theme.of(context);
                final scheme = theme.colorScheme;
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: scheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        body,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: FilledButton(
                          onPressed: controller.skip,
                          child: Text(buttonLabel),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ],
      hideSkip: true,
      onClickTarget: (_) => onTapTarget(),
      onSkip: () {
        closeOnce();
        return true;
      },
      onFinish: closeOnce,
    );
  }
}
