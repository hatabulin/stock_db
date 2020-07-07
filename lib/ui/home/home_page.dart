import 'package:flutter/material.dart';
import 'package:stockdb/constants/uistrings.dart';
import 'package:stockdb/ui/widgets/elements/appStyle.dart';
import 'package:stockdb/ui/widgets/elements/textStyles.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _filter = "";
  String _selectedValue;
  String _currentValue;
  List _category = ["Дисплей", "Динамик"];
  List<DropdownMenuItem<String>> _dropDownMenuItems;

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String category in _category) {
      items.add(
          new DropdownMenuItem(value: category, child: new Text(category)));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentValue = _dropDownMenuItems[0].value;
    return new Scaffold(
        backgroundColor: Colors.white,
        appBar: new AppBar(
          title: new Text('Склад'),
        ),
        drawer: new Drawer(
            child: new ListView(
          children: <Widget>[
            new DrawerHeader(
              child: new Text('Меню'),
            ),
            new ListTile(
              title: new Text('Товары'),
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
        )),
        body: _productsListWidget());
  }

  Widget _productsListWidget() {
    return Container(
    padding: EdgeInsets.only(left: 10, right: 10),
      child:Column(children: <Widget>[
      SizedBox(
        height: 20,
      ),
      _filterWidget(),
      _productCategoryWidget(),
      SizedBox(
        height: 50,
      ),
      _tableBar(),
    ]));
  }

  Widget _filterWidget() {
    return Row(children: <Widget>[
      Text(
        'Фильтр наименования:',
        style: TextStyle(fontSize: 14),
      ),
      Container(
        padding: EdgeInsets.only(left: 20),
        width: 200,
        child: TextFormField(
            style: TextStyle(fontSize: 14), validator: (value) {}),
      )
    ]);
  }

  Widget _productCategoryWidget() {
    return Row(children: <Widget>[
      Text(
        'Категория товара:',
        style: TextStyle(fontSize: 14),
      ),
      Container(
          padding: EdgeInsets.only(left: 20),
          width: 200,
          child: DropdownButton(
            style: TextStyle(fontSize: 14, color: appNormalTextColor,),
            isExpanded: true,
            value: _currentValue,
            items: _dropDownMenuItems,
            onChanged: (value) {
              _selectedValue = value;
            },
          ))
    ]);
  }

  Widget _tableBar() {
    return Column(children: <Widget>[
      Row(children: <Widget>[
        Expanded(
          flex: 3,
          child: Text(
            UIStrings.product_name,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(UIStrings.quantity,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Expanded(
          flex: 2,
          child: Text(UIStrings.price,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Expanded(
          flex: 2,
          child: Text(UIStrings.price_total,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ]),
      SizedBox(
        height: 5,
      ),
      Divider(
        color: Colors.black,
        height: 3,
      )
    ]);
  }
}
