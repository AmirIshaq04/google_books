import 'package:book_finder_flutter/bloc/book_cubit.dart';
import 'package:book_finder_flutter/bloc/book_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Finder'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for books...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    final query = _searchController.text.trim();
                    if (query.isNotEmpty) {
                      context.read<BookCubit>().fetchBooks(query);
                    }
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<BookCubit, BookState>(
              builder: (context, state) {
                if (state is BookLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is BooksDisplayed) {
                  final books = state.books;

                  if (books.isEmpty) {
                    return const Center(child: Text('No books found'));
                  }

                  return ListView.builder(
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final book = books[index];
                      final title = book.volumeInfo?.title ?? 'No Title';
                      final authors = book.volumeInfo?.authors?.join(', ') ??
                          'Unknown Author';
                      final thumbnail = book.volumeInfo?.imageLinks?.thumbnail;

                      return ListTile(
                        leading: thumbnail != null
                            ? Image.network(thumbnail)
                            : const Icon(Icons.book),
                        title: Text(title),
                        subtitle: Text(authors),
                      );
                    },
                  );
                } else if (state is BookError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: Text('Search for books'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
