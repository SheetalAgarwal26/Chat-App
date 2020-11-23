import 'package:task5/helper/Constants.dart';
import 'package:task5/helper/authenticate.dart';
import 'package:task5/models/searchmodel.dart';
import 'package:task5/services/auth.dart';
import 'package:task5/services/database.dart';
import 'package:task5/views/Conversation_screen.dart';
import 'package:task5/views/loginpage.dart';
import 'package:task5/widget/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class searchScreen extends StatefulWidget {
  @override
  _searchScreenState createState() => _searchScreenState();
}

class _searchScreenState extends State<searchScreen> {
  List<searchmodel> newlist = new List<searchmodel>();
  Databasemethods databasemethods = new Databasemethods();
  TextEditingController searchEditingController = new TextEditingController();
  bool _isloading = false;

  fetch() async {
    setState(() {
      _isloading = true;
    });
    Databasemethods obj;
    if (searchEditingController.text.isEmpty) {
      obj = new Databasemethods();
      await obj.getusersByUsernameglobal();
    } else {
      obj = new Databasemethods();
      await obj.getusersByUsername(searchEditingController.text);
    }

    setState(() {
      newlist = obj.searchlist;
      _isloading = !_isloading;
    });
  }

  fetch1() async {
    setState(() {
      _isloading = true;
    });
    Databasemethods obj = new Databasemethods();
    await obj.getusersByUsernameglobal();

    setState(() {
      newlist = obj.searchlist;
      _isloading = !_isloading;
    });
  }

  CreateChatRoomAndSendMessage(String username) {
    if (username != Constants.MyName) {
      String chatroomId = getChatRoomId(username, Constants.MyName);

      List<String> users = [username, Constants.MyName];
      Map<String, dynamic> ChatRoomMap = {
        "users": users,
        "ChatroomId": chatroomId
      };
      databasemethods.CreateChatRoom(chatroomId, ChatRoomMap);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Conversation(
                    chateeeroomid: chatroomId,
                    recipent: username,
                  )));
    }
  }

  Widget SearchList() {
    return Expanded(
      child: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: newlist.length,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return searchTile(
                  newlist[index].username,
                  newlist[index].email,
                );
              },
            ),
    );
  }

  Widget searchTile(final String username, String useremail) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              child: Center(
                  child: Text(
                username.substring(0, 1).toUpperCase(),
                style: TextStyle(color: Colors.black, fontSize: 20),
              )),
              decoration: BoxDecoration(
                  color: Colors.pink[200],
                  borderRadius: BorderRadius.circular(100)),
              width: 40,
              height: 40,
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
                Text(
                  useremail,
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                CreateChatRoomAndSendMessage(username);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.pink[200],
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Message',
                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.account_box,size: 35,),
              onPressed: () {
                fetch1();
              }),
        ],
        backgroundColor: Colors.blue,
        title: Text("My Contacts",style: TextStyle(fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 21),),
      ),
      body: Container(
        decoration: BoxDecoration(
                    color: Colors.black,
                  ),
        child: Column(
          children: [
            Container(
              height: 70,
              color: Colors.grey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: searchEditingController,
                      decoration: InputDecoration(
                          hintText: "Search your contact",
                          hintStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none),
                    )),
                    IconButton(
                        icon: Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          fetch();
                        })
                  ],
                ),
              ),
            ),
            SearchList()
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
