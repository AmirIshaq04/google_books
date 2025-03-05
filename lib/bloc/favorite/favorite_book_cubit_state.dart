import 'package:book_finder_flutter/models/book_data.dart';
import 'package:equatable/equatable.dart';

abstract class FavoriteBookCubitState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FavoriteInitial extends FavoriteBookCubitState {}

class FavoriteBooksLoaded extends FavoriteBookCubitState {
  final List<Item> favorites;
  FavoriteBooksLoaded(this.favorites);
  @override
  List<Object?> get props => [favorites];
}

class FavoritesBooksError extends FavoriteBookCubitState {
  final String message;
  FavoritesBooksError(this.message);
  @override
  List<Object?> get props => [message];
}
