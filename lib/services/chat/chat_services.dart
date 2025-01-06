import 'package:hire_harmony/models/message_model.dart';
import 'package:hire_harmony/services/firestore_services.dart';
import 'package:hire_harmony/utils/route/api_paths.dart';

class ChatServices {
  final _firestoreServices = FirestoreService.instance;
  //stream getMessages
  Stream<List<MessageModel>> getMessages() {
    //try and catch
    try {
      //get messages from firestore
      return _firestoreServices.collectionStream(
        path: ApiPaths.messages(),
        builder: (data, documentId) => MessageModel.fromMap(data),
      );
    } catch (e) {
            print('Error fetching messages: $e');

      rethrow;
    }
  }

  Future<void> sendMessage(MessageModel message) async {
    try {
      await _firestoreServices.setData(
        path: ApiPaths.sendMessage(message.id),
        data: message.toMap(),
      );
    } catch (e) {
          print('Error sending message: $e');

      rethrow;
    }
  }
}
