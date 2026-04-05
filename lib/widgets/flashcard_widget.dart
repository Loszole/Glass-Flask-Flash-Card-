import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'glass_panel.dart';

class FlashcardWidget extends StatefulWidget {
  final String question;
  final String answer;
  final bool isAnswerVisible;

  const FlashcardWidget({
    super.key,
    required this.question,
    required this.answer,
    required this.isAnswerVisible,
  });

  @override
  State<FlashcardWidget> createState() => _FlashcardWidgetState();
}

class _FlashcardWidgetState extends State<FlashcardWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
      value: widget.isAnswerVisible ? 1 : 0,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubicEmphasized,
    );
  }

  @override
  void didUpdateWidget(covariant FlashcardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnswerVisible != oldWidget.isAnswerVisible) {
      if (widget.isAnswerVisible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final angle = _animation.value * math.pi;
        final isBackFace = angle > (math.pi / 2);

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0011)
            ..rotateY(angle),
          child: isBackFace
              ? Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateY(math.pi),
                  child: _CardFace(
                    label: 'ANSWER',
                    title: 'Solution unlocked',
                    content: widget.answer,
                    icon: Icons.auto_awesome_rounded,
                    alignment: CrossAxisAlignment.start,
                  ),
                )
              : _CardFace(
                  label: 'QUESTION',
                  title: 'Stay on the prompt',
                  content: widget.question,
                  icon: Icons.psychology_alt_rounded,
                  alignment: CrossAxisAlignment.start,
                ),
        );
      },
    );
  }
}

class _CardFace extends StatelessWidget {
  final String label;
  final String title;
  final String content;
  final IconData icon;
  final CrossAxisAlignment alignment;

  const _CardFace({
    required this.label,
    required this.title,
    required this.content,
    required this.icon,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GlassPanel(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 28),
      borderRadius: BorderRadius.circular(32),
      color: Colors.white.withValues(alpha: 0.2),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 320),
        child: Column(
          crossAxisAlignment: alignment,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.22),
                    ),
                  ),
                  child: Icon(icon, color: colorScheme.onSurface),
                ),
                const Spacer(),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        letterSpacing: 2,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: Text(
                  content,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 24,
                        height: 1.55,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                label == 'QUESTION'
                    ? 'Reveal the answer to flip the card'
                    : 'Use Previous or Next to move on',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
