import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:image_picker/image_picker.dart';
import 'globals.dart' as globals;
import 'dart:io';

class AddItem extends StatefulWidget{
  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<AddItem>{
  final String _defaultImgUrl = 'https://firebasestorage.googleapis.com/v0/b/mallapp-project.appspot.com/o/default_img.jpg?alt=media&token=64e2fd87-6655-421b-bfd4-bd247d197f6a';
  File _image;
  TextEditingController _nameController;
  TextEditingController _priceController;
  TextEditingController _descriptionController;
  TextEditingController _categoryController;

  bool _isDefault = true;

  DateTime _createTime = DateTime.now();
  DateTime _modifiedTime = DateTime.now();
  DateFormat formatter = DateFormat('y.M.d H:m:s');

  @override
  void initState(){
    super.initState();
    _nameController = TextEditingController();
    _priceController = TextEditingController();
    _descriptionController = TextEditingController();
    _categoryController = TextEditingController();
    globals.storage = FirebaseStorage.instance;
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

  @override
  void dispose(){
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<String> _imgUploadUrl() async{
    StorageReference ref = globals.storage.ref().child(_nameController.text);
    StorageUploadTask upload;
    if (_image != null){
      upload = ref.putFile(_image);
    }
    StorageTaskSnapshot taskSnapshot = await upload.onComplete;
    return await taskSnapshot.ref.getDownloadURL();
  }

  Future<void> _uploadData() async{
    String imgurl = _isDefault ? _defaultImgUrl : await _imgUploadUrl();
    Firestore.instance.collection('products').document(_nameController.text).setData({
      'name': _nameController.text,
      'imgurl': imgurl,
      'category': _categoryController.text.toLowerCase(),
      'description': _descriptionController.text,
      'created': _createTime,
      'modified': _modifiedTime,
      'likes': 0,
      'price': double.parse(_priceController.text),
      'editor': globals.userID.displayName,
      'uid' : globals.userID.uid,
    });
  }

  @override
  Widget build (BuildContext context){
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
        title: Text('Add',
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
            onPressed: () async {
              await _uploadData();// Upload product information to firebase storage and database
              Navigator.pop(context); // Return to the list of items page (HomePage) after uploading
            },
          ),
        ],
      ),
      body: ListView(
        children:[
         Container(
          width: MediaQuery.of(context).size.width,
          child: _isDefault ? FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: _defaultImgUrl,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
            ) : Image.file(_image, fit: BoxFit.fitWidth),
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
          SizedBox(height:10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: _categoryController,
              decoration: InputDecoration(
                hintText: 'Category', 
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
                    Text(formatter.format(_createTime)),
                    Text(' Create',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:[
                    Text(formatter.format(_modifiedTime)),
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
}