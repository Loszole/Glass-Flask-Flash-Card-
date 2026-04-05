import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/flashcard_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/app_backdrop.dart';
import '../widgets/flashcard_widget.dart';
import '../widgets/glass_panel.dart';
import '../widgets/progress_ring.dart';
import 'manage_screen.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcard Quiz'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: themeProvider.isDarkMode ? 'Switch to light mode' : 'Switch to dark mode',
            icon: Icon(
              themeProvider.isDarkMode
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
            ),
            onPressed: themeProvider.toggleTheme,
          ),
          IconButton(
            tooltip: 'Manage cards',
            icon: const Icon(Icons.edit_note_rounded),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ManageScreen()),
            ),
          ),
        ],
      ),
      body: AppBackdrop(
        child: Consumer<FlashcardProvider>(
          builder: (context, provider, _) {
            if (!provider.hasCards) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: GlassPanel(
                    padding: const EdgeInsets.fromLTRB(24, 30, 24, 30),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 74,
                          height: 74,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.14),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.layers_outlined,
                            size: 34,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'No flashcards yet',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap the edit icon above to start your first study set.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            final card = provider.currentCard!;
            final total = provider.cards.length;
            final current = provider.currentIndex + 1;
            final progress = current / total;

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  children: [
                    GlassPanel(
                      padding: const EdgeInsets.fromLTRB(20, 18, 18, 18),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Glassmorphic Focus',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(color: Theme.of(context).appBarTheme.foregroundColor),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Card $current of $total',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .appBarTheme
                                            .foregroundColor
                                            ?.withValues(alpha: 0.82),
                                      ),
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  provider.isAnswerVisible
                                      ? 'Answer visible. Move forward when ready.'
                                      : 'Lock in your guess, then reveal the answer.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .appBarTheme
                                            .foregroundColor
                                            ?.withValues(alpha: 0.68),
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          ProgressRing(progress: progress),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 320),
                        transitionBuilder: (child, animation) {
                          final offset = animation.drive(
                            Tween<Offset>(
                              begin: const Offset(0, 0.06),
                              end: Offset.zero,
                            ).chain(
                              CurveTween(curve: Curves.easeOutCubic),
                            ),
                          );
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(position: offset, child: child),
                          );
                        },
                        child: FlashcardWidget(
                          key: ValueKey(card.id),
                          question: card.question,
                          answer: card.answer,
                          isAnswerVisible: provider.isAnswerVisible,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: provider.isAnswerVisible
                          ? GlassPanel(
                              key: const ValueKey('answer-revealed'),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 14,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle_outline_rounded,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Answer revealed. Use the controls below to continue.',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(
                              key: const ValueKey('show-answer-button'),
                              width: double.infinity,
                              child: FilledButton.icon(
                                onPressed: provider.toggleAnswer,
                                icon: const Icon(Icons.flip_to_back_rounded),
                                label: const Text('Show Answer'),
                              ),
                            ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed:
                                provider.canGoPrevious ? provider.previousCard : null,
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 16,
                            ),
                            label: const Text('Previous'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: provider.canGoNext ? provider.nextCard : null,
                            icon: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
                            ),
                            iconAlignment: IconAlignment.end,
                            label: const Text('Next'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
