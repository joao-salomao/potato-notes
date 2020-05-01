import 'package:flutter/material.dart';
import 'package:potato_notes/utils/navigation.dart';
import 'package:potato_notes/models/think_model.dart';
import 'package:potato_notes/views/widgets/app_text.dart';
import 'package:potato_notes/models/annotation_model.dart';
import 'package:potato_notes/views/annotation/annotation_page.dart';
import 'package:potato_notes/controllers/annotation_controller.dart';
import 'package:potato_notes/views/widgets/app_text_form_field.dart';

class AnnotationCard extends StatefulWidget {
  final Key key;
  final AnnotationModel annotation;
  final ThinkModel think;
  final AnnotationController annotationController;

  AnnotationCard(
    this.key,
    this.annotation,
    this.think,
    this.annotationController,
  );

  @override
  _AnnotationCardState createState() => _AnnotationCardState();
}

class _AnnotationCardState extends State<AnnotationCard> {
  _onEnterPassword() {
    return showDialog(
      context: context,
      builder: (_) {
        return Container(
          child: SimpleDialog(
            title: Text('Acessando anotação privada'),
            children: [
              Container(
                padding: EdgeInsets.only(
                  right: 20,
                  left: 20,
                  bottom: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    AppTextFormField(
                      "Digite a senha da anotação",
                      "",
                      obscureText: true,
                      cursorColor: widget.annotation.color,
                      onChange: (value) {
                        if (value == widget.annotation.password) {
                          pop(context);
                          _pushAnnotationPage();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _pushAnnotationPage() {
    push(
      context,
      AnnotationPage(
        widget.annotation,
        widget.think,
        widget.annotationController,
      ),
    );
  }

  _onTapCard() {
    print(widget.annotation.password);
    if (widget.annotation.password == null) {
      _pushAnnotationPage();
      return;
    }
    _onEnterPassword();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      padding: EdgeInsets.all(5),
      child: InkWell(
        onTap: _onTapCard,
        child: Card(
          color: widget.annotation.color,
          elevation: 10,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  widget.annotation.title,
                  bold: true,
                  fontSize: 18,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text(
                    widget.annotation.text,
                    softWrap: true,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 3),
                            child: Icon(
                              Icons.local_parking,
                              color: Colors.white,
                            ),
                          ),
                          AppText(
                              "${widget.annotation.getAnnotationTotalWords()}"),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 3),
                            child: Icon(
                              Icons.filter,
                              color: Colors.white,
                            ),
                          ),
                          AppText(
                              "${widget.annotation.getAnnotationFilesCountByType("image")}"),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 3),
                            child: Icon(
                              Icons.video_library,
                              color: Colors.white,
                            ),
                          ),
                          AppText(
                              "${widget.annotation.getAnnotationFilesCountByType("video")}"),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 3),
                            child: Icon(
                              Icons.audiotrack,
                              color: Colors.white,
                            ),
                          ),
                          AppText(
                              "${widget.annotation.getAnnotationFilesCountByType("audio")}"),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}