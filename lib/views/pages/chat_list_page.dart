import 'package:flutter/material.dart';
import 'package:hire_harmony/component/user_tile.dart';
import 'package:hire_harmony/services/auth_services.dart';
import 'package:hire_harmony/services/chat/chat_services.dart';
import 'package:hire_harmony/views/pages/chat_page.dart';
import 'package:hire_harmony/views/pages/chatePage.dart';

class ChatListPage extends StatelessWidget {
   ChatListPage({super.key});
  final  _chatService = ChatServices();
    AuthServices authService = AuthServicesImpl();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        ),
        body:_buildUserList(),
    

    );
  }


  Widget _buildUserList(){
    return StreamBuilder(
      stream: _chatService.getUserStream(),
       builder: (context,snapshot){
        //error
        if(snapshot.hasError){
          return const Text('error');

        }
        //loading
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator());
          }

          //return list view
          return ListView(
            children: snapshot.data!.map<Widget>((userData)=>_buildUserListItem(userData,context)).toList(),
          );
            

       }
       );
  }

  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
      // التحقق من وجود email و uid في البيانات
  if (userData["email"] == null || userData["uid"] == null) {
    return const SizedBox.shrink(); // إرجاع عنصر فارغ إذا كانت القيم مفقودة
  }
  if (userData["email"] != authService.getCurrentUser()!.email) {
  
    return UserTile(
      text: userData['email'],
      onTap: () {
        // Navigate to the chat page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Chatepage(reciverEmail: userData["email"],reciverID: userData["uid"],),
          ),
        );
      },
    );
  } else {
    // Return an empty widget if the condition is not met
    return Container();
  }
}
}