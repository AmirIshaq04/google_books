import 'package:book_finder_flutter/models/book_data.dart'; 
import 'package:equatable/equatable.dart';

abstract class BookState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BookInitial extends BookState {}

class BookLoading extends BookState {}

class BooksDisplayed extends BookState {
  final List<Item> books; 

  BooksDisplayed(this.books);

  BooksDisplayed copyWith({List<Item>? books}) {
    return BooksDisplayed(books ?? this.books);
  }

  @override
  List<Object?> get props => [books];
}

class BookError extends BookState {
  final String message;

  BookError(this.message);

  @override
  List<Object?> get props => [message];
}