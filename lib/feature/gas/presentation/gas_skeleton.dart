import 'package:flutter/material.dart';

class GasSkeleton extends StatelessWidget {
  const GasSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: const Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SkeletonBox(width: 80, height: 12),
              SizedBox(height: 16),
              _SkeletonBox(width: 160, height: 40),
              SizedBox(height: 20),
              _SkeletonBox(width: 120, height: 36),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double width;
  final double height;

  const _SkeletonBox({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
