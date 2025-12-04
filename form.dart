import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'review.dart';

class AddReviewFormDialog extends StatelessWidget {
  final Review? initialReview;

  const AddReviewFormDialog({
    this.initialReview,
    super.key,
  });

  FormGroup buildForm() {
    return fb.group({
      'title': [
        initialReview?.title ?? '',
        Validators.required,
      ],
      'comment': [
        initialReview?.comment ?? '',
      ],
      'rating': [
        initialReview?.rating ?? 5,
        Validators.required,
        Validators.number,
        Validators.min(1),
        Validators.max(5),
      ],
    });
  }

  @override
  Widget build(BuildContext context) {
    return ReactiveFormBuilder(
      form: buildForm,
      builder: (context, form, child) {
        return AlertDialog(
          title: Text(initialReview == null ? 'Aggiungi Recensione' : 'Modifica Recensione'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ReactiveTextField<String>(
                  formControlName: 'title',
                  decoration: const InputDecoration(
                    labelText: 'Titolo Recensione*',
                  ),
                  validationMessages: {
                    ValidationMessage.required: (error) => 'Il titolo è obbligatorio',
                  },
                ),
                const SizedBox(height: 16),
                ReactiveTextField<String>(
                  formControlName: 'comment',
                  decoration: const InputDecoration(
                    labelText: 'Commento (Opzionale)',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                ReactiveDropdownField<int>(
                  formControlName: 'rating',
                  decoration: const InputDecoration(
                    labelText: 'Valutazione (1-5)*',
                  ),
                  items: List.generate( 5, (i) => DropdownMenuItem<int>(
                      value: i + 1,
                      child: Text('${i + 1} Stelle'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annulla'),
            ),
            FilledButton(
              onPressed: form.valid
                  ? () {
                      final Map<String, dynamic> data = form.value;
                      final result = Review(
                        title: data['title'] as String,
                        comment: data['comment'] as String?,
                        rating: data['rating'] as int,
                      );
                      Navigator.of(context).pop(result);
                    }
                  : null,
              child: Text(initialReview == null ? 'Aggiungi' : 'Salva Modifiche'),
            ),
          ],
        );
      },
    );
  }
}