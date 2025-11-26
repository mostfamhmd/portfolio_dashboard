import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Modern loading widget with pulsing dots animation
class ModernLoader extends StatefulWidget {
  final Color? color;
  final double size;
  final String? message;

  const ModernLoader({
    super.key,
    this.color,
    this.size = 50,
    this.message,
  });

  @override
  State<ModernLoader> createState() => _ModernLoaderState();
}

class _ModernLoaderState extends State<ModernLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).primaryColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: widget.size * 2,
          height: widget.size,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(3, (index) {
                  final delay = index * 0.2;
                  final value = (_controller.value - delay) % 1.0;
                  final scale = value < 0.5
                      ? 1.0 + (value * 2 * 0.5)
                      : 1.5 - ((value - 0.5) * 2 * 0.5);

                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      width: widget.size / 4,
                      height: widget.size / 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            color.withValues(alpha: 0.3 + (scale - 1.0) * 0.7),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.3),
                            blurRadius: 8 * scale,
                            spreadRadius: 2 * scale,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ),
        if (widget.message != null) ...[
          const SizedBox(height: 16),
          Text(
            widget.message!,
            style: TextStyle(
              color: color.withValues(alpha: 0.7),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}

/// Pulsing placeholder (replaces shimmer)
class PulsingPlaceholder extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const PulsingPlaceholder({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  State<PulsingPlaceholder> createState() => _PulsingPlaceholderState();
}

class _PulsingPlaceholderState extends State<PulsingPlaceholder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _opacity = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;

    return AnimatedBuilder(
      animation: _opacity,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
            color: baseColor.withValues(alpha: _opacity.value),
          ),
        );
      },
    );
  }
}

/// Circular progress with gradient
class GradientCircularLoader extends StatefulWidget {
  final double size;
  final Color? color;
  final double strokeWidth;

  const GradientCircularLoader({
    super.key,
    this.size = 50,
    this.color,
    this.strokeWidth = 4,
  });

  @override
  State<GradientCircularLoader> createState() => _GradientCircularLoaderState();
}

class _GradientCircularLoaderState extends State<GradientCircularLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).primaryColor;

    return RotationTransition(
      turns: _controller,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: CustomPaint(
          painter: _GradientCirclePainter(
            color: color,
            strokeWidth: widget.strokeWidth,
          ),
        ),
      ),
    );
  }
}

class _GradientCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _GradientCirclePainter({
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    const startAngle = -90.0 * (3.14159 / 180.0);
    const sweepAngle = 270.0 * (3.14159 / 180.0);

    final paint = Paint()
      ..shader = SweepGradient(
        colors: [
          color.withValues(alpha: 0.1),
          color,
        ],
        stops: const [0.0, 1.0],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect.deflate(strokeWidth / 2),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Skeleton loader for list items
class SkeletonListItem extends StatelessWidget {
  final bool showAvatar;

  const SkeletonListItem({
    super.key,
    this.showAvatar = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showAvatar) ...[
            const PulsingPlaceholder(
              width: 50,
              height: 50,
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PulsingPlaceholder(
                  width: double.infinity,
                  height: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 8),
                PulsingPlaceholder(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 14,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Full-screen loading surface for dashboard bootstrapping
class DashboardLoadingScreen extends StatelessWidget {
  const DashboardLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          const _DashboardAnimatedBackdrop(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const ModernLoader(
                    size: 68,
                    message: 'Syncing the latest portfolio data...',
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Give us a moment while we hydrate your dashboard.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Expanded(
                    child: _GlassPanel(
                      child: const _DashboardSkeleton(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardSkeleton extends StatelessWidget {
  const _DashboardSkeleton();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final statWidth = _statCardWidth(maxWidth);
        final managementWidth = _managementCardWidth(maxWidth);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    PulsingPlaceholder(
                      width: 220,
                      height: 34,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    const SizedBox(height: 12),
                    PulsingPlaceholder(
                      width: 280,
                      height: 20,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: List.generate(
                  4,
                  (index) => SizedBox(
                    width: statWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PulsingPlaceholder(
                          width: 48,
                          height: 48,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        const SizedBox(height: 16),
                        PulsingPlaceholder(
                          width: 90,
                          height: 38,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        const SizedBox(height: 8),
                        PulsingPlaceholder(
                          width: 120,
                          height: 18,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              PulsingPlaceholder(
                width: 260,
                height: 32,
                borderRadius: BorderRadius.circular(10),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 24,
                runSpacing: 24,
                children: List.generate(
                  5,
                  (index) => SizedBox(
                    width: managementWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PulsingPlaceholder(
                          width: 64,
                          height: 64,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        const SizedBox(height: 20),
                        PulsingPlaceholder(
                          width: managementWidth * 0.6,
                          height: 24,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        const SizedBox(height: 12),
                        PulsingPlaceholder(
                          width: managementWidth * 0.8,
                          height: 16,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        const SizedBox(height: 8),
                        PulsingPlaceholder(
                          width: managementWidth * 0.5,
                          height: 16,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  double _statCardWidth(double maxWidth) {
    if (maxWidth >= 960) return (maxWidth - 48) / 4;
    if (maxWidth >= 720) return (maxWidth - 32) / 3;
    if (maxWidth >= 480) return (maxWidth - 16) / 2;
    return maxWidth;
  }

  double _managementCardWidth(double maxWidth) {
    if (maxWidth >= 1024) return (maxWidth - 48) / 3;
    if (maxWidth >= 768) return (maxWidth - 24) / 2;
    return maxWidth;
  }
}

class _GlassPanel extends StatelessWidget {
  final Widget child;

  const _GlassPanel({required this.child});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: scheme.primary.withOpacity(0.12),
            ),
            gradient: LinearGradient(
              colors: [
                scheme.surface.withOpacity(0.78),
                scheme.surfaceVariant.withOpacity(0.6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 28,
                offset: const Offset(0, 24),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _DashboardAnimatedBackdrop extends StatefulWidget {
  const _DashboardAnimatedBackdrop();

  @override
  State<_DashboardAnimatedBackdrop> createState() =>
      _DashboardAnimatedBackdropState();
}

class _DashboardAnimatedBackdropState extends State<_DashboardAnimatedBackdrop>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 14))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final value = _controller.value * 2 * math.pi;
        final beginAlign =
            Alignment(math.cos(value) * 0.6, math.sin(value) * 0.6);
        final endAlign =
            Alignment(math.sin(value / 2) * 0.8, math.cos(value / 2) * 0.8);

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: beginAlign,
              end: endAlign,
              colors: [
                scheme.primary.withOpacity(0.2),
                scheme.secondary.withOpacity(0.2),
                scheme.tertiary.withOpacity(0.16),
              ],
            ),
          ),
          child: Stack(
            children: const [
              _GlowOrb(size: 260, alignment: Alignment(-0.7, -0.4)),
              _GlowOrb(size: 220, alignment: Alignment(0.6, -0.2)),
              _GlowOrb(size: 280, alignment: Alignment(0.2, 0.7)),
            ],
          ),
        );
      },
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final double size;
  final Alignment alignment;

  const _GlowOrb({required this.size, required this.alignment});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Align(
      alignment: alignment,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.22),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.12),
              blurRadius: size * 0.7,
              spreadRadius: size * 0.2,
            ),
          ],
        ),
      ),
    );
  }
}
