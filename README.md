## flutter_shimmer

Tiny, dependency‑free shimmer effect for any widget. Wrap your widget with `AutoShimmer` to get a smooth, animated loading state with preserved border radii and customizable colors.

The package focuses on doing one thing well: applying a performant shimmer via `ShaderMask` to your own skeleton layout or real widgets while loading.

---

### Features
- Drop‑in wrapper: `AutoShimmer(child: ...)`
- Customizable base/highlight colors and duration
- Respects rounded corners when possible
- Lightweight: no 3rd‑party dependencies
- Works anywhere: lists, cards, buttons, images

---

## Installation

```yaml
dependencies:
  flutter_shimmer: ^0.0.1
```

Or:

```bash
dart pub add flutter_shimmer
```

---

## Quick start

```dart
import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';

class Demo extends StatelessWidget {
  const Demo({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isLoading = true;

    return AutoShimmer(
      showShimmer: isLoading,
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
```

---

## Skeleton example (avatar + title + subtitle)

`AutoShimmer` does not auto‑infer semantic shapes. Provide a simple placeholder layout as the child while loading:

```dart
AutoShimmer(
  showShimmer: isLoading,
  baseColor: Colors.grey.shade300,
  highlightColor: Colors.grey.shade100,
  child: Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: const BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _bar(width: 140, height: 16),
              const SizedBox(height: 8),
              _bar(width: 100, height: 14),
              const SizedBox(height: 8),
              _bar(width: 180, height: 14),
            ],
          ),
        ),
      ],
    ),
  ),
)

Widget _bar({required double width, required double height}) => Container(
  width: width,
  height: height,
  decoration: BoxDecoration(
    color: Colors.grey.shade300,
    borderRadius: BorderRadius.circular(8),
  ),
);
```

See `example/lib/main.dart` for a complete demo.

---

## API

| Property | Type | Default | Description |
|---|---|---|---|
| `child` | `Widget` | required | Widget to mask with the shimmer effect. |
| `duration` | `Duration` | `Duration(seconds: 2)` | One full shimmer cycle length. |
| `baseColor` | `Color` | `Color(0xFFE0E0E0)` | Darker color in the gradient. |
| `highlightColor` | `Color` | `Color(0xFFF5F5F5)` | Lighter color creating the highlight. |
| `showShimmer` | `bool` | `true` | Toggle the effect without rebuilding your tree. |

Border radius: when possible, the wrapper tries to extract a `BorderRadius` from common patterns like a `Container` with `BoxDecoration` and applies it so the shimmer respects rounded corners. Falls back to square if none detected.

---

## Performance tips
- Prefer `const` in skeletons
- Keep gradients simple (defaults are optimized)
- In lists, build lazily with `ListView.builder`

---

## FAQ
- Can it auto‑detect avatar/title/subtitle? Not generically. Provide a small skeleton layout.
- Does it clip to my card radius? Yes, when a radius can be inferred.
- Can I disable animation but keep placeholders? Set `showShimmer: false`.

---

## Contributing
Issues and pull requests are welcome. Please file bugs and ideas on the GitHub issue tracker.

## License
MIT – see `LICENSE`.
