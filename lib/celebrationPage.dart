import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:giv_tak_rec/addItem.dart';
import 'package:giv_tak_rec/bloc/bloc_base.dart';
import 'package:giv_tak_rec/bloc/personalUnit_bloc.dart';
import 'package:giv_tak_rec/bloc/view_personalUnit_bloc.dart';
import 'package:giv_tak_rec/model/personal_unit.dart';


class CelebarationPage extends StatelessWidget {

  CelebarationPage({Key key}) : super(key: key);

  @override 
  Widget build(BuildContext context) {
    return CelebarationBody();
  }
}

class CelebarationBody extends StatefulWidget {
  _CelbarationBody createState() => _CelbarationBody();
}

class _CelbarationBody extends State<CelebarationBody>{
  PersonalUnitBloc _bloc;
  //ViewPersonalUnitBloc _viewBloc;

  @override 
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<PersonalUnitBloc>(context);
   // _viewBloc = ViewPersonalUnitBloc();
  }

  void _navigateToItem(PersonalUnit per) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          bloc: PersonalUnitBloc(),
          child: AddItem(
            title: '등록',
            per: per
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<PersonalUnitBloc>(context);
    return Scaffold(
      body: StreamBuilder(
        stream: _bloc.pers,
        builder: (BuildContext context, AsyncSnapshot<List<PersonalUnit>> snapshot) {
          return snapshot.hasData
            ? ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                PersonalUnit item = snapshot.data[index];
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    _bloc.inDelete.add(item.id);
                  },
                  child: ListTile(
                    title: Text(item.title),
                    leading: Text(
                      item.id.toString(),
                    ),
                    onTap: () {
                      _navigateToItem(item);
                    },
                  ),
                );
              },
            )
            :
            Center(
              child: Center(
                child: Text('No Data'),
              ),
            );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
         _navigateToItem(null);
        },
        tooltip: "등록",
        child: const Icon(Icons.add),
      ),
    );
  }
}
