import 'package:book_finder_flutter/bloc/favorite/favorite_book_cubit.dart';
import 'package:book_finder_flutter/bloc/favorite/favorite_book_cubit_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteBooksScreen extends StatelessWidget {
  const FavoriteBooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<FavoriteBookCubit>().loadFavorites();
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Favorite Books',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
      body: BlocBuilder<FavoriteBookCubit, FavoriteBookCubitState>(
        builder: (context, state) {
          if (state is FavoriteInitial) {
            return const Center(child: CupertinoActivityIndicator());
          } else if (state is FavoriteBooksLoaded) {
            final favorites = state.favorites;

            if (favorites.isEmpty) {
              return Center(
                  child: Text(
                'No favorite books yet.',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ));
            }

            return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final book = favorites[index];
                final title = book.volumeInfo?.title ?? 'No Title';
                final authors =
                    book.volumeInfo?.authors?.join(', ') ?? 'Unknown Author';
                final thumbnail = book.volumeInfo?.imageLinks?.thumbnail;

                return ListTile(
                  leading: CachedNetworkImage(
                    imageUrl: thumbnail ?? '',
                    placeholder: (context, url) => CupertinoActivityIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  title: Text(
                    title,
                    maxLines: 2,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    authors,
                    maxLines: 2,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.pink),
                    onPressed: () {
                      context
                          .read<FavoriteBookCubit>()
                          .removeFavorite(book.id!);
                    },
                  ),
                );
              },
            );
          } else if (state is FavoritesBooksError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 50),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<FavoriteBookCubit>().loadFavorites();
                    },
                    child: Text(
                      'Retry',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }
}
