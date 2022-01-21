import 'package:flutter/material.dart';
import 'package:sugoi_gallery/lists/lists.dart';

class ListWidgetsPage extends StatelessWidget {
  const ListWidgetsPage({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const ListWidgetsPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Widgets'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.list_alt_rounded),
            title: const Text('StackedScrollView'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(StackedScrollViewPage.route());
            },
          ),
        ],
      ),
    );
  }
}
