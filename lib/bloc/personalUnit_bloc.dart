import 'dart:async';
import 'package:giv_tak_rec/bloc/bloc_base.dart';
import 'package:giv_tak_rec/model/personal_unit.dart';
import 'package:giv_tak_rec/services/db_helper.dart';



class PersonalUnitBloc implements BlocBase {

  final _controller = StreamController<List<PersonalUnit>>.broadcast();

  StreamSink<List<PersonalUnit>> get _inPers => _controller.sink;

  Stream<List<PersonalUnit>> get pers => _controller.stream;

  final _addController = StreamController<PersonalUnit>.broadcast();

  StreamSink<PersonalUnit> get inAdd => _addController.sink;

  PersonalUnitBloc() {
    getPersons();
    _addController.stream.listen(_addPersons);
    _saveController.stream.listen(_handleSavePersonal);
    _deleteController.stream.listen(_handleDeletePerson);

  }

  dispose() {
    _controller.close();
    _addController.close();
    _saveController.close();
    _deleteController.close();
    _deletedController.close();
  }

  void getPersons() async {
    List<PersonalUnit> pers = await DBHelper().getListPersonUnit();
    _inPers.add(pers);
  }

  void _addPersons(PersonalUnit person) async {
    await DBHelper().createData(person);
    getPersons();
  }

  final _saveController = StreamController<PersonalUnit>.broadcast();
  StreamSink<PersonalUnit> get inSave => _saveController.sink;

  final _deleteController = StreamController<int>.broadcast();
  StreamSink<int> get inDelete => _deleteController.sink;

  final _deletedController = StreamController<bool>.broadcast();
  StreamSink<bool> get _inDelete => _deletedController.sink;
  Stream<bool> get deleted => _deletedController.stream;

  _handleSavePersonal(PersonalUnit per)  {
     DBHelper().updatePerson(per);
  }

   _handleDeletePerson(int id)  {
     DBHelper().deletePerson(id);
    _inDelete.add(true);
  }
}