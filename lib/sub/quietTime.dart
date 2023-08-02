import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:youthchurch/MenuBottom.dart';
import 'package:youthchurch/auth.dart';
import 'package:flutter/material.dart';
import 'package:youthchurch/MenuBottom.dart';

class QuietTime1 extends StatefulWidget {
  const QuietTime1({Key? key}) : super(key: key);

  @override
  State<QuietTime1> createState() => _QuietTime1();
}

class _QuietTime1 extends State<QuietTime1> {
  User? user = Auth().currentUser;

  final TextEditingController likeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController writerController = TextEditingController();

  Future<void> _RaiseCount(DocumentSnapshot documentSnapshot) async {
    var count = documentSnapshot['like'];
    var plus = count + 1;

    FirebaseFirestore.instance
        .collection('QuietTime')
        .doc(documentSnapshot.id)
        .update({"like": plus});
  }

  Future<void> _update(DocumentSnapshot documentSnapshot) async {
    nameController.text = documentSnapshot['name'];
    contentController.text = documentSnapshot['content'];
    writerController.text = documentSnapshot['writer'];

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            child: Padding(
              padding: EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: '제목'),
                  ),
                  TextField(
                    controller: contentController,
                    decoration: InputDecoration(labelText: '내용'),
                  ),
                  TextField(
                    controller: writerController,
                    decoration: InputDecoration(labelText: '작성자'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        final String name = nameController.text;
                        final String content = contentController.text;
                        final String writer = writerController.text;
                        FirebaseFirestore.instance
                            .collection('QuietTime')
                            .doc(documentSnapshot.id)
                            .update({
                          "name": name,
                          "content": content,
                          "writer": writer,
                          "datetime": DateTime.now(),
                          "uid": currentUser.currentUser!.email.toString()
                        });
                        Navigator.of(context).pop();
                      },
                      child: Text('수정')),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _create() async {
    nameController.text = '';
    contentController.text = '';
    writerController.text = '';
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            child: Padding(
              padding: EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: '제목'),
                  ),
                  TextField(
                    controller: contentController,
                    decoration: InputDecoration(labelText: '내용'),
                  ),
                  TextField(
                    controller: writerController,
                    decoration: InputDecoration(labelText: '작성자'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        final String name = nameController.text;
                        final String content = contentController.text;
                        final String writer = writerController.text;

                        await FirebaseFirestore.instance
                            .collection('QuietTime')
                            .add({
                          "name": name,
                          "datetime": DateTime.now(),
                          "writer": writer,
                          "uid": currentUser.currentUser!.email.toString(),
                          "like": 0,
                          "content": content
                        });
                        Navigator.of(context).pop();
                      },
                      child: Text('QT등록')),
                ],
              ),
            ),
          );
        });
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  final currentUser = FirebaseAuth.instance;
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiet Time'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('QuietTime').snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              new Container(
                                height: 40.0,
                                width: 40.0,
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  /*image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: new NetworkImage(
                                          "https://pbs.twimg.com/profile_images/916384996092448768/PF1TSFOE_400x400.jpg")),
                                */
                                ),
                              ),
                              new SizedBox(
                                width: 10.0,
                              ),
                              new Text(
                                documentSnapshot['writer'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Container(
                        width: 400,
                        height: 200,
                        margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.lightGreen),
                          color: Colors.white
                        ),
                          child: new Text(
                        documentSnapshot['content'],
                        style: TextStyle(color: Colors.green),
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              new IconButton(
                                icon: new Icon(isPressed
                                    ? Icons.favorite
                                    : FontAwesomeIcons.heart),
                                color: isPressed ? Colors.red : Colors.black,
                                onPressed: () {
                                  setState(() {
                                    isPressed = !isPressed;
                                  });
                                },
                              ),
                              new SizedBox(
                                width: 16.0,
                              ),
                              new Icon(
                                FontAwesomeIcons.comment,
                              ),
                              new SizedBox(
                                width: 16.0,
                              ),
                              new Icon(FontAwesomeIcons.paperPlane),
                            ],
                          ),
                          //new Icon(FontAwesomeIcons.bookmark)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "Liked ${[documentSnapshot['like']]}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new Container(
                            height: 40.0,
                            width: 40.0,
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              /*image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: new NetworkImage(
                                          "https://pbs.twimg.com/profile_images/916384996092448768/PF1TSFOE_400x400.jpg"),
                                    ),*/
                            ),
                          ),
                          new SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: new TextField(
                              decoration: new InputDecoration(
                                border: InputBorder.none,
                                hintText: "Add a comment...",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text("1 Day Ago",
                          style: TextStyle(color: Colors.grey)),
                    )
                  ],
                );
                /*return Card(
                  margin: const EdgeInsets.only(
                      left: 16, right: 16, top: 8, bottom: 8),
                  child: ListTile(
                    //leading: Icon(Icons.person_2_rounded),
                    //style: Padding(),
                    title: Text(
                      documentSnapshot['name'],
                      style: TextStyle(color: Colors.lightGreen),
                    ),
                    subtitle: Text(
                      documentSnapshot['writer'],
                      style: TextStyle(color: Colors.green),
                    ),
                    trailing: SizedBox(
                      width: 150,
                      height: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () {
                              _RaiseCount(documentSnapshot);
                            },
                            icon: Icon(
                              Icons.favorite_border,
                              color: Colors.lightGreen,
                            ),
                          ),
                          Text(
                            documentSnapshot['like'].toString(),
                            style: TextStyle(color: Colors.green, fontSize: 20),
                          ),
                          IconButton(
                            onPressed: () {
                              _update(documentSnapshot);
                            },
                            icon: Icon(Icons.edit),
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ),
                    //isThreeLine: true,
                  ),
                  color: Colors.white,
                );*/
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ), //,bottomNavigationBar: MenuBottom(),
      backgroundColor: Color(0xffDCEDC8),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          _create();
        },
        child: Icon(
          Icons.add_box,
          color: Colors.lightGreen,
        ),
      ),
      //StreamBuilder로 지속적인 데이터 주고 받음
    );
  }
}
