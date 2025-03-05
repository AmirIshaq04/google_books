import 'dart:async';
import 'dart:io';
import 'package:book_finder_flutter/bloc/favorite/favorite_book_cubit_state.dart';
import 'package:book_finder_flutter/models/book_data.dart';
import 'package:book_finder_flutter/services/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FavoriteBookCubit extends Cubit<FavoriteBookCubitState> {
  final DatabaseHelper dbhelper;
  FavoriteBookCubit({required this.dbhelper}) : super(FavoriteInitial());

  Future<void> loadFavorites() async {
    emit(FavoriteInitial());
    try {
      final favorites = await dbhelper.getFavorites();
      emit(FavoriteBooksLoaded(favorites));
    } catch (e) {
      String errorMessage =
          'Failed to load favorites. Please check your internet connection.';
      if (e is SocketException || e is TimeoutException) {
        emit(FavoritesBooksError(errorMessage));
      }
    }
  }

  Future<void> addToFavorites(Item book) async {
    try {
      await dbhelper.addFavorite(book);

      await loadFavorites();
      Fluttertoast.showToast(
        msg: 'Book has been added to favorites',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.pink,
        textColor: Colors.white,
      );
    } catch (e) {
      emit(FavoritesBooksError('Error while adding favorite$e'));
    }
  }

  Future<void> removeFavorite(String id) async {
    try {
      await dbhelper.removeFavorite(id);
      await loadFavorites();
      Fluttertoast.showToast(
        msg: 'Book has been removed to favorites',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.pink,
        textColor: Colors.white,
      );
    } catch (e) {
      emit(FavoritesBooksError('Error removing from favorite$e'));
    }
  }

  bool isFavorite(String id) {
    if (state is FavoriteBooksLoaded) {
      return (state as FavoriteBooksLoaded)
          .favorites
          .any((book) => book.id == id);
    }
    return false;
  }
}
