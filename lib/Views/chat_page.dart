import 'package:flutter/material.dart';
import 'package:yap/Models/message.dart';
import 'package:yap/Widgets/chatBuble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yap/Widgets/chatBublefriend.dart';
import 'package:yap/helper/consts.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  static String id = 'ChatPage';

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _controller = ScrollController();

  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessagesCollection);

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var Email = ModalRoute.of(context)!.settings.arguments;
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy(kCreatedAt, descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Message> messagesList = [];

          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messagesList.add(Message.fromjson(snapshot.data!.docs[i]));
          }
          return Scaffold(
            backgroundColor: kPrimaryColor,
            appBar: AppBar(
              centerTitle: true,
              automaticallyImplyLeading: false,
              title: const Text(
                'Yap',
                style: TextStyle(
                  fontFamily: 'QuickSand',
                  fontSize: 30,
                  color: Colors.purple,
                ),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    controller: _controller,
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      return messagesList[index].id == Email
                          ? Chatbuble(
                              message: messagesList[index],
                            )
                          : Chatbublefriend(message: messagesList[index]);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          onSubmitted: (data) {
                            if (controller.text.isNotEmpty) {
                              messages.add(
                                {
                                  kMessage: data,
                                  kCreatedAt: DateTime.now(),
                                  'id': Email,
                                },
                              );
                              controller.clear();
                              _controller.animateTo(
                                0,
                                duration: const Duration(seconds: 1),
                                curve: Curves.easeIn,
                              );
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Send Message',
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                            ),
                            suffixIcon: const Icon(
                              Icons.mic,
                              color: Colors.grey,
                            ),
                            prefixIcon: const Icon(
                              Icons.attach_file,
                              color: Colors.grey,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 210, 210, 210),
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Colors.purple,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 5),
                        child: GestureDetector(
                          onTap: () {
                            if (controller.text.isNotEmpty) {
                              sendMessage(controller.text, Email);
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xffc475f5),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            width: 45,
                            height: 48,
                            child: const Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container(
            color: kPrimaryColor,
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.purple,
              ),
            ),
          );
        }
      },
    );
  }

  void sendMessage(String data, dynamic Email) {
    messages.add(
      {
        kMessage: data,
        kCreatedAt: DateTime.now(),
        'id': Email,
      },
    );
    setState(() {
      controller.clear();
      _controller.animateTo(
        0,
        duration: const Duration(seconds: 1),
        curve: Curves.easeIn,
      );
    });
  }
}
