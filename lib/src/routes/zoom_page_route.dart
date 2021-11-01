import 'package:flutter/material.dart';

/// {@template zoom_page_route}
/// A page route that transitions using a zoom animation.
///
/// The old page will scale up by 20% when this route transitions in, while the
/// new page will be zoomed into from 80% to 100%. Simultaneously, the old page
/// will be faded out while the new page fades in, creating a fading and scaling
/// transition effect.
///
/// A `transitionCurve` and `transitionDuration` can be provided to customize
/// the transition animation.
///
/// The animation is built by [createTranstionBuilder].
/// {@endtemplate}
class ZoomPageRoute<T> extends PageRouteBuilder<T> {
  /// {@macro zoom_page_route}
  ZoomPageRoute({
    Curve transitionCurve = Curves.linearToEaseOut,
    Duration transitionDuration = const Duration(milliseconds: 500),
    required WidgetBuilder builder,
  }) : super(
          transitionDuration: transitionDuration,
          transitionsBuilder: createTranstionBuilder(transitionCurve),
          pageBuilder: (context, _, __) {
            return builder(context);
          },
        );

  /// Creates a [RouteTransitionsBuilder] that uses the given [Curve] that
  /// builds a fading and scaling transition.
  static RouteTransitionsBuilder createTranstionBuilder(Curve curve) {
    return (context, animationIn, animationOut, child) {
      final reverseCurve = curve.flipped;

      final opacityAnimationIn = CurvedAnimation(
        parent: animationIn,
        curve: curve,
        reverseCurve: reverseCurve,
      );
      final opacityAnimationOut = CurvedAnimation(
        parent: animationOut.drive(Tween(begin: 1, end: 0)),

        // Note: in practice, this curve is flipped because of how the
        //   value is used within the transition.
        //
        // If `curve: curve` is set, the page will lose opacity very
        //   slowly at the start and then drop off sharp near the end
        //   (essentially the same as `curve.flipped`,
        //   i.e., `reverseCurve`).
        // If `curve: reverseCurve` is set, the animation will exhibit
        //   the behavior expected of `curve` (unflipped), and the
        //   opacity will start with a fast dropoff and then slowly
        //   settles.
        curve: reverseCurve,
        reverseCurve: curve,
      );
      final scaleAnimationIn = CurvedAnimation(
        parent: animationIn,
        curve: curve,
        reverseCurve: reverseCurve,
      ).drive<double>(Tween(begin: 0.8, end: 1));
      final scaleAnimationOut = CurvedAnimation(
        parent: animationOut,
        curve: curve,
        reverseCurve: reverseCurve,
      ).drive<double>(Tween(begin: 1, end: 1.2));

      return FadeTransition(
        opacity: opacityAnimationIn,
        child: FadeTransition(
          opacity: opacityAnimationOut,
          child: ScaleTransition(
            scale: scaleAnimationIn,
            child: ScaleTransition(
              scale: scaleAnimationOut,
              child: child,
            ),
          ),
        ),
      );
    };
  }
}
