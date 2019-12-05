import 'package:flutter/material.dart';
import 'package:giv_tak_rec/model/personal_unit.dart';
import 'package:giv_tak_rec/services/db_helper.dart';
import './addItem.dart';


class CelebarationPage extends StatelessWidget {
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: DBHelper().getListPersonUnit(),
        builder: (BuildContext context, AsyncSnapshot<List<PersonalUnit>> snapshot) {
          return snapshot.hasData ?
            ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                PersonalUnit item = snapshot.data[index];
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    DBHelper().deletePerson(item.id);
                  },
                  child: ListTile(
                    title: Text(item.title),
                    leading: Text(item.id.toString()),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AddItemScreen.routeName,
                        arguments: ScreenArguments(
                          '축의금',
                          '자세히'
                        )
                      );
                    },
                  ),
                );
              },
            )
            : Center(
              child: CircularProgressIndicator(),
            ); 
        },
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
        tooltip: "등록",
        child: const Icon(Icons.add),
      ),
    );
  }
}
