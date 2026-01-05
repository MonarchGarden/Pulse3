import 'package:flutter/material.dart';

class GasSkeleton extends StatefulWidget {
  const GasSkeleton({super.key});

  @override
  State<GasSkeleton> createState() => _GasSkeletonState();
}

class _GasSkeletonState extends State<GasSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              // Smooth pulse between two greys
              final t = _controller.value;
              final base = Colors.grey.shade800;
              final highlight = Colors.grey.shade700;
              final color = Color.lerp(base, highlight, t)!;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _SkeletonBox(width: 80, height: 12, color: color),
                  const SizedBox(height: 16),
                  _SkeletonBox(width: 160, height: 40, color: color),
                  const SizedBox(height: 20),
                  _SkeletonBox(width: 120, height: 36, color: color),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const _SkeletonBox({
    required this.width,
    required this.height,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
