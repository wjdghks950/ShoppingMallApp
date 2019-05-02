import 'package:flutter/material.dart';

class MenuBar extends StatelessWidget{
  @override
  Widget build (BuildContext context){
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            padding: EdgeInsets.fromLTRB(20.0, 115.0, 20.0, 10.0),
            child: Text(
              'Pages',
              style: TextStyle(
                fontSize: 23.0,
                color: Colors.white,
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 30.0),
            leading: Icon(
              Icons.home,
              color: Colors.blue,
            ),
            title: Text('Home'),
            onTap: (){
              Navigator.pushNamed(context, '/home');
            }
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 30.0),
            leading: Icon(
              Icons.search,
              color: Colors.blue,
            ),
            title: Text('Search'),
            onTap: (){
              Navigator.pushNamed(context, '/search');
            }
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 30.0),
            leading: Icon(
              Icons.location_city,
              color: Colors.blue,
            ),
            title: Text('Favorite Hotel'),
            onTap: (){
              Navigator.pushNamed(context, '/favorite');
            }
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 30.0),
            leading: Icon(
              Icons.insert_chart,
              color: Colors.blue,
            ),
            title: Text('Ranking'),
            onTap: (){
              Navigator.pushNamed(context, '/ranking');
            }
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 30.0),
            leading: Icon(
              Icons.person,
              color: Colors.blue,
            ),
            title: Text('My Page'),
            onTap: (){
              Navigator.pushNamed(context, '/mypage');
            }
          ),
        ],
      ),
    );
  }
}