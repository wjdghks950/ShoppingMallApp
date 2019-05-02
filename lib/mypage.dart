import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'favoritemodel.dart';
import 'package:scoped_model/scoped_model.dart';

class MyPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('My Page',
          style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Center(
        child: CarouselSlider(
          height: 200.0,
          autoPlay: true,
          enlargeCenterPage: true,
          items: ScopedModel.of<FavoriteList>(context).saved.map((item){ //TODO: Division by zero exception when no favorites
            return Builder(
              builder: (BuildContext context){
                return Stack(
                  children:[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal :5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: AssetImage(
                            item.assetName,
                            package: item.assetPackage),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                      child: Align(
                        alignment: FractionalOffset(0.9, 0.95),
                        child: Text(item.name, 
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w500),
                          ),
                        ),
                    ),
                  ],
                );
              }
            );
          }).toList(),
        ),
      ),
    );
  }
}