class MessageModel {
  final String id;
  final String senderId;
  final String message;
  final String? senderPhotoUrl;
  final DateTime dateTime;
  final String senderName; // تم إضافة هذا الحقل

  MessageModel({
    required this.id,
    required this.senderId,
     this.senderPhotoUrl,
    required this.dateTime,
    required this.message,
    required this.senderName, // تأكد من تمرير هذا الحقل في كل مكان
  });
  Map<String, dynamic> toMap() {
  final result = <String, dynamic>{};
  result.addAll({'id': id});
  result.addAll({'senderId': senderId});
  result.addAll({'senderPhotoUrl': senderPhotoUrl});
  result.addAll({ 'dateTime': dateTime.millisecondsSinceEpoch, 
  // Save as timestamp
}); // تحويل DateTime إلى String
  result.addAll({'message': message});
  result.addAll({'senderName': senderName});
  return result;
}

/*
  // تحويل كائن MessageModel إلى خريطة (JSON)
  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({'id': id});
    result.addAll({'senderId': senderId});
    result.addAll({'senderPhotoUrl': senderPhotoUrl});
    result.addAll({'dateTime': dateTime.toIso8601String()});
    result.addAll({'message': message});
    result.addAll({'senderName': senderName}); // أضف هذا الحقل للتحويل
    return result;
  }
*/
  // إنشاء كائن MessageModel من خريطة (JSON)
 /* factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] ?? '',
      senderId: map['senderId'] ?? '',
      senderPhotoUrl: map['senderPhotoUrl'] ?? '',
      message: map['message'] ?? '',
      dateTime: DateTime.fromMicrosecondsSinceEpoch(map['dateTime']),
      senderName: map['senderName'] ?? '', // قم بقراءة الحقل من الخريطة
    );
  }*/
  factory MessageModel.fromMap(Map<String, dynamic> map) {
  return MessageModel(
    id: map['id'] ?? '',
    senderId: map['senderId'] ?? '',
    senderPhotoUrl: map['senderPhotoUrl'] ?? 'https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg',
    message: map['message'] ?? '',
    dateTime: map['dateTime'] is int
        ? DateTime.fromMillisecondsSinceEpoch(map['dateTime'])
        : DateTime.parse(map['dateTime'] ?? DateTime.now().toIso8601String()),
    senderName: map['senderName'] ?? '',
  );
}

}
