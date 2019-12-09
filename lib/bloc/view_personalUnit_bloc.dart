import 'dart:async';
import 'package:giv_tak_rec/bloc/bloc_base.dart';
import 'package:giv_tak_rec/model/personal_unit.dart';
import 'package:giv_tak_rec/services/db_helper.dart';



class ViewPersonalUnitBloc implements BlocBase {

  final _saveController = StreamController<PersonalUnit>.broadcast();
  StreamSink<PersonalUnit> get inSave => _saveController.sink;

  final _deleteController = StreamController<int>.broadcast();
  StreamSink<int> get inDelete => _deleteController.sink;

  final _deletedController = StreamController<bool>.broadcast();
  StreamSink<bool> get _inDelete => _deletedController.sink;
  Stream<bool> get deleted => _deletedController.stream;

  ViewPersonalUnitBloc() {
    _saveController.stream.listen(_handleSavePersonal);
    _deleteController.stream.listen(_handleDeletePerson);
  }

  @override 
  void dispose() {
    _saveController.close();
    _deleteController.close();
    _deletedController.close();
  }

  void _handleSavePersonal(PersonalUnit per) async {
    await DBHelper().updatePerson(per);
  }

  void _handleDeletePerson(int id) async {
    await DBHelper().deletePerson(id);
    _inDelete.add(true);
  }
}