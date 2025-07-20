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

// Elegant gradient background widget
class GradientBackground extends StatelessWidget {
  final Widget child;
  final bool isDarkMode;

  const GradientBackground({
    super.key,
    required this.child,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [
                  // Dark mode - subtle, elegant gradients
                  const Color(0xFF1A1A1A).withValues(alpha: 0.95), // Very dark with gold hint
                  const Color(0xFF0F1B0F).withValues(alpha: 0.98), // Dark with green hint  
                  const Color(0xFF0A1A1A).withValues(alpha: 0.96), // Dark with teal hint
                  const Color(0xFF1A1A1A).withValues(alpha: 0.95), // Back to dark
                ]
              : [
                  // Light mode - warm, elegant gradients
                  const Color(0xFFFFFBF0).withValues(alpha: 0.90), // Warm white with gold hint
                  const Color(0xFFF9FBF7).withValues(alpha: 0.95), // Light with green hint
                  const Color(0xFFF7FAFA).withValues(alpha: 0.92), // Light with teal hint  
                  const Color(0xFFFFFBF0).withValues(alpha: 0.90), // Back to warm white
                ],
          stops: const [0.0, 0.3, 0.7, 1.0],
        ),
      ),
      child: child,
    );
  }
} 