import 'package:flutter/material.dart';
import 'package:sugoi_gallery/lists/lists.dart';
import 'package:sugoi_gallery/routes/routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sugoi Gallery'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.navigation_rounded),
            title: const Text('Navigation Routes'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).push(RoutesPage.route());
            },
          ),
          ListTile(
            leading: const Icon(Icons.list_rounded),
            title: const Text('List Widgets'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).push(ListWidgetsPage.route());
            },
          ),
        ],
      ),
    );
  }
}
