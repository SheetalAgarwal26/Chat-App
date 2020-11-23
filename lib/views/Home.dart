import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:task5/helper/Constants.dart';
import 'package:task5/helper/authenticate.dart';
import 'package:task5/helper/helperfunction.dart';
import 'package:task5/services/auth.dart';
import 'package:task5/services/database.dart';
import 'package:task5/views/Conversation_screen.dart';
import 'package:task5/views/loginpage.dart';
import 'package:task5/views/search.dart';
import 'package:task5/widget/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Databasemethods databasemethods = new Databasemethods();
  @override
  void initState() {
    getuserinfo();
    getl();
    super.initState();
  }

  getl() {
    databasemethods.savelocation();
  }

  Query collectionReference1;
  getuserinfo() async {
    await HelperFunction.getuserNameSharedPreference().then((value) {
      Constants.MyName = value;
      setState(() {
        collectionReference1 = getinfo();
      });
    });
  }

  AuthMethods authMethods = new AuthMethods();

  @override
  void setState(fn) {
    // TODO: implement setState

    super.setState(fn);
  }

  getinfo() {
    return FirebaseFirestore.instance
        .collection('ChatRomm')
        .where("users", arrayContains: Constants.MyName);
  }

  Widget ChatRoomList() {
    return collectionReference1.snapshots() != null
        ? StreamBuilder(
            stream: collectionReference1.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    if (snapshot.data.docs[index].data()["users"][0] ==
                        Constants.MyName) {
                      return chatTile(
                          snapshot.data.docs[index].data()["users"][1],
                          snapshot.data.docs[index].data()["ChatroomId"]);
                    } else {
                      return chatTile(
                          snapshot.data.docs[index].data()["users"][0],
                          snapshot.data.docs[index].data()["ChatroomId"]);
                    }
                  });
            })
        : Container();
  }

  Widget chatTile(final String username, String chatroomid) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Conversation(
                      chateeeroomid: chatroomid,
                      recipent: username,
                    )));
      },
      child: Container(
       decoration: BoxDecoration(
                    color: Colors.white24,
                    ),
                    
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
           
            children: [
              Container(
                
                child: Center(
                    child: Text(
                  username.substring(0, 1).toUpperCase(),
                  style: TextStyle(color: Colors.black, fontSize: 25),
                )),
                decoration: BoxDecoration(
                    color: Colors.pink[300],
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
                  Container(
                    child: Text(
                      username,
                      style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold,),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: Icon(Icons.menu,
                       color: Colors.white,
                       size: 36.0,),
        backgroundColor: Colors.blue,
        title: Text("Chats",style: TextStyle(fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 21),),
        actions: [
          IconButton(
              icon: Icon(Icons.exit_to_app,size: 30,),
              onPressed: () {
                authMethods.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Authenticate()));
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.message),
          backgroundColor: Colors.blue,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => searchScreen()));
          }),
      body: collectionReference1 != null ? ChatRoomList() : Container(),
    );
  }
}
