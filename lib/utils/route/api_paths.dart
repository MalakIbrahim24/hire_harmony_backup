class ApiPaths {
  static String user(String uid) => 'users/$uid';
  static String controlCard(String uid) => 'controlCards';

  static String sendMessage(String id) => 'messages/$id';
  static String messages() => 'messages/';
}
