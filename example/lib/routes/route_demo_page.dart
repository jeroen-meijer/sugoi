import 'package:flutter/material.dart';

class RouteDemoPage extends StatelessWidget {
  RouteDemoPage({
    Key? key,
    required this.title,
    required this.builder,
  })  : color = ([...Colors.primaries]..shuffle()).first,
        super(key: key);

  final String title;
  final Route<void> Function(Widget) builder;
  final Color color;

  static Route<void> route({
    required String title,
    required Route<void> Function(Widget) builder,
  }) {
    return builder(RouteDemoPage(title: title, builder: builder));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Row(
          children: [
            // "Back" and "Forward" button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              label: const Text('Back'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  builder(
                    RouteDemoPage(
                      title: title,
                      builder: builder,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.arrow_forward_ios_rounded),
              label: const Text('Forward'),
            ),
          ],
        ),
      ),
    );
  }
}
