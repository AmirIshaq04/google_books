import 'package:book_finder_flutter/bloc/book_state.dart';
import 'package:book_finder_flutter/models/book_data.dart';
import 'package:book_finder_flutter/services/book_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookCubit extends Cubit<BookState> {
  final BookRepository bookRepository;

  BookCubit(this.bookRepository) : super(BookInitial());

  Future<void> fetchBooks(String query) async {
    emit(BookLoading());
    try {
      final BookData bookData = await bookRepository.fetchBooks(query);

      if (bookData.items == null || bookData.items!.isEmpty) {
      
        emit(BooksDisplayed([])); 
      } else {
        emit(BooksDisplayed(bookData.items!));
      }
    } catch (e) {
      emit(BookError("Failed to fetch books: $e"));
    }
  }
}