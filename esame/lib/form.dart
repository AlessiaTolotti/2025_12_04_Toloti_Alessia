import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'review.dart';

class AddReviewFormDialog extends StatefulWidget {
  final Review? initialReview;

  const AddReviewFormDialog({
    this.initialReview,
    super.key,
  });

  @override
  State<AddReviewFormDialog> createState() => _AddReviewFormDialogState();
}

class _AddReviewFormDialogState extends State<AddReviewFormDialog> {
  late final FormGroup _form;

  @override
  void initState() {
    super.initState();
    _form = FormGroup({
      'title': FormControl<String>(
        value: widget.initialReview?.title ?? '',
        validators: [Validators.required, Validators.minLength(3)],
      ),
      'comment': FormControl<String>(
        value: widget.initialReview?.comment ?? '',
      ),
      'rating': FormControl<int>(
        value: widget.initialReview?.rating ?? 5,
        validators: [Validators.required, Validators.min(1), Validators.max(5)],
      ),
    });
  }

  @override
  void dispose() {
    _cleanup();
    super.dispose();
  }

  void _cleanup() {
    _form.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ReactiveForm(
          formGroup: _form,
          child: Column(
            children: [
              Text(widget.initialReview == null ? 'Aggiungi Recensione' : 'Modifica Recensione', style: theme.textTheme.headlineSmall),
              const SizedBox(height: 24),
              ReactiveTextField<String>(
                formControlName: 'title',
                decoration: const InputDecoration(hintText: 'Titolo Recensione*'),
                validationMessages: {ValidationMessage.required: (_) => 'Il titolo è obbligatorio'},
              ),
              const SizedBox(height: 16),
              ReactiveTextField<String>(
                formControlName: 'comment',
                decoration: const InputDecoration(hintText: 'Commento (Opzionale)'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              ReactiveDropdownField<int>(
                formControlName: 'rating',
                decoration: const InputDecoration(labelText: 'Valutazione (1-5)'),
                items: List.generate(
                  5,
                  (i) => DropdownMenuItem<int>(
                    value: i + 1,
                    child: Text('${i + 1} Stelle'),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _submit, child: Text(widget.initialReview == null ? 'Aggiungi' : 'Salva Modifiche')),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_form.valid) return;

    final review = Review(
      title: _form.control('title').value as String,
      comment: _form.control('comment').value as String?,
      rating: _form.control('rating').value as int,
    );

    Navigator.pop(context, review);
  }
}

