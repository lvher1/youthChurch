import 'package:youthchurch/auth.dart';
import 'package:youthchurch/main.dart';
import 'package:youthchurch/login_register_page.dart';
import 'package:flutter/material.dart';
import 'package:youthchurch/sub/quietTime.dart';

class WidgetTree extends StatefulWidget{
  const WidgetTree({Key? key}) : super(key:key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}
class _WidgetTreeState extends State<WidgetTree>{
  @override
  Widget build(BuildContext context){
    return StreamBuilder(stream: Auth().authStateChanges,builder: (context,snapshot){
      if(snapshot.hasData){
        return const QuietTime();
      }else{
        return const LoginPage();
      }
    },);
  }
}