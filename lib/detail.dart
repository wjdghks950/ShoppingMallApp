import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart';
import 'item.dart';
import 'home.dart';
import 'favoritemodel.dart';
import 'globals.dart' as globals;

class ProductDetail extends StatefulWidget{
  final Product product;

  ProductDetail({Key key, @required this.product}) : super(key : key);

  _ProductState createState() => _ProductState(this.product);
}

class _ProductState extends State<ProductDetail>{
  final Product product;
  bool _liked = false;
  _ProductState(this.product);

  @override
  Widget build(BuildContext context){
    final NumberFormat formatter = NumberFormat.simpleCurrency(
      locale: Localizations.localeOf(context).toString()
    );
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text('Detail',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        actions:[
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: (){

            }
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.white),
            onPressed: (){

            }
          )
        ],
      ),
      body: ListView(
            children:[
              Image.network(
                product.imgurl,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fitWidth,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top:10.0),
                      child: Text(
                        product.category,
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,),
                        ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top:10.0),
                      child: Row(
                        children: [
                          Text(
                            product.name,
                            style: TextStyle(
                              color: Colors.blue[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 25.0,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.thumb_up, color: _liked ? Colors.red : Colors.grey),
                            onPressed: (){

                            }
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
                child: Text(
                    product == null ? '' : formatter.format(product.price).toString(),
                    style: TextStyle(
                      color: Colors.blue[600],
                      fontSize: 20.0,
                    ),
                ),
              ),
              Padding(
                padding:EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
                child: Divider(height: 2.0, color: Colors.grey),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                child:
                  Text(
                    product == null ? '' : product.description,
                    style: TextStyle(
                      color: Colors.blue[600],
                      fontSize: 13.0,
                    ),
                ),
              ),
              SizedBox(height:20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children:[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:[
                    Text('creator: ' + globals.userID.uid),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:[
                    Text(product.created.toString()),
                    Text(' Created',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:[
                    Text(product.modified.toString()),
                    Text(' Modified',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
            ],
        ),
    );
  }
  Widget _checkFavorite(product){ // Returns the IconButton widget for details page and stores each product in saved list.
    return ScopedModelDescendant<FavoriteList>(
      builder: (context, child, favoritelist) => IconButton(
        icon: Icon(favoritelist.saved.contains(product) ? Icons.favorite : Icons.favorite_border, 
                  color: Colors.red),
        onPressed:(){ setState((){
            if(favoritelist.saved.contains(product)){
              favoritelist.saved.remove(product);
            }
            else{
              favoritelist.add(product);
            }
          }
          );
        },
      ),
    );
  }
}