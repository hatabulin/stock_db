import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Склад'),
      ),
      drawer: new Drawer(
          child: new ListView(
            children: <Widget> [
              new DrawerHeader(child: new Text('Меню'),),
              new ListTile(
                title: new Text('Категории товаров'),
                onTap: () {},
              ),
              new ListTile(
                title: new Text('Поставщики'),
                onTap: () {},
              ),
              new Divider(),
              new ListTile(
                title: new Text('О программе'),
                onTap: () {},
              ),
            ],
          )
      ),
      body: new Center(
        child: new Text(
          'Center',
        ),
      ),
    );
  }
}