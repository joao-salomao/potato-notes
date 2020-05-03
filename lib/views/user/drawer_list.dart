import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jubjub/services/backup_service.dart';
import 'package:jubjub/utils/navigation.dart';
import 'package:jubjub/controllers/app_controller.dart';
import 'package:jubjub/views/widgets/app_alert_dialog.dart';
import 'package:jubjub/views/widgets/app_text_form_field.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'backup_page.dart';

class DrawerList extends StatefulWidget {
  @override
  _DrawerListState createState() => _DrawerListState();
}

class _DrawerListState extends State<DrawerList> {
  final appController = GetIt.I<AppController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('Não Definido'),
              accountEmail: Text("email"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                  "https://img.elo7.com.br/product/zoom/2AE8EF2/placa-decorativa-quadro-anime-kakashi-naruto-v703-anime.jpg",
                ),
              ),
            ),
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
            ListTile(
              leading: Icon(Icons.list),
              title: Text("Backup"),
              subtitle: Text("Restaurar dados armazenados no Google Drive"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => push(context, BackupPage()),
            ),
          ],
        ),
      ),
    );
  }

  _changeMainTitleDialog() {
    final _titleController =
        TextEditingController(text: appController.mainTitle);

    return showDialog(
      context: context,
      builder: (_) {
        return Observer(
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
                      controller: _titleController,
                      cursorColor: appController.primaryColor,
                    ),
                  ],
                ),
              ),
              onClose: _pop,
              onSave: () => _changeMainTitle(_titleController.text),
            );
          },
        );
      },
    );
  }

  _changeBrightnessDialog() {
    return showDialog(
      context: context,
      builder: (_) {
        return Observer(
          builder: (_) {
            return SimpleDialog(
              title: Text('Selecione o tema'),
              children: [
                RadioListTile<Brightness>(
                  value: Brightness.light,
                  groupValue: appController.brightness,
                  onChanged: _changeBrightness,
                  title: Text('Claro'),
                ),
                RadioListTile<Brightness>(
                  value: Brightness.dark,
                  groupValue: appController.brightness,
                  onChanged: _changeBrightness,
                  title: Text('Escuro'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  _changeColorDialog() {
    final originalColor = appController.primaryColor;
    var color = appController.primaryColor;
    final changeColor = (Color newColor) {
      _changeColor(newColor);
      _pop();
    };

    return showDialog(
      context: context,
      builder: (_) {
        return AppAlertDialog(
          title: "Alterando cor principal",
          onClose: () => changeColor(originalColor),
          onSave: () => changeColor(color),
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
    appController.updateMainTitle(text);
    _pop();
  }

  _changeBrightness(Brightness value) {
    appController.setBrightness(value, context);
    _pop();
  }

  _changeColor(Color color) async {
    appController.updatePrimaryColor(color);
  }

  _pop() {
    pop(context);
  }
}
