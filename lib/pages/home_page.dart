import 'package:book_finder_flutter/bloc/book/book_cubit.dart';
import 'package:book_finder_flutter/bloc/book/book_state.dart';
import 'package:book_finder_flutter/bloc/favorite/favorite_book_cubit.dart';
import 'package:book_finder_flutter/bloc/favorite/favorite_book_cubit_state.dart';
import 'package:book_finder_flutter/bloc/theme/theme_cubit.dart';
import 'package:book_finder_flutter/pages/favorite_books_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Book Finder',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
            },
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
          ),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FavoriteBooksScreen(),
                    ));
              },
              icon: Icon(
                Icons.favorite,
                color: Colors.pink,
              )),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for books...',
                hintStyle: TextStyle(color: Theme.of(context).primaryColor),
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
                    return Center(
                        child: Text('No books found',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor)));
                  }

                  return ListView.builder(
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final book = books[index];
                      final title = book.volumeInfo?.title ?? 'No Title';
                      final authors = book.volumeInfo?.authors?.join(', ') ??
                          'Unknown Author';
                      final thumbnail = book.volumeInfo?.imageLinks?.thumbnail;

                      return BlocBuilder<FavoriteBookCubit,
                          FavoriteBookCubitState>(builder: (context, state) {
                        bool isFavorite = context
                            .read<FavoriteBookCubit>()
                            .isFavorite(book.id!);
                        return ListTile(
                            leading: CachedNetworkImage(
                              imageUrl: thumbnail ?? '',
                              placeholder: (context, url) =>
                                  CupertinoActivityIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                            title: Text(
                              title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                            subtitle: Text(
                              authors,
                              maxLines: 2,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: IconButton(
                                onPressed: () {
                                  if (isFavorite) {
                                    context
                                        .read<FavoriteBookCubit>()
                                        .removeFavorite(book.id!);
                                  } else {
                                    context
                                        .read<FavoriteBookCubit>()
                                        .addToFavorites(book);
                                  }
                                },
                                icon: Icon(
                                  Icons.favorite,
                                  color:
                                      isFavorite ? Colors.pink : Colors.black54,
                                )));
                      });
                    },
                  );
                } else if (state is BookError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            color: Colors.red, size: 50),
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          style:
                              const TextStyle(fontSize: 16, color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            final query = _searchController.text.trim();
                            if (query.isNotEmpty) {
                              context.read<BookCubit>().fetchBooks(query);
                            }
                          },
                          child: Text(
                            'Retry',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                      child: Text(
                    'Search for books',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
