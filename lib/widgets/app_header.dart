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

// Premium elevated card with optional gradient
class ElevatedGradientCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool useGradient;
  final double elevation;
  final double borderRadius;
  final bool isDarkMode;

  const ElevatedGradientCard({
    super.key,
    required this.child,
    required this.isDarkMode,
    this.padding = const EdgeInsets.all(16.0),
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.useGradient = false,
    this.elevation = 8.0,
    this.borderRadius = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: useGradient
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDarkMode
                    ? [
                        const Color(0xFF3A3A3A), // Lighter dark for cards
                        const Color(0xFF2A4A3A), // Dark green tint
                        const Color(0xFF2E4A4A), // Dark teal tint
                        const Color(0xFF4A4A2A), // Dark gold tint
                      ]
                    : [
                        const Color(0xFFFFFCF0), // Warm cream
                        const Color(0xFFF8FCF8), // Light green tint
                        const Color(0xFFF0FFFE), // Light teal tint
                        const Color(0xFFFFFAF0), // Warm peachy white
                      ],
                stops: const [0.0, 0.3, 0.65, 1.0],
              )
            : null,
        color: useGradient ? null : Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withValues(alpha: 0.4)
                : Colors.black.withValues(alpha: 0.15),
            blurRadius: elevation * 2,
            offset: Offset(0, elevation / 2),
            spreadRadius: 1,
          ),
          // Add a subtle inner highlight for more premium feel
          BoxShadow(
            color: isDarkMode
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.white.withValues(alpha: 0.8),
            blurRadius: 2,
            offset: const Offset(0, -1),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: child,
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
                  // Dark mode - dramatic, visible gradients
                  const Color(0xFF2D2D2D), // Medium dark base
                  const Color(0xFF1B3B2B), // Rich dark green  
                  const Color(0xFF1E3A3A), // Deep teal
                  const Color(0xFF3B3B1B), // Dark gold
                ]
              : [
                  // Light mode - vibrant, clearly visible gradients
                  const Color(0xFFFFF9C4), // Bright warm yellow
                  const Color(0xFFE8F5E8), // Fresh light green
                  const Color(0xFFB2DFDB), // Clear teal blue  
                  const Color(0xFFFFE0B2), // Warm peach orange
                ],
          stops: const [0.0, 0.3, 0.65, 1.0],
        ),
      ),
      child: child,
    );
  }
} 