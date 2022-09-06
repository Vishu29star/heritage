import 'package:Heritage/utils/extension.dart';
import 'package:flutter/material.dart';

class RoundedExpansionTile extends StatefulWidget {
  final bool? autofocus;
  final EdgeInsetsGeometry? contentPadding;
  final bool? dense;
  final bool? enabled;
  final bool? enableFeedback;
  final Color? focusColor;
  final FocusNode? focusNode;
  final double? horizontalTitleGap;
  final Color? hoverColor;
  final bool? isThreeLine;
  final Key? key;
  final Widget? leading;
  final double? minLeadingWidth;
  final double? minVerticalPadding;
  final MouseCursor? mouseCursor;
  final void Function()? onLongPress;
  final bool? selected;
  final Color? selectedTileColor;
  final ShapeBorder? shape;
  final Widget? subtitle;
  final Widget? title;
  final Color? tileColor;
  final Widget? trailing;
  final VisualDensity? visualDensity;
  final void Function()? onTap;
  final Duration? duration;
  final List<Widget>? children;
  final Curve? curve;
  final EdgeInsets? childrenPadding;
  final bool? rotateTrailing;
  final bool? noTrailing;

  RoundedExpansionTile(
      {this.title,
        this.subtitle,
        this.leading,
        this.trailing,
        this.duration,
        this.children,
        this.autofocus,
        this.contentPadding,
        this.dense,
        this.enabled,
        this.enableFeedback,
        this.focusColor,
        this.focusNode,
        this.horizontalTitleGap,
        this.hoverColor,
        this.isThreeLine,
        this.key,
        this.minLeadingWidth,
        this.minVerticalPadding,
        this.mouseCursor,
        this.onLongPress,
        this.selected,
        this.selectedTileColor,
        this.shape,
        this.tileColor,
        this.visualDensity,
        this.onTap,
        this.curve,
        this.childrenPadding,
        this.rotateTrailing,
        this.noTrailing});

  @override
  _RoundedExpansionTileState createState() => _RoundedExpansionTileState();
}

class _RoundedExpansionTileState extends State<RoundedExpansionTile>
    with TickerProviderStateMixin {
  late bool _expanded;
  bool? _rotateTrailing;
  bool? _noTrailing;
  late AnimationController _controller;
  late AnimationController _iconController;

  // When the duration of the ListTile animation is NOT provided. This value will be used instead.
  Duration defaultDuration = Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _expanded = false;
    // If not provided, this will be true
    _rotateTrailing =
    widget.rotateTrailing == null ? true : widget.rotateTrailing;
    // If not provided this will be false
    _noTrailing = widget.noTrailing == null ? false : widget.noTrailing;
    _controller = AnimationController(
        vsync: this,
        duration: widget.duration == null ? defaultDuration : widget.duration);

    _iconController = AnimationController(
      duration: widget.duration == null ? defaultDuration : widget.duration,
      vsync: this,
    );

    _controller.forward();
    // _iconController.forward();
  }

  @override
  void dispose() {
    if (mounted) {
      _controller.dispose();
      _iconController.dispose();
      super.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      elevation: 1,
      child: ClipRRect(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [

              InkWell(
                onTap: (){
                  setState(() {
                    // Checks if the ListTile is expanded and sets state accordingly.
                    if (_expanded) {
                      _expanded = !_expanded;
                      _controller.forward();
                      _iconController.reverse();
                    } else {
                      _expanded = !_expanded;
                      _controller.reverse();
                      _iconController.forward();
                    }
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: context.resources.color.colorPrimary,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(40))
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      widget.title!,
                      _trailingIcon()!,
                    ],
                  ),
                ),
              ),
              AnimatedCrossFade(
                  firstCurve: widget.curve == null
                      ? Curves.fastLinearToSlowEaseIn
                      : widget.curve!,
                  secondCurve: widget.curve == null
                      ? Curves.fastLinearToSlowEaseIn
                      : widget.curve!,
                  crossFadeState: _expanded
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration:
                  widget.duration == null ? defaultDuration : widget.duration!,
                  firstChild:

                  /// Returns Listviews for the children.
                  ///
                  /// ClampingScrollPhyiscs so the ListTile will scroll in the main screen and not its children.
                  /// Shrinkwrap is always true so the ExpansionTile will wrap its children and hide when not expanded.
                  ListView(
                    physics: ClampingScrollPhysics(),
                    padding: widget.childrenPadding ?? EdgeInsets.zero,
                    shrinkWrap: true,
                    children: widget.children!,
                  ),
                  // If not expanded just returns an empty containter so the ExpansionTile will only show the ListTile.
                  secondChild: Container()),
            ]),
      ),
    );
  }

  // Build trailing widget based on the user input.
  Widget? _trailingIcon() {
    if (widget.trailing != null) {
      if (_rotateTrailing!) {
        return RotationTransition(
            turns: Tween(begin: 0.0, end: 0.5).animate(_iconController),
            child: widget.trailing);
      } else {
        // If developer sets rotateTrailing to false the widget will just be returned.
        return widget.trailing;
      }
    } else {
      // Default trailing is an Animated Menu Icon.
      return AnimatedIcon(
          icon: AnimatedIcons.close_menu, progress: _controller);
    }
  }
}