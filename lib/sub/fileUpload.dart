import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:youthchurch/MenuBottom.dart';
import 'package:youthchurch/auth.dart';
import 'package:flutter/material.dart';
import 'package:youthchurch/MenuBottom.dart';
import 'package:file_picker/file_picker.dart';

showToast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

class Content {
  String content;
  String downloadurl;
  String date;

  Content(
      {required this.content, required this.date, required this.downloadurl});

  Content.fromJson(Map<String, dynamic> json)
      : content = json['content'],
        downloadurl = json['downloadurl'],
        date = json['date'];

  Map<String, dynamic> toJson() => {
        'content': content,
        'downloadurl': downloadurl,
        'date': date,
      };
}

class FileUpload extends StatefulWidget {
  const FileUpload({Key? key}) : super(key: key);

  @override
  State<FileUpload> createState() => _FileUpload();
}

class _FileUpload extends State<FileUpload> {
  final contentsRef = FirebaseFirestore.instance
      .collection('memory').orderBy('date',descending: true)
      .withConverter<Content>(
          fromFirestore: (snapshots, _) => Content.fromJson(snapshots.data()!),
          toFirestore: (content, _) => content.toJson());

  //PlatformFile
  Future selectFile() async {
    //final result = await FilePicker.platform.pickFiles();
  }

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

  final controller = TextEditingController(text: '');
  bool isImageVisible = false;
  XFile? _image;
  String? downloadurl;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future getGalleryImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      isImageVisible = true;
    });
  }

  uploadFile() async {
    if (_image == null) {
      showToast('파일을 선택하세요!');
      return null;
    }
    Reference ref =
        FirebaseStorage.instance.ref().child('images/${_image?.name}');
    await ref.putFile(File(_image!.path));
    downloadurl = await ref.getDownloadURL();
  }

  _save() async {
    await uploadFile();
    /*if (_image == null || downloadurl == null || controller.text.isEmpty) {
      showToast('데이터 오류 발생');
      return null;
    }*/

    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('memory');
    try {
      DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
      Content content = Content(
          content: controller.text,
          date: dateFormat.format(DateTime.now()),
          downloadurl: downloadurl!);
      await collectionReference.add(content.toJson());
      Navigator.pop(context);
    } catch (e) {
      print('저장에러 $e');
    }
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
                  Visibility(
                    visible: isImageVisible,
                    child: isImageVisible
                        ? Container(
                            height: 200,
                            child: Image.file(File(_image!.path)),
                          )
                        : SizedBox(
                      height: 200,
                      child: Text('파일을 선택해주세요'),
                    ),
                  ),
                  TextField(
                    style: TextStyle(fontSize: 15.0),
                    controller: controller,
                    decoration: InputDecoration(
                        labelText: '사진에 대한 설명',
                        prefixIcon: Icon(Icons.input),
                        border: OutlineInputBorder(),
                        hintText: "글을 입력해주세요."),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('파일선택'),
                      IconButton(
                          onPressed: getGalleryImage,
                          icon: Icon(FontAwesomeIcons.image),),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('업로드'),
                      IconButton(onPressed: _save, icon: Icon(Icons.save)),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  final currentUser = FirebaseAuth.instance;
  bool isPressed = false;

  Future<void> increase(DocumentSnapshot documentSnapshot) async {
    var count = documentSnapshot['like'];
    var plus = count++;
    FirebaseFirestore.instance
        .collection('QuietTime')
        .doc(documentSnapshot.id)
        .update({"like": plus});
  }

  Future<void> decrease(DocumentSnapshot documentSnapshot) async {
    var count = documentSnapshot['like'];
    var minus = count--;
    FirebaseFirestore.instance
        .collection('QuietTime')
        .doc(documentSnapshot.id)
        .update({"like": minus});
  }

  var PressList = new List.filled(50, false, growable: true);

  void likeWrite(DocumentSnapshot documentSnapshot, bool boolLike) {
    FirebaseFirestore.instance
        .collection('QuietTime')
        .doc(documentSnapshot.id)
        .collection('response')
        .doc(currentUser.currentUser!.email.toString())
        .update({"like": boolLike});
  }

  void createWrite(DocumentSnapshot documentSnapshot, bool boolLike) {
    FirebaseFirestore.instance
        .collection('QuietTime')
        .doc(documentSnapshot.id)
        .collection('response')
        .doc(currentUser.currentUser!.email.toString())
        .set({"like": boolLike});
  }

  //var PressList = new List.empty(growable: true);

  //bool first = FirebaseFirestore.instance.collection('QuietTime').get().then((value) => null)

  //var PressList = [true,true,false,true,false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text('Quiet Time',style: TextStyle(fontFamily: 'Billabong'),),
      ),*/
      body: StreamBuilder<QuerySnapshot<Content>>(
        stream: contentsRef.snapshots(),
        builder: (context, streamSnapshot) {
          if (streamSnapshot.hasError) {
            return Center(
              child: Text(streamSnapshot.error.toString()),
            );
          }
          if (!streamSnapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (streamSnapshot.hasData) {
            final data = streamSnapshot.requireData;

            return ListView.builder(
              itemCount: data.docs.length,
              itemBuilder: (context, index) {
                //var PressList = new List<bool>.filled()
                //var PressList = [];

                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                //Timestamp timestamp = documentSnapshot['datetime'] as Timestamp;
                //DateTime date = timestamp.toDate();
                //PressList.addAll([true,true,true,true]);
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
                              Container(
                                height: 40.0,
                                width: 40.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  /*image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: new NetworkImage(
                                          "https://pbs.twimg.com/profile_images/916384996092448768/PF1TSFOE_400x400.jpg")),
                                */
                                ),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                data.docs[index].data().content,
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
                          height: 400,
                          margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                          padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.lightGreen),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.white),
                          child: Image.network(
                              data.docs[index].data().downloadurl)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(PressList[index]
                                    ? Icons.favorite
                                    : Icons.favorite_border),
                                color: PressList[index]
                                    ? Colors.red
                                    : Colors.black,
                                onPressed: () {
                                  //print(PressList[index]);
                                  setState(() {});
                                },
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  FontAwesomeIcons.comment,
                                ),
                              ),
                              /*new SizedBox(
                                width: 20.0,
                              ),*/
                              //new Icon(FontAwesomeIcons.paperPlane),
                              SizedBox(
                                width: 10.0,
                              ),
                              IconButton(
                                  onPressed: () {
                                    _update(documentSnapshot);
                                  },
                                  icon: Icon(FontAwesomeIcons.pencil)),
                              SizedBox(
                                width: 10.0,
                              ),
                              IconButton(
                                  onPressed: () {
                                    //_update(documentSnapshot);
                                  },
                                  icon: Icon(FontAwesomeIcons.eraser)),
                            ],
                          ),
                          //new Icon(FontAwesomeIcons.bookmark)
                        ],
                      ),
                    ),
                    /*Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "Liked ${documentSnapshot['like']}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),*/
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16.0, 16.0, 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 40.0,
                            width: 40.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              /*image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: new NetworkImage(
                                          "https://pbs.twimg.com/profile_images/916384996092448768/PF1TSFOE_400x400.jpg"),
                                    ),*/
                            ),
                          ),
                          Expanded(
                            child: Container(
                              color: Colors.white,
                              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                              child: TextField(
                                cursorColor: Colors.greenAccent,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Add a comment...",
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(data.docs[index].data().date,
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
          Icons.upload,
          color: Colors.lightGreen,
        ),
      ),
      //StreamBuilder로 지속적인 데이터 주고 받음
    );
  }
}
