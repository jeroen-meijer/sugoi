import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sugoi/sugoi.dart';

void main() {
  group('ZoomPageRoute', () {
    const transitionChildKey = Key('transition-child');

    Route<void> buildRoute({
      Curve transitionCurve = Curves.linearToEaseOut,
      Duration transitionDuration = const Duration(milliseconds: 500),
      Widget? child,
    }) {
      return ZoomPageRoute(
        transitionCurve: transitionCurve,
        transitionDuration: transitionDuration,
        builder: (context) => child ?? const SizedBox(key: transitionChildKey),
      );
    }

    Widget buildTransition({
      double transitionProgress = 0.0,
    }) {
      assert(
        transitionProgress >= 0.0 && transitionProgress <= 1.0,
        'transitionProgress must be between 0.0 and 1.0',
      );

      final builder = ZoomPageRoute.createTranstionBuilder(
        Curves.linearToEaseOut,
      );
      return MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return builder(
                context,
                AlwaysStoppedAnimation(transitionProgress),
                AlwaysStoppedAnimation(1 - transitionProgress),
                const SizedBox(
                  key: transitionChildKey,
                ),
              );
            },
          ),
        ),
      );
    }

    test('is a page route', () {
      expect(buildRoute(), isA<PageRoute>());
    });

    group('transitionDuration', () {
      test('is set to 500 milliseconds by default', () {
        expect(
          buildRoute(),
          isA<ZoomPageRoute>().having(
            (r) => r.transitionDuration,
            'transitionDuration',
            equals(const Duration(milliseconds: 500)),
          ),
        );
      });

      test('is set to custom value when provided', () {
        expect(
          buildRoute(transitionDuration: const Duration(milliseconds: 100)),
          isA<ZoomPageRoute>().having(
            (r) => r.transitionDuration,
            'transitionDuration',
            equals(const Duration(milliseconds: 100)),
          ),
        );
      });
    });

    testWidgets('pageBuilder renders child', (tester) async {
      const routeButtonKey = Key('route-button');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return TextButton(
                  key: routeButtonKey,
                  onPressed: () {
                    Navigator.of(context).push(buildRoute());
                  },
                  child: const Text('Route'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(routeButtonKey));
      await tester.pumpAndSettle();

      expect(find.byKey(transitionChildKey), findsOneWidget);
    });

    group('transitionBuilder', () {
      testWidgets('renders child', (tester) async {
        await tester.pumpWidget(buildTransition(transitionProgress: 1));

        expect(find.byKey(transitionChildKey), findsOneWidget);
      });

      testWidgets(
        'renders FadeTransition for inward animation '
        'that starts at 0%',
        (tester) async {
          await tester.pumpWidget(buildTransition());

          expect(find.byType(FadeTransition), findsWidgets);

          final fadeTransitions =
              tester.widgetList(find.byType(FadeTransition));
          expect(
            fadeTransitions,
            contains(
              isA<FadeTransition>().having(
                (t) => t.opacity,
                'opacity',
                isA<Animation<double>>().having((a) => a.value, 'value', 0.0),
              ),
            ),
          );
        },
      );

      testWidgets(
        'renders FadeTransition for outward animation '
        'that starts at 100%',
        (tester) async {
          await tester.pumpWidget(buildTransition());

          expect(find.byType(FadeTransition), findsWidgets);

          final fadeTransitions =
              tester.widgetList(find.byType(FadeTransition));
          expect(
            fadeTransitions,
            contains(
              isA<FadeTransition>().having(
                (t) => t.opacity,
                'opacity',
                isA<Animation<double>>().having((a) => a.value, 'value', 1.0),
              ),
            ),
          );
        },
      );

      testWidgets(
        'renders ScaleTransition for inward animation '
        'that starts at 80%',
        (tester) async {
          await tester.pumpWidget(buildTransition());

          expect(find.byType(ScaleTransition), findsWidgets);

          final scaleTransitions =
              tester.widgetList(find.byType(ScaleTransition));
          expect(
            scaleTransitions,
            contains(
              isA<ScaleTransition>().having(
                (t) => t.scale,
                'scale',
                isA<Animation<double>>().having((a) => a.value, 'value', 0.8),
              ),
            ),
          );
        },
      );

      testWidgets(
        'renders ScaleTransition for outward animation '
        'that starts at 120%',
        (tester) async {
          await tester.pumpWidget(buildTransition());

          expect(find.byType(ScaleTransition), findsWidgets);

          final scaleTransitions =
              tester.widgetList(find.byType(ScaleTransition));
          expect(
            scaleTransitions,
            contains(
              isA<ScaleTransition>().having(
                (t) => t.scale,
                'scale',
                isA<Animation<double>>().having((a) => a.value, 'value', 1.2),
              ),
            ),
          );
        },
      );
    });
  });
}
