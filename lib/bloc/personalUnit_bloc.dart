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

  }

  dispose() {
    _controller.close();
    _addController.close();
  }

  void getPersons() async {
    List<PersonalUnit> pers = await DBHelper().getListPersonUnit();
    _inPers.add(pers);
  }

  void _addPersons(PersonalUnit person) async {
    await DBHelper().createData(person);
    getPersons();
  }
}