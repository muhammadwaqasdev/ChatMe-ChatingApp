class ChatModel {
  String? messageid;
  String? sender;
  String? message;
  String? imagepic;
  String? type;
  DateTime? cretedon;
  ChatModel(
      {this.messageid,
      this.sender,
      this.message,
      this.type,
      this.cretedon,
      this.imagepic});

  Map<String, dynamic> toMap() {
    return {
      'messageid': messageid,
      'sender': sender,
      'message': message,
      'type': type,
      'cretedon': cretedon,
      'imagepic': imagepic,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      messageid: map['messageid'],
      sender: map['sender'],
      message: map['message'],
      type: map['type'],
      cretedon: map['cretedon'].toDate(),
      imagepic: map['imagepic'],
    );
  }
}
