import 'dart:async';
import 'package:giv_tak_rec/model/personal_unit.dart';
import 'package:giv_tak_rec/services/db_helper.dart';


class PersonalUnitBloc {
  PersonalUnitBloc() {
    getPersons();
  }

  final _personController = StreamController<List<PersonalUnit>>.broadcast();
  get persons => _personController.stream;

  dispose() {
    _personController.close();
  }

  getPersons() async {
    _personController.sink.add(await DBHelper().getListPersonUnit());
  }

  addPersons(PersonalUnit person) async {
    await DBHelper().createData(person);
    getPersons();
  }

  deletePerson(int id) async {
    await DBHelper().deletePerson(id);
  }

  deleteAll() async {
    await DBHelper().deletaAllPerson();
    getPersons();
  }

  updatePerson(PersonalUnit person) async {
    await DBHelper().updatePerson(person);
    getPersons();
  }
}