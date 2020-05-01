import 'package:mobx/mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:potato_notes/models/think_model.dart';
import 'package:potato_notes/models/annotation_model.dart';
import 'package:potato_notes/controllers/app_controller.dart';
part 'annotation_list_page_controller.g.dart';

class AnnotationListPageController = _AnnotationListPageControllerBase
    with _$AnnotationListPageController;

abstract class _AnnotationListPageControllerBase with Store {
  final appController = GetIt.I<AppController>();

  @observable
  ThinkModel think;

  _AnnotationListPageControllerBase(this.think);

  @action
  deleteAnnotation(AnnotationModel annotationModel) {
    think.annotations.remove(annotationModel);
    appController.deleteAnnotation(annotationModel);
  }

  @action
  reOrderAnnotations(int oldIndex, int newIndex) {
    final isLast = newIndex == think.annotations.length;
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final otherThink = think.annotations.elementAt(newIndex);
    final reOrderedThink = think.annotations.removeAt(oldIndex);

    reOrderedThink.listIndex = newIndex;
    otherThink.listIndex = oldIndex;

    appController.annotationDAO.save(reOrderedThink);
    appController.annotationDAO.save(otherThink);

    if (isLast) {
      think.annotations.add(reOrderedThink);
      return;
    }
    think.annotations.insert(newIndex, reOrderedThink);
  }
}
