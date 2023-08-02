import 'package:flutter/material.dart';
import 'package:youthchurch/main.dart';
import 'package:youthchurch/sub/qna.dart';
import 'package:youthchurch/sub/quietTime.dart';

class MenuBottom extends StatefulWidget {

  MenuBottom({Key? key}) :super(key: key);

  @override
  State<MenuBottom> createState() => _MenuBottom();

}

class _MenuBottom extends State<MenuBottom>{
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    QuietTime(),
    QuietTime1(),
    QuietTime2(),
    QuietTime1()
  ];
  void _onItemTapped(int index){
    setState((){
      _selectedIndex = index;
    });
    /*switch (index) {
      case 0:
        Navigator.pushNamed(context, '/');
        break;
      case 1:
        Navigator.pushNamed(context, '/schedule');
        break;
      case 2:
        Navigator.pushNamed(context, '/qna');
        break;
      case 3:
        Navigator.pushNamed(context, '/fileUpload');
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(
              Icons.book,
              color: Colors.lightGreen,
            ),
            label: '큐티'),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_month_rounded,
              color: Colors.lightGreen,
            ),
            label: '일정'),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.book_rounded,
              color: Colors.lightGreen,
            ),
            label: '질문'),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.photo_camera,
              color: Colors.lightGreen,
            ),
            label: '추억')
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.green,
      onTap: _onItemTapped,
    );
  }
  @override
  void initState() {
    //해당 클래스가 호출되었을떄
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }
}
