import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:giv_tak_rec/bloc/personalUnit_bloc.dart';
import 'package:giv_tak_rec/model/personal_unit.dart';
import 'input_validate.dart';

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

  final UsNumberTextInputFormatter _phoneNumberFormatter = UsNumberTextInputFormatter.getInstance();
  final NumberTextInputFormatter _numberTextInputFormatter = NumberTextInputFormatter.getInstance();

  PersonalUnitBloc bloc = PersonalUnitBloc();
  PersonalUnit per = PersonalUnit();

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
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
                textCapitalization: TextCapitalization.words,
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
                initialDate: DateTime.now(),
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
                     _formKey.currentState.save();
                      bloc.addPersons(per);

                      final snackBar = SnackBar(
                        content: Text("저장 완료"),
                      );
                      Scaffold.of(context).showSnackBar(snackBar);
                      Navigator.pop(context);
                    }
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
}

class ScreenArguments {
  final String title;
  final String message;

  ScreenArguments(this.title, this.message);
}

