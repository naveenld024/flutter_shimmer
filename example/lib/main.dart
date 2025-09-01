import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_auto_shimmer.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shimmer Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
      ),
      home: const ShimmerDemoPage(),
    );
  }
}

class ShimmerDemoPage extends StatefulWidget {
  const ShimmerDemoPage({super.key});

  @override
  State<ShimmerDemoPage> createState() => _ShimmerDemoPageState();
}

class _ShimmerDemoPageState extends State<ShimmerDemoPage> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _simulateLoading();
  }

  void _simulateLoading() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  void _refresh() {
    setState(() => _loading = true);
    _simulateLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: const Text("Shimmer Demo")),
      body: AutoShimmer(
        showShimmer: _loading,
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: RefreshIndicator(
          onRefresh: () async {
            _refresh();
            return;
          },
          child: ListView(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              ListView.separated(
                padding: const EdgeInsets.all(16),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 6,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (_, index) {
                  return _loading ? _skeletonCard() : _realCard(index);
                },
              ),
              cardItem(),
            ],
          ),
        ),
      ),
    );
  }

  /// ✅ Placeholder Skeleton
  Widget _skeletonCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _circle(56),
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
    );
  }

  /// ✅ Real Content
  Widget _realCard(int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.indigo.shade100,
            child: Text(
              "${index + 1}",
              style: const TextStyle(color: Colors.indigo),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "User ${index + 1}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "This is a sample subtitle line.",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 4),
                Text(
                  "Another line of detail goes here.",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Helpers
  Widget _bar({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _circle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget cardItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.indigo.shade100,
            child: Text("1", style: const TextStyle(color: Colors.indigo)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "User 1",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "This is a sample subtitle line.",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 4),
                Text(
                  "Another line of detail goes here.",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
