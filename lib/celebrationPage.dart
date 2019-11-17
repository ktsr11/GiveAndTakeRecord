import 'package:flutter/material.dart';
import './addItem.dart';


class CelebarationPage extends StatelessWidget {
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(10.0),
          color: Colors.amber[600],
          width: 48.0,
          height: 48.0,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(
            context,
            AddItemScreen.routeName,
            arguments: ScreenArguments(
              '축의금 등록',
              '새로운 것'
            )
          );
        },
        tooltip: "Increment Counter",
        child: const Icon(Icons.add),
      ),
    );
  }
}

class BodyLayout extends StatefulWidget {
  @override 
  BodyLayoutState createState() {
    return BodyLayoutState();
  }
}

class BodyLayoutState extends State<BodyLayout> {
  List<String> titles = ['Sun', 'Moon', 'Star'];

  @override 
  Widget build(BuildContext context) {
    return _myListView();
  }

  Widget _myListView() {
    return ListView.builder(
      itemCount: titles.length,
      itemBuilder: (context, index) {
        final item = titles[index];
        return Card(
          child: ListTile(
            title: Text(item),
            onTap: () {
              setState(() {
                titles.insert(index, 'Planet');
              });
            },
            onLongPress: () {
              setState(() {
                titles.removeAt(index);
              });
            },
          ),
        );
      },
    );
  }
}