import 'package:book_finder_flutter/bloc/book/book_cubit.dart';
import 'package:book_finder_flutter/bloc/favorite/favorite_book_cubit.dart';
import 'package:book_finder_flutter/bloc/theme/theme_cubit.dart';
import 'package:book_finder_flutter/pages/home_page.dart';
import 'package:book_finder_flutter/services/book_repository.dart';
import 'package:book_finder_flutter/services/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BookCubit(BookRepository()),
        ),
        BlocProvider(
          create: (context) => FavoriteBookCubit(dbhelper: DatabaseHelper()),
        ),
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
      ],
      child:
          BlocBuilder<ThemeCubit,ThemeData>(builder: (context, theme) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: theme,
          debugShowCheckedModeBanner: false,
          home: HomePage(),
        );
      }),
    );
  }
}
