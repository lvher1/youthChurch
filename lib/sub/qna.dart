import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:youthchurch/MenuBottom.dart';
import 'package:youthchurch/auth.dart';
import 'package:flutter/material.dart';
import 'package:youthchurch/MenuBottom.dart';

class QuietTime2 extends StatefulWidget {
  const QuietTime2({Key? key}) : super(key: key);

  @override
  State<QuietTime2> createState() => _QuietTime2();
}

class _QuietTime2 extends State<QuietTime2> {
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
        .doc(currentUser.currentUser!.email.toString())
        .collection(currentUser.currentUser!.email.toString())
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
                            .collection(
                            currentUser.currentUser!.email.toString())
                            .doc(documentSnapshot.id)
                            .update({
                          "name": name,
                          "content": content,
                          "writer": writer,
                          "datetime" : DateTime.now()
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
                            .doc(currentUser.currentUser!.email.toString())
                            .collection(
                            currentUser.currentUser!.email.toString())
                            .add({
                          "name": name,
                          "datetime": DateTime.now(),
                          "writer": writer,
                          "like": 0
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiet Time2'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('QuietTime')
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                streamSnapshot.data!.docs[index];
                return Card(
                  margin: const EdgeInsets.only(
                      left: 16, right: 16, top: 8, bottom: 8),
                  child: ListTile(
                    title: Text(documentSnapshot['name']),
                    subtitle: Text(documentSnapshot['date']),
                    trailing: SizedBox(
                      width: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () {
                              _RaiseCount(documentSnapshot);
                            },
                            icon: Icon(Icons.favorite_border),
                          ),
                          Text(
                            documentSnapshot['like'].toString(),
                            style:
                            TextStyle(color: Colors.purple, fontSize: 20),
                          ),
                          IconButton(
                              onPressed: () {
                                _update(documentSnapshot);
                              },
                              icon: Icon(Icons.edit)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      backgroundColor: Color(0xffDCEDC8),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightGreenAccent,
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
