import 'package:chat_app/widgets/helper/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatefulWidget {
  const ChatMessages({super.key});

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {

  void _setupPushNotification() async {
    final fmc = FirebaseMessaging.instance;
    await fmc.requestPermission();
    final token = await fmc.getToken();

    fmc.subscribeToTopic('chat');
    print(token);
  }

  void deleteMessage(String messageId) async {
  await FirebaseFirestore.instance
      .collection('chat')
      .doc(messageId)
      .delete();
}

void editMessage(String messageId, String newMessage) async {
  await FirebaseFirestore.instance
      .collection('chat')
      .doc(messageId)
      .update({
    'text': newMessage,
    'updatedAt': Timestamp.now(), 
  });
}
  
  @override
  void initState() {
    super.initState();
    _setupPushNotification();

  }
  @override
  Widget build(BuildContext context) {

    final chatList = FirebaseFirestore.instance.collection('chat').orderBy('createdAt', descending: true).snapshots();
    final currentUser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
    stream: chatList, 
    builder: (context, chatSnapshot){

      if(chatSnapshot.connectionState == ConnectionState.waiting){
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      if(!chatSnapshot.hasData || chatSnapshot.data!.docs.isEmpty){
        return  Center(
      child: Text('No Messages', style: TextStyle(color: Colors.black, fontSize: 15),),
      );
      }

      final loadedMessages = chatSnapshot.data!.docs;

      return ListView.builder(
        padding: EdgeInsets.only(
          bottom: 10,

        ),
        reverse: true,
        itemCount: loadedMessages.length,
        itemBuilder: (context, index){

         final currMessgae = loadedMessages[index].data();
         final nextMessgae = index + 1 < loadedMessages.length ? loadedMessages[index + 1].data() : null;

         final currMessageUserID = currMessgae['userId'];

         final nextMessageUserId = nextMessgae != null ? nextMessgae['userId'] : null;

         final nextUserisSame = currMessageUserID == nextMessageUserId;

         final messageId = loadedMessages[index].id;

         if(nextUserisSame) {
          return MessageBubble.next(
            message: currMessgae['text'], 
            isMe: currentUser.uid == currMessageUserID,
             messageId: messageId, 
             timestamp: (currMessgae['createdAt'] as Timestamp).toDate(),
             onDelete: () {
             deleteMessage(messageId);
               },
             onEdit: (newMessage) {
              editMessage(messageId, newMessage);
             },);
         }
         else{
          return MessageBubble.first(
            username: currMessgae['userName'], 
            message: currMessgae['text'], 
            isMe: currentUser.uid == currMessageUserID,
             messageId: messageId, 
             timestamp: (currMessgae['createdAt'] as Timestamp).toDate(),
             onDelete: () {
             deleteMessage(messageId);
               },
             onEdit: (newMessage) {
              editMessage(messageId, newMessage);
             },
            );
         }

        }
        );

    }
    
    );
    
    
   
  }
}