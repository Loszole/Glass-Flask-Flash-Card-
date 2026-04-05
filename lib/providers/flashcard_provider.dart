import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/flashcard.dart';

class FlashcardProvider extends ChangeNotifier {
  static const _storageKey = 'flashcards';
  final _uuid = const Uuid();

  List<Flashcard> _cards = [];
  int _currentIndex = 0;
  bool _isAnswerVisible = false;

  List<Flashcard> get cards => List.unmodifiable(_cards);
  int get currentIndex => _currentIndex;
  bool get isAnswerVisible => _isAnswerVisible;
  bool get hasCards => _cards.isNotEmpty;

  Flashcard? get currentCard =>
      hasCards ? _cards[_currentIndex] : null;

  bool get canGoPrevious => _currentIndex > 0;
  bool get canGoNext => _currentIndex < _cards.length - 1;

  FlashcardProvider() {
    _loadFromPrefs();
  }

  // ── Navigation ────────────────────────────────────────────
  void nextCard() {
    if (canGoNext) {
      _currentIndex++;
      _isAnswerVisible = false;
      notifyListeners();
    }
  }

  void previousCard() {
    if (canGoPrevious) {
      _currentIndex--;
      _isAnswerVisible = false;
      notifyListeners();
    }
  }

  void toggleAnswer() {
    _isAnswerVisible = !_isAnswerVisible;
    notifyListeners();
  }

  void resetFlip() {
    _isAnswerVisible = false;
    notifyListeners();
  }

  // ── CRUD ──────────────────────────────────────────────────
  void addCard(String question, String answer) {
    _cards.add(Flashcard(
      id: _uuid.v4(),
      question: question.trim(),
      answer: answer.trim(),
    ));
    _saveToPrefs();
    notifyListeners();
  }

  void editCard(String id, String question, String answer) {
    final index = _cards.indexWhere((c) => c.id == id);
    if (index == -1) return;
    _cards[index] = _cards[index].copyWith(
      question: question.trim(),
      answer: answer.trim(),
    );
    _isAnswerVisible = false;
    _saveToPrefs();
    notifyListeners();
  }

  void deleteCard(String id) {
    final index = _cards.indexWhere((c) => c.id == id);
    if (index == -1) return;
    _cards.removeAt(index);
    if (_currentIndex >= _cards.length && _currentIndex > 0) {
      _currentIndex = _cards.length - 1;
    }
    _isAnswerVisible = false;
    _saveToPrefs();
    notifyListeners();
  }

  // ── Persistence ───────────────────────────────────────────
  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw != null) {
      final list = jsonDecode(raw) as List<dynamic>;
      _cards = list
          .map((e) => Flashcard.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      _cards = _defaultCards();
    }
    _currentIndex = 0;
    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_cards.map((c) => c.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }

  // ── Seed data ─────────────────────────────────────────────
  List<Flashcard> _defaultCards() => [
        Flashcard(
          id: _uuid.v4(),
          question: 'What is the capital of France?',
          answer: 'Paris',
        ),
        Flashcard(
          id: _uuid.v4(),
          question: 'What does HTTP stand for?',
          answer: 'HyperText Transfer Protocol',
        ),
        Flashcard(
          id: _uuid.v4(),
          question: 'What is the speed of light?',
          answer: 'Approximately 299,792,458 m/s',
        ),
        Flashcard(
          id: _uuid.v4(),
          question: 'Who wrote "Romeo and Juliet"?',
          answer: 'William Shakespeare',
        ),
        Flashcard(
          id: _uuid.v4(),
          question: 'What is 2 to the power of 10?',
          answer: '1024',
        ),
      ];
}
