import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// {@template stacked_scroll_view}
/// A widget that displays a scrollable view behind another widget.
///
/// This widget is typically used to display a search bar at the top or a button
/// at the bottom of a scrollable view. The scrollable [backgroundChild] will
/// have padding applied to it so that the content of the scrollable view will
/// be offset properly to account for [foregroundChild].
///
/// For example, if [alignToTop] is `true`, the [foregroundChild] will be placed
/// at the top and the scrollable [backgroundChild] will have padding applied to
/// the top to account for the size of the [foregroundChild], but once scrolled,
/// the background content will behind and past the foreground, while the latter
/// stays fixed in place.
/// {@endtemplate}
class StackedScrollView extends StatefulWidget {
  /// {@macro stacked_scroll_view}
  const StackedScrollView({
    Key? key,
    this.alignToTop = true,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.padding,
    this.primary,
    this.physics,
    this.controller,
    this.dragStartBehavior = DragStartBehavior.start,
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    required this.foregroundChild,
    required this.backgroundChild,
  }) : super(key: key);

  /// Whether to align the [foregroundChild] to the top of the scrollable view.
  ///
  /// If `true`, the [foregroundChild] and the padding necessary to account for
  /// it will be placed at the top of the scrollable view. Otherwise, they will
  /// be placed at the bottom.
  final bool alignToTop;

  /// The direction in which this widget scrolls.
  final Axis scrollDirection;

  /// Whether the scroll view scrolls in the reading direction.
  final bool reverse;

  /// The amount of space by which to inset the [foregroundChild].
  final EdgeInsets? padding;

  /// Whether this is the primary scroll view associated with the parent
  final bool? primary;

  /// How the scroll view should respond to user input.
  final ScrollPhysics? physics;

  /// The controller that manages the scroll view.
  final ScrollController? controller;

  /// {@macro flutter.widgets.scrollable.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  /// The clipping behavior to use.
  final Clip clipBehavior;

  /// {@macro flutter.widgets.scrollable.restorationId}
  final String? restorationId;

  /// How this scroll view should dismiss the on-screen keyboard.
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  /// The widget to show in front of the [backgroundChild].
  ///
  /// Depending on [alignToTop], this widget will either be placed at the top
  /// or the bottom of the viewport. The height of this widget will determine
  /// how much padding is applied to the appropriate side of the scrollable
  /// [backgroundChild].
  final Widget foregroundChild;

  /// The scrollable widget to show behind the [foregroundChild].
  ///
  /// This widget will have padding applied to it so that the content of the
  /// scrollable view will be offset properly to account for the size of the
  /// [foregroundChild]. Where this padding is applied is determined by
  /// [alignToTop].
  final Widget backgroundChild;

  @override
  State<StackedScrollView> createState() => _StackedScrollViewState();
}

class _StackedScrollViewState extends State<StackedScrollView> {
  final _foregroundKey = GlobalKey();

  var _foregroundHeight = 0.0;

  @override
  void initState() {
    super.initState();
    _scheduleForegroundHeightUpdate();
  }

  void _scheduleForegroundHeightUpdate() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        _foregroundHeight = _foregroundKey.currentContext!.size!.height;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final foregroundInsets = EdgeInsets.only(
      top: widget.alignToTop ? _foregroundHeight : 0.0,
      bottom: widget.alignToTop ? 0.0 : _foregroundHeight,
    );
    final effectivePadding =
        (widget.padding ?? EdgeInsets.zero).add(foregroundInsets);

    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (notification) {
        _scheduleForegroundHeightUpdate();
        return true;
      },
      child: Stack(
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: widget.scrollDirection,
            reverse: widget.reverse,
            padding: effectivePadding,
            primary: widget.primary,
            physics: widget.physics,
            controller: widget.controller,
            dragStartBehavior: widget.dragStartBehavior,
            clipBehavior: widget.clipBehavior,
            restorationId: widget.restorationId,
            keyboardDismissBehavior: widget.keyboardDismissBehavior,
            child: widget.backgroundChild,
          ),
          Align(
            alignment: widget.alignToTop
                ? Alignment.topCenter
                : Alignment.bottomCenter,
            child: SizeChangedLayoutNotifier(
              key: _foregroundKey,
              child: widget.foregroundChild,
            ),
          )
        ],
      ),
    );
  }
}
