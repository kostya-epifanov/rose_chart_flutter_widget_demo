import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MeasureSizeRenderObject extends RenderProxyBox {
  final Function(Size size) onChange;

  MeasureSizeRenderObject(this.onChange);

  Size? oldSize;

  @override
  void performLayout() {
    super.performLayout();

    final newSize = child?.size;

    if (oldSize == newSize) return;
    oldSize = newSize;

    if (newSize != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => onChange(newSize));
    }
  }
}

class MeasureSize extends SingleChildRenderObjectWidget {
  final Function(Size size) onChange;

  const MeasureSize({
    required this.onChange,
    required Widget child,
  }) : super(child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MeasureSizeRenderObject(onChange);
  }
}
