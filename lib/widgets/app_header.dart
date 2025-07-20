import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  final double fontSize;
  final EdgeInsetsGeometry? padding;

  const AppHeader({
    super.key,
    this.fontSize = 24.0,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 16.0),
      child: ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFFFD700), // Golden yellow (left side of your logo)
            Color(0xFF32CD32), // Lime green (middle)
            Color(0xFF20B2AA), // Light sea green (right side)
          ],
          stops: [0.0, 0.5, 1.0],
        ).createShader(bounds),
        child: Text(
          'Most Important Thing',
          style: TextStyle(
            fontSize: fontSize * 1.2, // 20% larger for more impact
            fontWeight: FontWeight.w900, // Heavier weight for prominence
            letterSpacing: 1.0, // Increased letter spacing for elegance
            color: Colors.white, // This will be masked by the gradient
            height: 1.1, // Slightly tighter line height
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
} 