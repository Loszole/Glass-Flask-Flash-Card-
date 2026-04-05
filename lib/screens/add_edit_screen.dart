import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/flashcard.dart';
import '../providers/flashcard_provider.dart';
import '../widgets/app_backdrop.dart';
import '../widgets/glass_panel.dart';

class AddEditScreen extends StatefulWidget {
  final Flashcard? card; // null → add mode

  const AddEditScreen({super.key, this.card});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _questionCtrl;
  late final TextEditingController _answerCtrl;

  bool get _isEditing => widget.card != null;

  @override
  void initState() {
    super.initState();
    _questionCtrl =
        TextEditingController(text: widget.card?.question ?? '');
    _answerCtrl =
        TextEditingController(text: widget.card?.answer ?? '');
  }

  @override
  void dispose() {
    _questionCtrl.dispose();
    _answerCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<FlashcardProvider>();
    if (_isEditing) {
      provider.editCard(
        widget.card!.id,
        _questionCtrl.text,
        _answerCtrl.text,
      );
    } else {
      provider.addCard(_questionCtrl.text, _answerCtrl.text);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Card' : 'New Card'),
        centerTitle: true,
      ),
      body: AppBackdrop(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: GlassPanel(
                padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      _isEditing ? 'Refine your card' : 'Create a new card',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Keep prompts short and answers precise for faster recall.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 24),
                    _buildLabel('Question'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _questionCtrl,
                      autofocus: !_isEditing,
                      maxLines: 4,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: 'Enter the question…',
                        alignLabelWithHint: true,
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 24),
                    _buildLabel('Answer'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _answerCtrl,
                      maxLines: 4,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _save(),
                      decoration: const InputDecoration(
                        hintText: 'Enter the answer…',
                        alignLabelWithHint: true,
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 28),
                    FilledButton(
                      onPressed: _save,
                      child: Text(_isEditing ? 'Save Changes' : 'Add Card'),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            letterSpacing: 1.1,
          ),
    );
  }
}
