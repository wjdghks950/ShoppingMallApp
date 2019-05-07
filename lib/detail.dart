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
  bool _like = false;
  int like = 0;
  final Product product;
  _ProductState(this.product);

  @override
  void initState(){
    if(AuthService.currentSnapshot.data['likes'] == 1){
      _like = true;
    }
    like = AuthService.currentSnapshot.data['likes'];
    super.initState();
  }

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

  void _showInSnackBar(BuildContext context, Product p, String message){
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 1),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.blue,
          onPressed: () async{
            setState((){
              if(p.likes == 1){
                p.reference.updateData({'likes': p.likes-1});
              }
            });
          },
        )
      )
    );
  }

  Widget _buildBody(BuildContext context){
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection('products').document(product.docID).snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return LinearProgressIndicator();
        }
        return _buildButton(context, snapshot.data);
      },
    );
  }

  Widget _buildButton(BuildContext context, DocumentSnapshot snapshot){
    final p = Product.fromSnapshot(snapshot);
    return Row(
          children: [
            IconButton(
              icon: Icon(Icons.thumb_up, color: p.likes == 1 ? Colors.red : Colors.grey),
              onPressed: (){
                if(AuthService.user.uid == p.uid){
                  if(p.likes == 0){
                    p.reference.updateData({
                      'likes': p.likes + 1,
                    });
                    _showInSnackBar(context, p, 'I LIKE IT!');
                  }
                  else if(p.likes == 1){
                    _showInSnackBar(context, p, 'You can only do it once!');
                  }
                }
                else{
                  _showDialog();
                }
              },
            ),
            Text(
              p.likes.toString(),
              style: TextStyle(color: Colors.black),
            ),
          ],
        );
  }

  Future<void> _delete(Product p) async{
    await product.reference.delete();
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
              //AuthService.storage.ref().child(product.name).delete();
              if(AuthService.user.uid == product.uid){
                _delete(product);
              }
              else{
                _showDialog();
              }
              Navigator.of(context).pop();
            }
          )
        ],
      ),
      body: Builder(
        builder: (context) => 
          ListView(
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
                        AuthService.currentSnapshot.data['category'],
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
                            AuthService.currentSnapshot.data['name'],
                            style: TextStyle(
                              color: Colors.blue[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 25.0,
                            ),
                          ),
                          Spacer(),
                          _buildBody(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
                child: Text(
                    product == null ? '' : formatter.format(AuthService.currentSnapshot.data['price']).toString(),
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
                    product == null ? '' : AuthService.currentSnapshot.data['description'],
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