import 'package:flutter/widgets.dart';

typedef OptionItemViewBuilder = Widget Function(
    BuildContext context, String option, int index);
typedef OptionChanged = void Function(
    BuildContext context, String option, int index);

class ScrollOptionView extends StatefulWidget {
  final List<String> options;
  final OptionItemViewBuilder itemBuilder;
  final OptionItemViewBuilder activeItemBuilder;
  final OptionChanged onOptionChanged;
  final int activeIndex;

  ScrollOptionView({
    Key key,
    @required this.options,
    this.itemBuilder,
    this.activeItemBuilder,
    this.onOptionChanged,
    this.activeIndex = 0,
  })  : assert(options != null),
        super(key: key);

  @override
  _ScrollOptionViewState createState() => _ScrollOptionViewState();
}

class _ScrollOptionViewState extends State<ScrollOptionView> {
  int _activeIndex = 0;
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _activeIndex = _getSafeActiveIndex(widget.activeIndex);
  }

  @override
  void didUpdateWidget(ScrollOptionView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.activeIndex != widget.activeIndex) {
      _activeIndex = _getSafeActiveIndex(widget.activeIndex);
      if (widget.onOptionChanged != null) {
        widget.onOptionChanged(context, widget.options[_activeIndex], _activeIndex);
      }
    }
  }

  int _getSafeActiveIndex(activeIndex) {
    if (activeIndex < 0) {
      return 0;
    }
    if (activeIndex >= widget.options.length) {
      return widget.options.length;
    }
    return activeIndex;
  }

  @override
  Widget build(BuildContext context) {
    List<String> options = widget.options;
    return AnimatedList(
      scrollDirection: Axis.horizontal,
      initialItemCount: options.length,
      itemBuilder: (context, index, animation) =>
          _buildRow(context, options[index], index),
    );
  }

  Widget _buildRow(BuildContext context, String option, int index) {
    Widget content;
    if (_activeIndex == index) {
      if (widget.activeItemBuilder != null) {
        content = widget.activeItemBuilder(context, option, index);
      } else {
        content = Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xffebebec)),
            color: const Color(0xffb6b6b8),
          ),
          child: Text(option),
        );
      }
    } else {
      if (widget.itemBuilder != null) {
        content = widget.itemBuilder(context, option, index);
      } else {
        content = Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xffebebec)),
            ),
            child: Text(option));
      }
    }

    return GestureDetector(
      child: content,
      onTap: () {
        this.setState(() {
          _activeIndex = index;
        });
        if (widget.onOptionChanged != null) {
          widget.onOptionChanged(context, option, index);
        }
      },
    );
  }
}
