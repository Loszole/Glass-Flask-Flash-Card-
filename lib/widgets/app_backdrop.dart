import 'package:flutter/material.dart';

class AppBackdrop extends StatelessWidget {
  final Widget child;

  const AppBackdrop({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? const [
                  Color(0xFF10182C),
                  Color(0xFF12203A),
                  Color(0xFF0B1222),
                ]
              : const [
                  Color(0xFF7385A8),
                  Color(0xFF64728F),
                  Color(0xFF4E5977),
                ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -110,
            left: -70,
            child: _GlowOrb(
              size: 260,
              colors: isDark
                  ? const [Color(0x449AF1FF), Color(0x009AF1FF)]
                  : const [Color(0x66D5F4FF), Color(0x00D5F4FF)],
            ),
          ),
          Positioned(
            top: 120,
            right: -30,
            child: _GlowOrb(
              size: 210,
              colors: isDark
                  ? const [Color(0x22FFFFFF), Color(0x00FFFFFF)]
                  : const [Color(0x55FFFFFF), Color(0x00FFFFFF)],
            ),
          ),
          Positioned(
            bottom: -90,
            right: -20,
            child: _GlowOrb(
              size: 260,
              colors: isDark
                  ? const [Color(0x559EB8FF), Color(0x009EB8FF)]
                  : const [Color(0x4D9EB8FF), Color(0x009EB8FF)],
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final double size;
  final List<Color> colors;

  const _GlowOrb({required this.size, required this.colors});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: colors),
        ),
      ),
    );
  }
}