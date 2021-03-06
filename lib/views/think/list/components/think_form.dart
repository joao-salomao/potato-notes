import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:jubjub/utils/navigation.dart';
import 'package:jubjub/models/think_model.dart';
import 'package:jubjub/controllers/app_controller.dart';
import 'package:jubjub/views/widgets/app_alert_dialog.dart';
import 'package:jubjub/views/widgets/app_text_form_field.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

showThinkForm({
  @required BuildContext context,
  ThinkModel think,
  Function onChangeColor,
  Function onChangeTitle,
  Function onCancel,
  @required Function onSubmit,
}) async {
  final _appController = GetIt.I<AppController>();
  final _formKey = GlobalKey<FormState>();
  final _titleController =
      TextEditingController(text: think != null ? think.title : "");
  Color _color = think != null ? think.color : _appController.primaryColor;

  if (onChangeTitle != null) {
    _titleController.addListener(() {
      onChangeTitle(_titleController.text);
    });
  }

  final formTitle = think == null ? "Criando Pasta" : "Editando Pasta";

  return showDialog(
    context: context,
    useRootNavigator: true,
    barrierDismissible: true,
    builder: (_) {
      return AppAlertDialog(
        title: formTitle,
        content: Container(
          height: 310,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: AppTextFormField(
                    "Título",
                    "Digite o título da pasta",
                    cursorColor: think == null ? null : think.color,
                    controller: _titleController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "É obrigatório dar um título para a pasta";
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Expanded(
                child: MaterialColorPicker(
                  onColorChange: (Color newColor) {
                    _color = newColor;

                    if (onChangeColor != null) {
                      onChangeColor(newColor);
                    }

                    if (think != null) {
                      think.color = newColor;
                    }
                  },
                  selectedColor: think != null ? think.color : _color,
                ),
              ),
            ],
          ),
        ),
        onClose: () {
          if (onCancel != null) {
            onCancel();
          }
          pop(_);
        },
        onSave: () {
          onSubmit(
            _titleController.text,
            _color,
          );
          pop(_);
        },
      );
    },
  );
}
