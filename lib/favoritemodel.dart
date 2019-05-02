import 'dart:collection';
import 'package:scoped_model/scoped_model.dart';
import 'model/product.dart';

class FavoriteList extends Model{
  final List<Product> saved = [];

  UnmodifiableListView<Product> get products => UnmodifiableListView(saved);
  int get totalNum => saved.length;

  void add(Product product){
    saved.add(product);
    notifyListeners();
  }
}