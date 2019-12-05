import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class InputValidate {
  static String validateName(String value) {
    if (value.isEmpty)
      return '이름입력이 필요합니다.';
    // final RegExp nameExp = RegExp(r'^[A-Za-z ]+$');
    // if (!nameExp.hasMatch(value))
    //   return '문자로만 입력이 가능합니다.';
    return null;
  }


  static String validatePhoneNumber(String value) {
    if (value.isEmpty)
      return '전화번호를 입력해주세요.';
    // final RegExp phoneExp = RegExp(r'^\(\d\d\d\) \d\d\d\-\d\d\d\d$');
    // if (!phoneExp.hasMatch(value))
    //   return '###-####-#### - 폰 전화번호 입력.';
    return null;
  }

  static String validateNumber(String value) {
    if (value.isEmpty)
      return '금액을 입력이 필요합니다.';
    final RegExp numberExp = RegExp(r'^[0-9]');
    if(!numberExp.hasMatch(value))
      return '숫자 형식으로만 입력.';
    return null;
  }
}

class UsNumberTextInputFormatter extends TextInputFormatter {
  static UsNumberTextInputFormatter _instance;

  static UsNumberTextInputFormatter getInstance() {
    if (_instance == null) {
      _instance = UsNumberTextInputFormatter();
    }

    return _instance;
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = StringBuffer();
    if (newTextLength >= 4) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 3) + ') ');
      if (newValue.selection.end >= 3)
        selectionIndex += 2;
    }
    if (newTextLength >= 7) {
      newText.write(newValue.text.substring(3, usedSubstringIndex = 7) + '-');
      if (newValue.selection.end >= 7)
        selectionIndex++;
    }
    // Dump the rest.
    if (newTextLength >= usedSubstringIndex)
      newText.write(newValue.text.substring(usedSubstringIndex));
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

class NumberTextInputFormatter extends TextInputFormatter {
  static NumberTextInputFormatter _instance;

  static NumberTextInputFormatter getInstance() {
    if (_instance == null) {
      _instance = NumberTextInputFormatter();
    }
    return _instance;
  }

  @override 
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ){
    return TextEditingValue(
      text: new NumberFormat("#,###").format( int.parse( newValue.text.toString() ) ),
    );
  }
}

