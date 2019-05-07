import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';
import 'auth.dart';
import 'dart:io';

class EditPage extends StatefulWidget{
  final Product product;

  EditPage({Key key, @required this.product}) : super(key : key);

  _EditState createState() => _EditState();
}

class _EditState extends State<EditPage>{
  File _image;
  bool _isDefault = true;

  TextEditingController _nameController;
  TextEditingController _priceController;
  TextEditingController _descriptionController;
  TextEditingController _categoryController;
  DateTime _modifiedTime;

  @override
  void initState(){
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _priceController = TextEditingController(text: widget.product.price.toString());
    _descriptionController = TextEditingController(text: widget.product.description);
    _categoryController = TextEditingController(text: widget.product.category);
  }

  @override
  void dispose(){
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<String> _imgUploadUrl() async{
    StorageReference ref = AuthService.storage.ref().child(_nameController.text);
    StorageUploadTask upload;
    if (_image != null){
      upload = ref.putFile(_image);
    }
    StorageTaskSnapshot taskSnapshot = await upload.onComplete;
    return await taskSnapshot.ref.getDownloadURL();
  }

  Future _getImage() async{
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState((){
      if (image != null){
        _isDefault = false;
      }
      _image = image;
    });
  }

  Future<void> _uploadData() async{
    String imgurl = _isDefault ? widget.product.imgurl : await _imgUploadUrl();
    if(widget.product.name == _nameController.text){
      Firestore.instance.collection('products').document(widget.product.name).updateData({
        'name': _nameController.text,
        'imgurl': imgurl,
        'category': _categoryController.text.toLowerCase(),
        'description': _descriptionController.text,
        'modified': _modifiedTime,
        'price': double.parse(_priceController.text),
      });
    }
    else{
      Firestore.instance.collection('products').document(_nameController.text).setData({
        'name': _nameController.text,
        'imgurl': imgurl,
        'category': _categoryController.text.toLowerCase(),
        'description': _descriptionController.text,
        'created': widget.product.created,
        'modified': _modifiedTime,
        'likes': 0,
        'price': double.parse(_priceController.text),
        'editor': AuthService.user.displayName,
        'uid' : AuthService.user.uid,
      });
      await Firestore.instance.collection('products').document(widget.product.name).delete();
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Text('Cancel',
            style: TextStyle(
                color: Colors.black,
                fontSize: 11.0),
            ),
          onPressed: (){
            setState((){
              Navigator.pop(context);
            });
          }
        ),
        title: Text('Edit',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Text('Save', 
              style: TextStyle(
                color: Colors.white,
                fontSize: 11.0),
              ),
            onPressed: () { // put async here if we are going to _uploadData()
              setState(() async{
                await _uploadData();
                AuthService.currentSnapshot = await Firestore.instance.collection('products').document(widget.product.docID).get();
                Navigator.pop(context); // Return to the list of items page (HomePage) after uploading
              });
            },
          ),
        ],
      ),
      body: ListView(
        children:[
         Container(
            width: MediaQuery.of(context).size.width,
            child: _isDefault ? Image.network(widget.product.imgurl, fit: BoxFit.fitWidth) : Image.file(_image, fit: BoxFit.fitWidth),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.camera_alt,
                    color: Colors.black,
                  ),
                  onPressed: (){
                    _getImage();
                    _modifiedTime = DateTime.now();
                  }
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: _categoryController,
              decoration: InputDecoration(
                hintText: '<Category>', 
                hintStyle: TextStyle(
                  fontSize: 20.0,
                  color: Colors.blueGrey,
                ),
                enabled: true,
              ),
              onTap: (){
                setState((){
                  _modifiedTime = DateTime.now();
                });
              }
            ),
          ),
          SizedBox(height:10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Product Name', 
                hintStyle: TextStyle(
                  fontSize: 20.0,
                  color: Colors.blueGrey,
                ),
                enabled: true,
              ),
              onTap: (){
                setState((){
                  _modifiedTime = DateTime.now();
                });
              }
            ),
          ),
          SizedBox(height:10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: _priceController,
              decoration: InputDecoration(
                hintText: 'Price', 
                hintStyle: TextStyle(
                  fontSize: 20.0,
                  color: Colors.blueGrey,
                ),
              ),
              onTap: (){
                setState((){
                  _modifiedTime = DateTime.now();
                });
              }
            ),
          ),
          SizedBox(height:10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: 'Desccription', 
                hintStyle: TextStyle(
                  fontSize: 20.0,
                  color: Colors.blueGrey,
                ),
              ),
              onTap: (){
                setState((){
                  _modifiedTime = DateTime.now();
                });
              }
            ),
          ),
        ],
      ),
    );
  }
}
