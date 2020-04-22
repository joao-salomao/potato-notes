import 'package:mobx/mobx.dart';
import 'package:potato_notes/dao/think_dao.dart';
import 'package:potato_notes/entities/annotation.dart';
import 'package:potato_notes/entities/think.dart';
part 'app_state.g.dart';

class AppState = _AppStateBase with _$AppState;

abstract class _AppStateBase with Store {
  final thinkDAO = ThinkDAO();

  @observable
  var thinks = ObservableList<Think>();

  @action
  getData() async {
    final list = await thinkDAO.findAll();
    thinks.clear();
    list.forEach((think) => thinks.add(think));
  }

  @action
  addThink(Think think) async {
    return await thinkDAO.save(think);
  }

  @action
  deleteThink(Think think) {}

  @action
  updateThink(Think think) {}

  @action
  addAnnotation(Annotation annotation) {}

  @action
  deleteAnnotation(Annotation annotation) {}

  @action
  updateAnnotation(Annotation annotation) {}
}
