import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveScaffold extends StatelessWidget {
  final String title;
  final Widget child;

  const AdaptiveScaffold({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return isIOS
        ? CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(middle: Text(title)),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 44,
            ), // Offset for Cupertino NavBar
            child: child,
          ),
        )
        : Scaffold(
          appBar: AppBar(
            title: Align(alignment: Alignment.centerLeft, child: Text(title)),
          ),
          body: child,
        );
  }
}
