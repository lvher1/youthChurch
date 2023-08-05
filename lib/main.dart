import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:youthchurch/MenuBottom.dart';
import 'package:youthchurch/widget_tree.dart';
import 'package:youthchurch/sub/quietTime.dart';
import 'package:youthchurch/sub/qna.dart';
import 'package:youthchurch/sub/schedule.dart';
import 'package:youthchurch/sub/fileUpload.dart';
import 'firebase_options.dart';
import 'package:youthchurch/MenuBottom.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( MyApp()); //app 시작
}
//먼저 플러커 코어 초기화

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        /*routes: {
          '/': (context) => WidgetTree(),
          '/qna': (context) => QuietTime(),
          '/schedule': (context) => QuietTime(),
          '/fileUpload': (context) => QuietTime(),
        },
        initialRoute: '/',*/
        title: 'BanseoYouth',
        theme: ThemeData(
            primarySwatch: Colors.lightGreen,
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
            backgroundColor: Colors.lightGreenAccent),
        debugShowCheckedModeBanner: false,
        home: WidgetTree()
        //
        );
  }
}

class QuietTime extends StatefulWidget {
  const QuietTime({super.key});

  @override
  State<QuietTime> createState() => _QuietTimeState();
}

class _QuietTimeState extends State<QuietTime>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    QuietTime1(),
    Schedule(),
    QuietTime2(),
    FileUpload()
  ];

  void _onItemTapped(int index) {
    setState(() {
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

  static const TextStyle optionStyle = TextStyle(
    fontSize: 20,
  );
  //late TabController controller;

  @override
  void initState() {
    super.initState();
    //controller = TabController(length: 4, vsync: this);
    //length: tab개수, vsync: tab이동시 호출되는 콜백함수 처리 위치 지정
  }

  @override
  void dispose() {
    //controller.dispose();
    super.dispose();
  } //메모리 누수 방지

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff8BC34A),
        title: Center(
          child: Text(
            'Banseo Youth',
            style: TextStyle(color: Colors.white, fontFamily: 'Billabong', fontSize: 35),
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(13))),
      ),
      body: SafeArea(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      /*TabBarView(
        children: <Widget>[QuietTime1(),QuietTime2(),QuietTime(),QuietTime1()],
        controller: controller,
      ),*/
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
          bottomLeft: Radius.circular(15.0),
          bottomRight: Radius.circular(15.0)
        ),
        child: BottomNavigationBar(
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
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      ),
      backgroundColor: Color(0xffDCEDC8),
    );
  }

/*@override
  void initState() {
    //해당 클래스가 호출되었을떄
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }*/
}
