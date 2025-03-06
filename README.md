# book_finder_flutter

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.
//
Flutter book finder app, where I have used google books api, i have implemented books search feature using Cubit and Cubit state, and the book repository class, where i keep my base url for books, and a method for fetching data.
then using cubit and cubit state, i fetched the data in my home page, then i have created my local database using SQFlite in my file databaseHelper, and upon setting the book as favorite, by clicking the favorite button, I mark and unmark as favorite using FavoriteCubit and FavoriteCubit state class. and in my Favorite screen, I fetched the data from my favorite cubit, which holds the events of database, either anything in favorite or not.
I have implemented the theme using ThemeCubit and ThemeData state. and set that theme in my main, using share preferences, the state persists whether there is dark or light theme.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
