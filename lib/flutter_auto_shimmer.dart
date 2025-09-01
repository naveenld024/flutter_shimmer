import 'package:flutter/material.dart';

/// A widget that automatically applies a shimmer effect to its child widget.
///
/// The shimmer effect creates a smooth, animated gradient that moves across the child,
/// commonly used to indicate loading states or placeholder content. The effect can be
/// controlled through various parameters including duration, colors, and visibility.
///
/// ## Features:
/// - **Automatic animation**: Starts and stops based on the `showShimmer` parameter
/// - **Customizable colors**: Configure base and highlight colors for the shimmer effect
/// - **Adjustable duration**: Control the speed of the shimmer animation
/// - **Border radius preservation**: Attempts to maintain the child's border radius
/// - **Performance optimized**: Uses efficient animation controllers and shader masks
///
/// ## Usage:
/// ```dart
/// AutoShimmer(
///   showShimmer: isLoading,
///   child: Container(
///     height: 100,
///     decoration: BoxDecoration(
///       color: Colors.white,
///       borderRadius: BorderRadius.circular(8),
///     ),
///   ),
/// )
/// ```
///
/// ## Parameters:
/// - [child]: The widget to apply the shimmer effect to
/// - [duration]: The duration of one complete shimmer cycle (default: 2 seconds)
/// - [baseColor]: The base color of the shimmer effect (default: light gray)
/// - [highlightColor]: The highlight color that creates the shimmer effect (default: lighter gray)
/// - [showShimmer]: Whether to show the shimmer effect (default: true)
class AutoShimmer extends StatefulWidget {
  /// The widget to apply the shimmer effect to.
  final Widget child;

  /// The duration of one complete shimmer cycle.
  ///
  /// This controls how fast the shimmer effect moves across the widget.
  /// Defaults to 2 seconds.
  final Duration duration;

  /// The base color of the shimmer effect.
  ///
  /// This is the darker color in the gradient that creates the shimmer effect.
  /// Defaults to a light gray color.
  final Color baseColor;

  /// The highlight color of the shimmer effect.
  ///
  /// This is the brighter color in the gradient that creates the shimmer effect.
  /// Defaults to a lighter gray color.
  final Color highlightColor;

  /// Whether to show the shimmer effect.
  ///
  /// When `false`, the widget simply returns the child without any shimmer effect.
  /// When `true`, the shimmer animation is active.
  /// Defaults to `true`.
  final bool showShimmer;

  /// Creates an AutoShimmer widget.
  ///
  /// The [child] parameter is required and represents the widget that will
  /// receive the shimmer effect.
  const AutoShimmer({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 2),
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
    this.showShimmer = true,
  });

  @override
  State<AutoShimmer> createState() => _AutoShimmerState();
}

/// The state class for [AutoShimmer].
///
/// Manages the animation controller and handles the shimmer effect rendering.
class _AutoShimmerState extends State<AutoShimmer>
    with SingleTickerProviderStateMixin {
  /// The animation controller that drives the shimmer effect.
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller with the specified duration
    _controller = AnimationController(vsync: this, duration: widget.duration);
    // Start the shimmer animation if showShimmer is true
    if (widget.showShimmer) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant AutoShimmer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Handle changes to the showShimmer parameter
    if (widget.showShimmer && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.showShimmer && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    // Clean up the animation controller to prevent memory leaks
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If shimmer is disabled, return the child widget as-is
    if (!widget.showShimmer) {
      return widget.child;
    }

    // Build the shimmer effect using AnimatedBuilder for efficient rebuilds
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return ClipRRect(
          borderRadius: _getBorderRadius(child),
          child: ShaderMask(
            shaderCallback: (bounds) {
              // Create a linear gradient that moves across the widget
              return LinearGradient(
                colors: [
                  widget.baseColor,
                  widget.highlightColor,
                  widget.baseColor,
                ],
                stops: const [0.0, 0.5, 1.0],
                // Animate the gradient position using the controller value
                begin: Alignment(-1.0 + 2.0 * _controller.value, 0.0),
                end: Alignment(1.0 + 2.0 * _controller.value, 0.0),
              ).createShader(bounds);
            },
            blendMode: BlendMode.srcATop,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }

  /// Attempts to extract the border radius from the child widget.
  ///
  /// This method tries to preserve the border radius of the child widget
  /// by examining common widget patterns like Container with BoxDecoration.
  /// If no border radius can be determined, it defaults to BorderRadius.zero.
  ///
  /// [child] is the widget to examine for border radius information.
  /// Returns a BorderRadiusGeometry that should be applied to the shimmer effect.
  BorderRadiusGeometry _getBorderRadius(Widget? child) {
    // Try to extract border radius from common widget patterns
    if (child is Container) {
      final decoration = child.decoration;
      if (decoration is BoxDecoration) {
        return decoration.borderRadius ?? BorderRadius.zero;
      }
    }

    // Default to zero if we can't determine the border radius
    return BorderRadius.zero;
  }
}
