import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:giv_tak_rec/database_helper.dart';

import 'package:intl/intl.dart';


class AddItemScreen extends StatelessWidget {
  static const routeName = '/addItem';

  @override 
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(args.title),
      ),
      //resizeToAvoidBottomPadding: false,  //하단 패딩으로 충돌나는 부분을 강제로 없애는 방법 
      body: InputForm(),
    );
  }
}

class InputForm extends StatefulWidget {
  @override 
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  final _formKey = GlobalKey<FormState>();
  final _sizeHeight = 15.0;
  final dbHelper = DatabaseHelper.instance;

  DateTime _date = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
          initialDate: _date,
      firstDate: DateTime(1950),
      lastDate: DateTime(2050),
    );

    if(picked != null && picked != _date) {
      print('Date selected: ${_date.toString()}');
      setState((){
        _date = picked;
      });
    }
  }

  @override 
  Widget build(BuildContext context) {
    return SingleChildScrollView(  //키패드와 위젯사이에 충돌 나는 부분을 SingleChildScrollView 로 해결 
      child : Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0), 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: '제목',
                  hintText: '제목을 입력해주세요.'
                ),
                validator: (value) {
                  if ( value.isEmpty) {
                    return '제목을 입력해주세요.';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: _sizeHeight,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "이름",
                  hintText: "이름을 입력해주세요."
                ),
                validator: (value) {
                  if(value.isEmpty){
                    return '이름을 입력해주세요.';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: _sizeHeight,
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    RaisedButton(
                      child: Text('날짜 선택'),
                      onPressed: () {
                        _selectDate(context); 
                      },
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Text('${DateFormat("yyyy-MM-dd").format(_date)}',style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: _sizeHeight,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [BlacklistingTextInputFormatter(new RegExp('[\\-|\\ ]'))],
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  labelText: "금액",
                  hintText: "금액을 입력해주세요."
                ),
                validator: (value) {
                  if(value.isEmpty){
                    return '금액을 입력해주세요.';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: _sizeHeight,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "전화번호",
                  hintText: "전화번호 입력",
                ),
                validator: (value) {
                  if(value.isEmpty){
                    return '전화번호를 입력해주세요.';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: () {
                    _delete();
                  },
                  child: Text('저장'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _insert() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnName : 'Bob',
      DatabaseHelper.columnAge : 23
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => print(row));
  }

  void _update() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnId : 1,
      DatabaseHelper.columnName : 'Mary',
      DatabaseHelper.columnAge : 32
    };
    final rowsAffected = await dbHelper.update(row);
    print('update $rowsAffected row(s)');
  }

  void _delete() async {
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
  }
}

class ScreenArguments {
  final String title;
  final String message;

  ScreenArguments(this.title, this.message);
}
