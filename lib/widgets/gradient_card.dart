import 'package:flutter/material.dart';
import 'dart:ui';
import '../theme/app_colors.dart';

class GradientCard extends StatefulWidget {
  final Widget child;
  final List<Color>? gradientColors;
  final bool hasGlassEffect;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const GradientCard({
    super.key,
    required this.child,
    this.gradientColors,
    this.hasGlassEffect = true,
    this.padding,
    this.onTap,
  });

  @override
  State<GradientCard> createState() => _GradientCardState();
}

class _GradientCardState extends State<GradientCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()..scale(_isHovered ? 1.02 : 1.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: widget.hasGlassEffect
                  ? ImageFilter.blur(sigmaX: 10, sigmaY: 10)
                  : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
              child: Container(
                padding: widget.padding ?? const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: widget.hasGlassEffect
                      ? AppColors.glassSurface(isDark)
                      : (isDark
                            ? AppColors.darkSurface
                            : AppColors.lightSurface),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: widget.hasGlassEffect
                        ? AppColors.glassBorder(isDark)
                        : Colors.transparent,
                    width: 1,
                  ),
                  gradient: widget.gradientColors != null
                      ? LinearGradient(
                          colors: widget.gradientColors!,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: (isDark ? Colors.black : Colors.grey).withOpacity(
                        0.1,
                      ),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
