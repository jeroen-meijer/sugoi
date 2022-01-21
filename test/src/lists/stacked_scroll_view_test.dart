import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sugoi/sugoi.dart';

void main() {
  group('StackedScrollView', () {
    Widget buildSubject({
      bool? alignToTop,
      Axis? scrollDirection,
      bool? reverse,
      EdgeInsets? padding,
      bool? primary,
      ScrollPhysics? physics,
      ScrollController? controller,
      DragStartBehavior? dragStartBehavior,
      Clip? clipBehavior,
      String? restorationId,
      ScrollViewKeyboardDismissBehavior? keyboardDismissBehavior,
      Widget? foregroundChild,
      Widget? backgroundChild,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: StackedScrollView(
            alignToTop: alignToTop ?? true,
            scrollDirection: scrollDirection ?? Axis.vertical,
            reverse: reverse ?? false,
            padding: padding,
            primary: primary,
            physics: physics,
            controller: controller,
            dragStartBehavior: dragStartBehavior ?? DragStartBehavior.start,
            clipBehavior: clipBehavior ?? Clip.hardEdge,
            restorationId: restorationId,
            keyboardDismissBehavior: keyboardDismissBehavior ??
                ScrollViewKeyboardDismissBehavior.manual,
            foregroundChild: foregroundChild ?? const Text('foreground'),
            backgroundChild: backgroundChild ??
                Column(
                  children: const [
                    Text('child 1'),
                    Text('child 2'),
                    Text('child 3'),
                  ],
                ),
          ),
        ),
      );
    }

    testWidgets('renders foreground child', (tester) async {
      await tester.pumpWidget(
        buildSubject(
          foregroundChild: const Text('foreground'),
        ),
      );

      expect(find.text('foreground'), findsOneWidget);
    });

    testWidgets('renders background child', (tester) async {
      await tester.pumpWidget(
        buildSubject(
          backgroundChild: Column(
            children: const [
              Text('child 1'),
              Text('child 2'),
              Text('child 3'),
            ],
          ),
        ),
      );

      expect(find.text('child 1'), findsOneWidget);
      expect(find.text('child 2'), findsOneWidget);
      expect(find.text('child 3'), findsOneWidget);
    });

    testWidgets(
      'renders background child with top padding '
      'with the height of the foreground child '
      'when alignToTop is true',
      (tester) async {
        await tester.pumpWidget(
          buildSubject(
            foregroundChild: const SizedBox(
              height: 300,
            ),
          ),
        );
        await tester.pump();

        expect(
          tester.widget(find.byType(SingleChildScrollView)),
          isA<SingleChildScrollView>().having(
            (w) => w.padding,
            'padding',
            equals(const EdgeInsets.only(top: 300)),
          ),
        );
      },
    );

    testWidgets(
      'renders background child with bottom padding '
      'with the height of the foreground child '
      'when alignToTop is false',
      (tester) async {
        await tester.pumpWidget(
          buildSubject(
            alignToTop: false,
            foregroundChild: const SizedBox(
              height: 300,
            ),
          ),
        );
        await tester.pump();

        expect(
          tester.widget(find.byType(SingleChildScrollView)),
          isA<SingleChildScrollView>().having(
            (w) => w.padding,
            'padding',
            equals(const EdgeInsets.only(bottom: 300)),
          ),
        );
      },
    );

    testWidgets('passes scroll view parameters', (tester) async {
      final controller = ScrollController();

      await tester.pumpWidget(
        buildSubject(
          scrollDirection: Axis.horizontal,
          reverse: true,
          primary: false,
          physics: const BouncingScrollPhysics(),
          controller: controller,
          dragStartBehavior: DragStartBehavior.down,
          clipBehavior: Clip.hardEdge,
          restorationId: 'test-id',
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
          backgroundChild: const Text('background'),
        ),
      );

      final finder = find.ancestor(
        of: find.text('background'),
        matching: find.byType(SingleChildScrollView),
      );

      expect(finder, findsOneWidget);
      expect(
        tester.widget(finder),
        isA<SingleChildScrollView>()
            .having((w) => w.reverse, 'reserve', isTrue)
            .having((w) => w.primary, 'primary', isFalse)
            .having((w) => w.physics, 'physics', isA<BouncingScrollPhysics>())
            .having((w) => w.controller, 'controller', same(controller))
            .having(
              (w) => w.dragStartBehavior,
              'dragStartBehavior',
              equals(DragStartBehavior.down),
            )
            .having(
              (w) => w.clipBehavior,
              'clipBehavior',
              equals(Clip.hardEdge),
            )
            .having((w) => w.restorationId, 'restorationId', equals('test-id'))
            .having(
              (w) => w.keyboardDismissBehavior,
              'keyboardDismissBehavior',
              equals(ScrollViewKeyboardDismissBehavior.manual),
            ),
      );
    });

    testWidgets(
      'adjusts background padding when foreground size changes',
      (tester) async {
        await tester.pumpWidget(
          buildSubject(
            foregroundChild: const _SizeTransitioner(
              initialHeight: 100,
              child: Text('foreground'),
            ),
          ),
        );
        await tester.pump();

        expect(
          tester.widget(find.byType(SingleChildScrollView)),
          isA<SingleChildScrollView>().having(
            (w) => w.padding,
            'padding',
            equals(const EdgeInsets.only(top: 100)),
          ),
        );

        tester
            .state<__SizeTransitionerState>(find.byType(_SizeTransitioner))
            .setHeight(300);

        await tester.pump();
        await tester.pump();

        expect(
          tester.widget(find.byType(SingleChildScrollView)),
          isA<SingleChildScrollView>().having(
            (w) => w.padding,
            'padding',
            equals(const EdgeInsets.only(top: 300)),
          ),
        );
      },
    );
  });
}

class _SizeTransitioner extends StatefulWidget {
  const _SizeTransitioner({
    Key? key,
    required this.initialHeight,
    required this.child,
  }) : super(key: key);

  final double initialHeight;
  final Widget child;

  @override
  __SizeTransitionerState createState() => __SizeTransitionerState();
}

class __SizeTransitionerState extends State<_SizeTransitioner> {
  late double _height;

  @override
  void initState() {
    super.initState();
    _height = widget.initialHeight;
  }

  void setHeight(double height) {
    setState(() {
      _height = height;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      child: widget.child,
    );
  }
}
