import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Takes in a text or an icon that fades out and in on touch. May optionally have a
/// background.
class TappableDialog extends StatefulWidget {
  const TappableDialog({
    Key key,
    @required this.child,
    this.padding = EdgeInsets.zero,
    this.minSize = 1.0,
    this.pressedOpacity = 0.1,
    @required this.onTap,
    this.group,
  }) : assert(pressedOpacity == null || (pressedOpacity >= 0.0 && pressedOpacity <= 1.0)),
        super(key: key);

  /// The widget below this widget in the tree.
  ///
  /// Typically a [Text] widget.
  final Widget child;

  /// The amount of space to surround the child inside the bounds of the button.
  ///
  /// Defaults to 16.0 pixels.
  final EdgeInsetsGeometry padding;

  /// The callback that is called when the button is tapped or otherwise activated.
  ///
  /// If this is set to null, the button will be disabled.
  final VoidCallback onTap;

  /// Minimum size of the button.
  ///
  /// Defaults to kMinInteractiveDimensionCupertino which the iOS Human
  /// Interface Guidelines recommends as the minimum tappable area.
  final double minSize;

  /// The opacity that the button will fade to when it is pressed.
  /// The button will have an opacity of 1.0 when it is not pressed.
  ///
  /// This defaults to 0.1. If null, opacity will not change on pressed if using
  /// your own custom effects is desired.
  final double pressedOpacity;

  final ATappableGroup group;

  /// Whether the button is enabled or disabled. Buttons are disabled by default. To
  /// enable a button, set its [onTap] property to a non-null value.
  bool get enabled => onTap != null;

  @override
  _TappableDialogState createState() => _TappableDialogState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(FlagProperty('enabled', value: enabled, ifFalse: 'disabled'));
  }
}

class _TappableDialogState extends State<TappableDialog> with SingleTickerProviderStateMixin {
  // Eyeballed values. Feel free to tweak.
  static const Duration kFadeOutDuration = Duration(milliseconds: 10);
  static const Duration kFadeInDuration = Duration(milliseconds: 100);
  final Tween<double> _opacityTween = Tween<double>(begin: 1.0);

  AnimationController _animationController;
  Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      value: 0.0,
      vsync: this,
    );
    _opacityAnimation = _animationController
        .drive(CurveTween(curve: Curves.decelerate))
        .drive(_opacityTween);
    _setTween();
  }

  @override
  void didUpdateWidget(TappableDialog old) {
    super.didUpdateWidget(old);
    _setTween();
  }

  void _setTween() {
    _opacityTween.end = widget.pressedOpacity ?? 1.0;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _animationController = null;
    super.dispose();
  }

  bool _buttonHeldDown = false;

  void _handleTapDown(TapDownDetails event) {
    //print('handle tap down');
    if(!(widget.group?.tryLock(this) ?? true)) return;
    if (!_buttonHeldDown) {
      _buttonHeldDown = true;
      _animate();
    }
  }

  void _handleTapUp(TapUpDetails event) {
    //print('handle tap up');
    if(!(widget.group?.tryUnlock(this) ?? true)) return;
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animate();
    }
  }

  void _handleTapCancel() {
    //print('handle tap cancel');
    if(!(widget.group?.tryUnlock(this) ?? true)) return;
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animate();
    }
  }

  void _animate() {
    if (_animationController.isAnimating)
      return;
    final bool wasHeldDown = _buttonHeldDown;
    final TickerFuture ticker = _buttonHeldDown
        ? _animationController.animateTo(1.0, duration: kFadeOutDuration)
        : _animationController.animateTo(0.0, duration: kFadeInDuration);
    ticker.then<void>((void value) {
      if (mounted && wasHeldDown != _buttonHeldDown)
        _animate();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool enabled = widget.enabled;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: enabled ? _handleTapDown : null,
      onTapUp: enabled ? _handleTapUp : null,
      onTapCancel: enabled ? _handleTapCancel : null,
      onTap: widget.onTap,
      onLongPress: () {
        // declare this to avoid passing long presses to OTextFields placed under
        // OTappable
      },
      child: Semantics(
        button: true,
        child: ConstrainedBox(
          constraints: widget.minSize == null
              ? const BoxConstraints()
              : BoxConstraints(
            minWidth: widget.minSize,
            minHeight: widget.minSize,
          ),
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: Padding(
              padding: widget.padding,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}

// TODO: use it everywhere instead of manual creation&disposing of OTappableGroup
class OTappableGroupBuilder extends StatefulWidget {

  final Widget Function(BuildContext context, ATappableGroup group) builder;

  const OTappableGroupBuilder({
    Key key,
    @required this.builder,
  }) : super(key: key);

  @override
  _OTappableGroupBuilderState createState() => _OTappableGroupBuilderState();
}

class _OTappableGroupBuilderState extends State<OTappableGroupBuilder> {

  ATappableGroup _group;

  @override
  void initState() {
    super.initState();
    _group = ATappableGroup();
  }

  @override
  void dispose() {
    _group.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _group);
  }
}


/// little helper that fixes this issue
/// https://github.com/flutter/flutter/issues/14417
class ATappableGroup {
  dynamic currentAnchor;

  bool tryLock(dynamic anchor) {
    print('[?] try to lock by $anchor');
    if(currentAnchor != null) return false;
    print('[+] locked by $anchor');
    currentAnchor = anchor;
    return true;
  }

  bool isLockedBy(dynamic anchor) {
    return anchor == currentAnchor;
  }

  bool tryUnlock(dynamic anchor) {
    print('[?] try unlock by $anchor');
    if(currentAnchor == anchor) {
      print('[+] unlocked by $anchor');
      currentAnchor = null;
      return true;
    }
    return false;
  }

  void dispose() {
    currentAnchor = null;
  }
}