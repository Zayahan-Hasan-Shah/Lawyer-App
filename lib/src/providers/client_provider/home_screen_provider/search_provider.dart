import 'package:flutter_riverpod/legacy.dart';

// This will store the current text in the search bar
final searchQueryProvider = StateProvider<String>((ref) => '');
