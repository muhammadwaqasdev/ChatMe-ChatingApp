class ChatRoomModel {
  // ignore: non_constant_identifier_names
  String? Chatrromid;
  // ignore: non_constant_identifier_names
  Map<String, dynamic>? Partisipents;
  String? lastmessage;
  DateTime? lastmessagetime;
  ChatRoomModel(
      {
      // ignore: non_constant_identifier_names
      this.Chatrromid,
      // ignore: non_constant_identifier_names
      this.Partisipents,
      this.lastmessage,
      this.lastmessagetime});

  Map<String, dynamic> toMap() {
    return {
      'Chatrromid': Chatrromid,
      'Partisipents': Partisipents,
      'lastmessage': lastmessage,
      'lastmessagetime': lastmessagetime,
    };
  }

  factory ChatRoomModel.fromMap(Map<String, dynamic> map) {
    return ChatRoomModel(
      Chatrromid: map['Chatrromid'],
      Partisipents: Map<String, dynamic>.from(map['Partisipents']),
      lastmessage: map['lastmessage'],
      lastmessagetime: map['lastmessagetime'].toDate(),
    );
  }
}
