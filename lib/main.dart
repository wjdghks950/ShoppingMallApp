import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'favoritemodel.dart';
import 'app.dart';

void main(){ 
  final favorite = FavoriteList();
  runApp(
    ScopedModel<FavoriteList>( //Provide FavoriteList to widgets in our app
      model: favorite,
      child: MallApp()
    )
  );
  
  }
