import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import '../../../util/util.dart';
import '../../widget/widget.dart';

class HelpPage extends StatefulWidget {
  final String title;
  final String content;

  HelpPage({Key? key, required this.title, required this.content})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HelpPageState();
  }
}

class HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SettingsScaffold(
      title: widget.title,
      body: Markdown(
        data: widget.content,
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
          p: theme.textTheme.bodyMedium?.copyWith(
            height: 1.55,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
          ),
          h1: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          h2: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w800),
          h3: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          listBullet: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
          ),
          blockquoteDecoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: BorderSide(
                color: theme.colorScheme.primary.withValues(alpha: 0.4),
                width: 3,
              ),
            ),
          ),
          blockquotePadding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          a: TextStyle(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        onTapLink: (text, url, title) {
          NavigatorUtils.openUrl(url!);
        },
      ),
    );
  }
}
