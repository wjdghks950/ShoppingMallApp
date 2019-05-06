import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'home.dart';
import 'favoritemodel.dart';
import 'edit.dart';
import 'auth.dart';

class ProductDetail extends StatefulWidget{
  final Product product;

  ProductDetail({Key key, @required this.product}) : super(key : key);

  _ProductState createState() => _ProductState(this.product);
}

class _ProductState extends State<ProductDetail>{
  bool _likes = false;
  final Product product;
  _ProductState(this.product);

  void _showDialog(){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text('Permission denied!'),
          content: Text('Only the writer can edit this page'),
        );
      }
    );
  }

  void _showInSnackBar(BuildContext context){
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: product.likes == 1 ? Text('You can only do it once!') : Text('I LIKE IT!'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: (){
            setState((){
              Firestore.instance.runTransaction((transaction) async{
                final freshSnapshot = await transaction.get(product.reference);
                final fresh = Product.fromSnapshot(freshSnapshot);

                await transaction.update(product.reference, {'likes': fresh.likes - 1});
                }
              );
              if(_likes){
                _likes = false;
              }
            });
          },
        )
      )
    );
  }

  Future<void> _delete(Product p) async{
    return await Firestore.instance.collection('products').document(p.name).delete();
  }

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
              if(AuthService.user.uid == product.uid){
                Navigator.push(context, MaterialPageRoute(builder: (context) => EditPage(product: product)));
              }
              else{
                _showDialog();
              }
            }
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.white),
            onPressed: () async {
              AuthService.storage.ref().child(product.name).delete();
              _delete(product);
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
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.thumb_up, color: _likes ? Colors.red : Colors.grey),
                            onPressed: (){
                              setState((){
                                if(product.likes == 0){
                                  Firestore.instance.runTransaction((transaction) async{
                                    final freshSnapshot = await transaction.get(product.reference);
                                    final fresh = Product.fromSnapshot(freshSnapshot);

                                    await transaction.update(product.reference, {'likes': fresh.likes + 1});
                                  }
                                  );
                                  if(!_likes){
                                    _likes = true;
                                  }
                                }
                                else{
                                  _showInSnackBar(context);
                                }
                              });
                            },
                            tooltip: product.likes.toString(),
                          ),
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
                    Text('creator: ' + AuthService.user.uid),
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