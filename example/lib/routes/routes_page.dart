import 'package:flutter/material.dart';
import 'package:sugoi/sugoi.dart';
import 'package:sugoi_gallery/routes/routes.dart';

class RoutesPage extends StatelessWidget {
  const RoutesPage({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const RoutesPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Routes'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.zoom_out_map_rounded),
            title: const Text('Zoom Page Route'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                RouteDemoPage.route(
                  title: 'ZoomPageRoute',
                  builder: (child) {
                    return ZoomPageRoute(
                      builder: (context) => child,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
