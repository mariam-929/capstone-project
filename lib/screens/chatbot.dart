// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class ChatScreen extends StatefulWidget {
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final _controller = TextEditingController();
//   final _auth = FirebaseAuth.instance;
//   var _enteredMessage = '';

//   void _sendMessage() async {
//     FocusScope.of(context).unfocus();
//     final user = _auth.currentUser;
//     final userData = await FirebaseFirestore.instance
//         .collection('Users')
//         .doc(user?.uid)
//         .get();
//     FirebaseFirestore.instance.collection('Chats').add({
//       'text': _enteredMessage,
//       'createdAt': Timestamp.now(),
//       'userId': user?.uid,
//       'username': userData['firstname'],
//     });
//     _controller.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chat Screen'),
//       ),
//       body: Container(
//         child: Column(
//           children: <Widget>[
//             Expanded(
//               child: StreamBuilder(
//                 stream: FirebaseFirestore.instance
//                     .collection('Chats')
//                     .orderBy('createdAt', descending: true)
//                     .snapshots(),
//                 builder: (ctx, chatSnapshot) {
//                   if (chatSnapshot.connectionState == ConnectionState.waiting) {
//                     return Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   }
//                   final chatDocs = chatSnapshot.data!.docs;
//                   return ListView.builder(
//                     reverse: true,
//                     itemCount: chatDocs.length,
//                     itemBuilder: (ctx, index) => MessageBubble(
//                       chatDocs[index]['text'],
//                       chatDocs[index]['username'],
//                       chatDocs[index]['userId'] == _auth.currentUser!.uid,
//                     ),
//                   );
//                 },
//               ),
//             ),
//             Container(
//               margin: EdgeInsets.only(top: 8),
//               padding: EdgeInsets.all(8),
//               child: Row(
//                 children: <Widget>[
//                   Expanded(
//                     child: TextField(
//                       controller: _controller,
//                       decoration:
//                           InputDecoration(labelText: 'Send a message...'),
//                       onChanged: (value) {
//                         setState(() {
//                           _enteredMessage = value;
//                         });
//                       },
//                     ),
//                   ),
//                   IconButton(
//                     color: Theme.of(context).primaryColor,
//                     icon: Icon(Icons.send),
//                     onPressed:
//                         _enteredMessage.trim().isEmpty ? null : _sendMessage,
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class MessageBubble extends StatelessWidget {
//   MessageBubble(
//     this.message,
//     this.username,
//     this.isMe,
//   );
//   final String message;
//   final String username;
//   final bool isMe;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
//       children: <Widget>[
//         Container(
//           decoration: BoxDecoration(
//             color: isMe ? Colors.grey[300] : Theme.of(context).accentColor,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(12),
//               topRight: Radius.circular(12),
//               bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
//               bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
//             ),
//           ),
//           width: 140,
//           padding: EdgeInsets.symmetric(
//             vertical: 10,
//             horizontal: 16,
//           ),
//           margin: EdgeInsets.symmetric(
//             vertical: 4,
//             horizontal: 8,
//           ),
//           child: Column(
//             crossAxisAlignment:
//                 isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//             children: <Widget>[
//               Text(
//                 username,
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: isMe
//                       ? Colors.black
//                       : Theme.of(context).accentTextTheme.headline1!.color,
//                 ),
//               ),
//               Text(
//                 message,
//                 style: TextStyle(
//                   color: isMe
//                       ? Colors.black
//                       : Theme.of(context).accentTextTheme.headline1!.color,
//                 ),
//                 textAlign: isMe ? TextAlign.end : TextAlign.start,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
