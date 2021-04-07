import 'package:app/utils/color_resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rxdart/rxdart.dart';

class ChatTextField extends StatelessWidget {
  TextEditingController textEditingController;
  Function(String) onTextChange;
  VoidCallback plusClickCallback;
  ChatTextField({this.textEditingController,this.onTextChange,this.plusClickCallback});
BehaviorSubject<bool> sendButton=BehaviorSubject<bool>();
Stream<bool> get sendButtonStream=>sendButton.stream;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: const Color(0xffffffff),
        boxShadow: [
          BoxShadow(
            color: const Color(0x4d455b63),
            offset: Offset(5, 0),
            blurRadius: 16,
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: TextField(
              maxLines: 5,
              minLines: 2,
              onChanged: (value){
                onTextChange(value);
                if(value.length==0){
                  sendButton.sink.add(false);
                }else{

                  sendButton.sink.add(true);
                }
              },
              controller: textEditingController,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 24),
                hintText: 'Say something...',
                hintStyle: TextStyle(
                  fontFamily: 'Gibson',
                  fontSize: 14,
                  color: const Color(0xff78849e),
                ),
              ),
            ),
          ),
          plusIcon()
        ],
      ),
    );
  }

  plusIcon() {
    return // Adobe XD layer: 'union' (shape)
        Expanded(
      flex: 1,
      child: Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          height: 50,
          width: 50,
          child: StreamBuilder<bool>(
            stream: sendButtonStream,
            initialData: false,
            builder: (context, snapshot) {
              return FlatButton(
                padding: EdgeInsets.all(12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
                onPressed: (){
                  plusClickCallback();
                },

                child: snapshot.data ?Icon(Icons.send,color: ColorResources.app_primary_color,):Icon(Icons.add,color:ColorResources.app_primary_color,),
              );
            }
          ),
        ),
      ),
    );
  }
}
