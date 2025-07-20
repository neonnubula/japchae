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
                  // Dark mode - more visible, elegant gradients
                  const Color(0xFF1F1F1F).withValues(alpha: 0.95), // Dark base
                  const Color(0xFF0D2818).withValues(alpha: 0.90), // Dark with green hint  
                  const Color(0xFF0F1A1E).withValues(alpha: 0.88), // Dark with teal hint
                  const Color(0xFF2B2B1F).withValues(alpha: 0.92), // Dark with gold hint
                ]
              : [
                  // Light mode - more visible, warm gradients
                  const Color(0xFFFFF8E1).withValues(alpha: 0.75), // Warm white with gold hint
                  const Color(0xFFF1F8E9).withValues(alpha: 0.80), // Light with green hint
                  const Color(0xFFE0F2F1).withValues(alpha: 0.78), // Light with teal hint  
                  const Color(0xFFFFF3E0).withValues(alpha: 0.76), // Warm peachy white
                ],
          stops: const [0.0, 0.3, 0.7, 1.0],
        ),
      ),
      child: child,
    );
  }
} 