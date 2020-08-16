import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_list/model/todo.dart';
import 'package:todo_list/platform_channel/platform_channel.dart';

/// 支持用户点击弹出的日期选择器组件
class LocationFieldGroup extends StatefulWidget {
  const LocationFieldGroup({
    Key key,
    @required this.child,
    this.onChange,
  }) : super(key: key);

  final Function(Location) onChange;

  /// 用来展示选择的位置的组件
  final Widget child;

  @override
  _LocationFieldGroupState createState() => _LocationFieldGroupState();
}

class _LocationFieldGroupState extends State<LocationFieldGroup> {
  bool isLoading;

  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AbsorbPointer(
          child: Stack(
        children: <Widget>[
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(),
          Opacity(
            child: widget.child,
            opacity: isLoading ? 0.5 : 1.0,
          )
        ],
      )),
      onTap: () async {
        setState(() {
          isLoading = true;
        });
        Location location = await PlatformChannel.getCurrentLocation();
        if (widget.onChange != null) {
          widget.onChange(location);
        }
        setState(() {
          isLoading = false;
        });
      },
    );
  }
}
