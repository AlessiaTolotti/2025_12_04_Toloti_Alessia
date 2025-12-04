import 'package:flutter/material.dart';
import 'review.dart'; 
import 'form.dart'; 


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Recensioni Ristoranti",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange, 
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: "Recensioni Ristoranti"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _list = <Review>[
    Review(title: 'Ottimo Posto!', comment: 'Servizio rapido e cibo delizioso.', rating: 5),
    Review(title: 'Così così...', comment: 'Un po\' caro per la qualità offerta.', rating: 3),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: _list.isEmpty 
            ? const Text(
                "Nessuna recensione. Aggiungine una con il pulsante '+'.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              )
            : ListView.separated(
                itemCount: _list.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final review = _list[i];
                  return ListTile(
                    title: Text(review.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Valutazione: ${review.rating}/5'),
                        if (review.comment != null && review.comment!.isNotEmpty)
                          Text(review.comment!),
                      ],
                    ),
                    trailing: Row( 
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editReview(i), 
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteReview(i),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addReview,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _addReview() async {
    final newReview = await showDialog<Review>(
      context: context,
      builder: (context) => const AddReviewFormDialog(),
    );

    if (newReview == null) return; 

    setState(() {
      _list.add(newReview);
    });
  }

  Future<void> _editReview(int index) async {
    final originalReview = _list[index];
    
    final modifiedReview = await showDialog<Review>(
      context: context,
      builder: (context) => AddReviewFormDialog(initialReview: originalReview),
    );

    if (modifiedReview == null) return; 

    setState(() {
      _list[index] = modifiedReview;
    });
  }
  
  void _deleteReview(int index) {
    setState(() {
      _list.removeAt(index);
    });
 
   
  }
}