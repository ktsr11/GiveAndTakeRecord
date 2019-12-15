import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:giv_tak_rec/bloc/personalUnit_bloc.dart';
import 'package:giv_tak_rec/model/personal_unit.dart';
import 'bloc/view_personalUnit_bloc.dart';
import 'input_validate.dart';

class AddItem extends StatefulWidget {
  AddItem({Key key, this.title, this.per}) : super(key : key);
  final String title;
  final PersonalUnit per;
  @override 
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<AddItem> {
  final _formKey = GlobalKey<FormState>();
  final _sizeHeight = 15.0;

  final UsNumberTextInputFormatter _phoneNumberFormatter = UsNumberTextInputFormatter.getInstance();
  final NumberTextInputFormatter _numberTextInputFormatter = NumberTextInputFormatter.getInstance();

  PersonalUnitBloc _bloc;
  ViewPersonalUnitBloc _viewBloc;

  @override 
  void initState() {
    super.initState();
    _bloc = PersonalUnitBloc();
    _viewBloc = ViewPersonalUnitBloc();
  }

  Future<void> _adaPerson(PersonalUnit per) async {
    _bloc.inAdd.add(per);
  }

  Future<void> _updatePerson(PersonalUnit per) async {
    _viewBloc.inSave.add(per);
  }

  void _deletePerson() {
    _viewBloc.inDelete.add(widget.per.id);
    _viewBloc.deleted.listen((deleted){
      if(deleted) {
        Navigator.of(context).pop(true);
      }
    });
  }

  @override 
  Widget build(BuildContext context) {
    PersonalUnit per = widget.per == null? PersonalUnit() : widget.per;
    var amt = per.amt;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deletePerson,
          ),
        ],
      ),
      body: SingleChildScrollView(  //키패드와 위젯사이에 충돌 나는 부분을 SingleChildScrollView 로 해결 
        child : Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0), 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  initialValue: per.title,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: false,
                    icon: Icon(Icons.subtitles),
                    labelText: '제목',
                    hintText: '제목을 입력해주세요.'
                  ),
                  validator: (value) {
                    if ( value.isEmpty) {
                      return '제목을 입력해주세요.';
                    }
                    return null;
                  },
                  onSaved: (value) => setState(() => per.title = value),
                ),
                SizedBox(
                  height: _sizeHeight,
                ),
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  initialValue: per.name,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: false,
                    icon: Icon(Icons.person),
                    hintText: '이름 입력',
                    labelText: '이름',
                  ),
                  onSaved: (value) => setState(() => per.name = value),
                  validator: InputValidate.validateName,
                ),
                SizedBox(
                  height: _sizeHeight,
                ),
                DateTimePickerFormField(
                  inputType: InputType.date, //날짜 및 시간 입력 받는 설정 
                  format: DateFormat("yyyy-MM-dd"), //날짜 포맷 지정 
                  decoration: InputDecoration(
                      labelText: '날짜입력',
                      border: UnderlineInputBorder(),
                      filled: false,
                      icon: Icon(Icons.calendar_today),
                  ),
                  onChanged: (dt) => setState(() => per.date = DateFormat("yyyy-MM-dd").format(dt)),
                ),
                SizedBox(
                  height: _sizeHeight,
                ),
                TextFormField(
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        filled: false,
                        icon: Icon(Icons.phone),
                        hintText: '전화번호를 입력해주세요.',
                        labelText: '전화번호',
                      ),
                      initialValue: per.phoneNumber,
                      keyboardType: TextInputType.phone,
                      onSaved: (value) => setState(() => per.phoneNumber = value),
                      validator: InputValidate.validatePhoneNumber,
                      // TextInputFormatters are applied in sequence.
                      inputFormatters: <TextInputFormatter> [
                        WhitelistingTextInputFormatter.digitsOnly,
                        // Fit the validating format.
                        _phoneNumberFormatter,
                      ],
                    ),
                SizedBox(
                  height: _sizeHeight,
                ),
                TextFormField(
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        filled: false,
                        icon: Icon(Icons.attach_money),
                        hintText: '경조사 금액을 입력해주세요.',
                        labelText: '금액',
                      ),
                      initialValue: per.amt.toString(),
                      textAlign: TextAlign.right,
                      keyboardType: TextInputType.number,
                      onSaved: (value) => setState(() => per.amt = int.parse(value.replaceAll(",", ""))  ),
                      validator: InputValidate.validateNumber,
                      // TextInputFormatters are applied in sequence.
                      inputFormatters: <TextInputFormatter> [

                        WhitelistingTextInputFormatter.digitsOnly,
                        // Fit the validating format.
                        _numberTextInputFormatter
                      ],
                    ),
                SizedBox(
                  height: _sizeHeight,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save(); //현재 TextFormField에 있는 onSaved를 호출한다. 
                      Navigator.pop(context);
                      per.id == null ? _adaPerson(per) : _updatePerson(per);

                        final snackBar = SnackBar(
                          content: Text("저장 완료"),
                        );
                        Scaffold.of(context).showSnackBar(snackBar);
                        
                      }
                    },
                    child: Text('저장'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
    
  }
}
