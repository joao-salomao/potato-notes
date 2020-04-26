import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:potato_notes/views/state/app_state.dart';
import 'package:potato_notes/views/widgets/app_alert_dialog.dart';
import 'package:potato_notes/views/widgets/app_text_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/navigation.dart';

class DrawerList extends StatefulWidget {
  @override
  _DrawerListState createState() => _DrawerListState();
}

class _DrawerListState extends State<DrawerList> {
  final state = GetIt.I<AppState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.text_fields),
              title: Text("Título Principal"),
              subtitle: Text("Alterar título principal"),
              trailing: Icon(Icons.arrow_forward),
              onTap: _changeMainTitleDialog,
            ),
            ListTile(
              leading: Icon(Icons.brush),
              title: Text("Cor Principal"),
              subtitle: Text("Alterar cor principal"),
              trailing: Icon(Icons.arrow_forward),
              onTap: _changeColorDialog,
            ),
            ListTile(
              leading: Icon(Icons.brightness_6),
              title: Text("Tema"),
              subtitle: Text("Alterar tema"),
              trailing: Icon(Icons.arrow_forward),
              onTap: _changeBrightnessDialog,
            ),
          ],
        ),
      ),
    );
  }

  _changeMainTitleDialog() async {
    final controller = TextEditingController(text: state.mainTitle);

    return showDialog(
      context: context,
      builder: (_) {
        return AppAlertDialog(
          title: "Atualizando título",
          content: Container(
            height: 60,
            child: Column(
              children: [
                AppTextFormField(
                  "Título",
                  "Digite o principal desejado",
                  controller: controller,
                  cursorColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
          onClose: _pop,
          onSave: () => _changeMainTitle(controller.text),
        );
      },
    );
  }

  _changeBrightnessDialog() {
    return showDialog(
      context: context,
      builder: (_) {
        return SimpleDialog(
          title: const Text('Selecione o tema'),
          children: [
            RadioListTile<Brightness>(
              value: Brightness.light,
              groupValue: Theme.of(context).brightness,
              onChanged: _changeBrightness,
              title: const Text('Claro'),
            ),
            RadioListTile<Brightness>(
              value: Brightness.dark,
              groupValue: Theme.of(context).brightness,
              onChanged: _changeBrightness,
              title: const Text('Escuro'),
            ),
          ],
        );
      },
    );
  }

  _changeColorDialog() {
    final originalColor = Theme.of(context).primaryColor;
    var color = Theme.of(context).primaryColor;
    return showDialog(
      context: context,
      builder: (_) {
        return AppAlertDialog(
          title: "Alterando cor principal",
          onClose: () {
            _changeColor(originalColor);
            _pop();
          },
          onSave: () {
            _changeColor(color);
            _pop();
          },
          content: Container(
            padding: EdgeInsets.all(10),
            height: 205,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: MaterialColorPicker(
                    onColorChange: (newColor) {
                      color = newColor;
                      _changeColor(newColor);
                    },
                    selectedColor: color,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _changeMainTitle(String text) {
    state.updateMainTitle(text);
    _pop();
  }

  _changeBrightness(Brightness value) {
    DynamicTheme.of(context).setBrightness(value).then((_) {
      setState(() => _pop());
    });
  }

  _changeColor(Color color) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("primaryColor", color.value);
    setState(() {
      DynamicTheme.of(context).setThemeData(
        ThemeData(
            primaryColor: color, brightness: Theme.of(context).brightness),
      );
    });
  }

  _pop() {
    pop(context);
  }
}
