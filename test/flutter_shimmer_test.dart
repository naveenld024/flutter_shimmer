import 'package:flutter/material.dart';
import 'package:flutter_auto_shimmer/flutter_auto_shimmer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AutoShimmer test', () {
    final widget = AutoShimmer(child: const SizedBox());
    expect(widget.child, isA<Widget>());
    expect(widget.duration, isA<Duration>());
    expect(widget.baseColor, isA<Color>());
    expect(widget.highlightColor, isA<Color>());
  });
}
